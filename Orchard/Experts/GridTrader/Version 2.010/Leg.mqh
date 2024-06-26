/*

   GridTrader
   Leg

   Copyright 2024, Orchard Forex
   https://www.orchardforex.com

*/

#include <Orchard/Version 2/Expert/LegBase.mqh>

#include "Config.mqh"
#include "Input.mqh"

class CLeg : public CLegBase {

protected:
   double mLevelSize;

   int    mCount;
   double mEntryPrice;
   double mExitPrice;

   bool   On_Tick_Close();
   bool   On_Tick_Open();

   void   CloseAll( double price );
   void   OpenTrade( double price );
   void   Recount();

   bool   IsRangeOK( double price );

public:
   CLeg( int type );

   void On_Tick();
};

CLeg::CLeg( int type ) : CLegBase( type ) {

	Magic(InpMagic);
	TradeComment(InpTradeComment + " " + app_version);
	TradeDirection(InpTradeDirection);
   mLevelSize = mSymbolInfo.PointsToDouble( InpLevelPoints );

   Recount();
}

void CLeg::On_Tick() { CLegBase::On_Tick(); }

bool CLeg::On_Tick_Close() {

   double priceClose = PriceClose();
   if ( GE( priceClose, mExitPrice ) ) {
      CloseAll( priceClose );
   }

   return true;
}

bool CLeg::On_Tick_Open() {

   double priceOpen = PriceOpen();

   // Range check
   if ( !IsRangeOK( priceOpen ) ) return true;

   if ( mCount == 0 || LE( priceOpen, mEntryPrice ) ) {
      OpenTrade( priceOpen );
   }

   return true;
}

void CLeg::CloseAll( double priceClose ) {

   for ( int i = mPositionInfo.Total() - 1; i >= 0; i-- ) {

      if ( !mPositionInfo.SelectByIndex( i, Symbol(), InpMagic, mPositionType ) ) continue;

      ulong  ticket    = mPositionInfo.Ticket();
      double priceOpen = mPositionInfo.PriceOpen();

      if ( GE( priceClose, Add( priceOpen, mLevelSize ) ) ) {
         mTrade.PositionClose( ticket );
      }
   }
   Recount();
}

void CLeg::OpenTrade( double priceOpen ) {

   mTrade.PositionOpen( Symbol(), mOrderType, InpVolume, priceOpen, 0, 0, mTradeComment, InpMagic );
   Recount();
}

/*
 *	Recount()
 *
 *	Mainly for restarts
 *	Scans currently open trades and rebuilds the position
 */
void CLeg::Recount() {

   mCount      = 0;
   mEntryPrice = 0;
   mExitPrice  = 0;

   double head = 0;
   double tail = 0;

   for ( int i = mPositionInfo.Total() - 1; i >= 0; i-- ) {

      if ( !mPositionInfo.SelectByIndex( i, Symbol(), InpMagic, mPositionType ) ) continue;

      mCount++;
      double priceOpen = mPositionInfo.PriceOpen();
      if ( head == 0 || GT( priceOpen, head ) ) head = priceOpen;
      if ( tail == 0 || LT( priceOpen, tail ) ) tail = priceOpen;
   }

   if ( mCount > 0 ) {
      mEntryPrice = Sub( tail, mLevelSize );
      mExitPrice  = Add( tail, mLevelSize );
   }
}

bool CLeg::IsRangeOK( double price ) {

   // for manual range
   if ( mRangeValue > 0 && GT( price, mRangeValue ) ) return false;
   return true;
}
