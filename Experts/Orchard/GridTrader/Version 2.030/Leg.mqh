/*

   GridTrader
   Leg

   Copyright 2024, Orchard Forex
   https://www.orchardforex.com

*/

#include "Config.mqh"
#include "Input.mqh"

class CLeg : public CLegBase {

   protected:
      double          mLevelSize;

      int             mCount;
      double          mEntryPrice;
      double          mExitPrice;

      CPositionBasket Basket;

      bool            On_Tick_Close();
      bool            On_Tick_Open();

      bool            CloseWithTrim( double closePrice );
      void            OpenTrade( double price );
      void            Recount();

   public:
      CLeg( int type );

      virtual void On_Tick();
};

CLeg::CLeg( int type ) : CLegBase( type ) {

   Magic( InpMagic );
   TradeComment( InpTradeComment + " " + app_version );
   TradeDirection( InpTradeDirection );
   mLevelSize = mSymbolInfo.PointsToDouble( InpLevelPoints );

   Recount();
}

void CLeg::On_Tick() { CLegBase::On_Tick(); }

bool CLeg::On_Tick_Close() {

   if ( mCount == 0 ) return true;

   double closePrice = PriceClose();
   if ( LT( closePrice, mExitPrice ) ) return true; // not up to the exit price for the level

   if ( CloseWithTrim( closePrice ) ) Recount();

   return true;
}

bool CLeg::On_Tick_Open() {

   double priceOpen = PriceOpen();
   if ( mCount == 0 || LE( priceOpen, mEntryPrice ) ) {
      OpenTrade( priceOpen );
   }

   return true;
}

bool CLeg::CloseWithTrim( double closePrice ) {

   bool           result = false;

   CPositionData *tail   = Basket.GetFirstNode();
   if ( tail == NULL ) return result;

   if ( !mTrade.PositionClose( tail.Ticket ) ) return result; // did not close
   result = true;

   if ( mCount <= 2 ) return result; // Only was one position, nothing to trim

   CPositionData *head = Basket.GetLastNode();
   
   double partialVolume = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MIN);

   mTrade.PositionClosePartial( head.Ticket, partialVolume );

   return result;
}

void CLeg::OpenTrade( double priceOpen ) {

   if (mTrade.PositionOpen( Symbol(), mOrderType, InpVolume, priceOpen, 0, 0, mTradeComment )) {
	   Recount();
	}
}

/*
 *	Recount()
 *
 *	Mainly for restarts
 *	Scans currently open trades and rebuilds the position
 */
void CLeg::Recount() {

   int sortMode = ( mOrderType == ORDER_TYPE_BUY ) ? 3 : -3;
   Basket.Fill( sortMode, Symbol(), mMagic, mPositionType );

   mEntryPrice = 0;
   mExitPrice  = 0;

   mCount      = Basket.Total();
   if ( mCount == 0 ) return;

   CPositionData *tail = Basket.GetFirstNode();
   CPositionData *next = tail.Next();

   mEntryPrice = Sub( tail.OpenPrice, mLevelSize );
   mExitPrice  = ( mCount > 1 ) ? next.OpenPrice : Add( tail.OpenPrice, mLevelSize );

}
