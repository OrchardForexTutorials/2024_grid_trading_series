/*

   GridTrader
   Leg

   Copyright 2024, Orchard Forex
   https://www.orchardforex.com

*/

#include "Config.mqh"
#include "Input.mqh"

class CLeg {

private:
   ENUM_POSITION_TYPE mPositionType;
   double             mLevelSize;
   ENUM_ORDER_TYPE    mOrderType;

   int                mCount;
   double             mEntryPrice;
   double             mExitPrice;

   void               CloseAll( double price );
   void               OpenTrade( double price );
   void               Recount();
   void               Loop( MqlTick &lastTick );

public:
   CLeg( ENUM_POSITION_TYPE type );

   void On_Tick();
};

CLeg::CLeg( ENUM_POSITION_TYPE type ) {

   mPositionType = type;

   mLevelSize    = SymbolInfo.PointsToDouble( InpLevelPoints );

   mOrderType    = ( ENUM_ORDER_TYPE )mPositionType;

   Recount();
}

void CLeg::On_Tick() {

   double ask = SymbolInfo.Ask();
   double bid = SymbolInfo.Bid();

   //	First process the closing rules
   //	On the first run there may be no trades but there is no harm
   if ( mPositionType == POSITION_TYPE_BUY && bid >= mExitPrice ) {
      CloseAll( bid );
   }
   else if ( mPositionType == POSITION_TYPE_SELL && ask <= mExitPrice ) {
      CloseAll( ask );
   }

   //	Finally the new trade entries
   if ( mPositionType == POSITION_TYPE_BUY ) {
      if ( mCount == 0 || ask <= mEntryPrice ) {
         OpenTrade( ask );
      }
   }
   else {
      if ( mCount == 0 || bid >= mEntryPrice ) {
         OpenTrade( bid );
      }
   }
}

void CLeg::CloseAll( double price ) {

   for ( int i = PositionInfo.Total() - 1; i >= 0; i-- ) {

      if ( !PositionInfo.SelectByIndex( i, Symbol(), InpMagic, mPositionType ) ) continue;

      ulong ticket = PositionInfo.Ticket();

      if ( PositionInfo.PositionType() == POSITION_TYPE_BUY && ( price - mLevelSize ) >= PositionInfo.PriceOpen() ) {
         Trade.PositionClose( ticket );
         continue;
      }

      if ( PositionInfo.PositionType() == POSITION_TYPE_SELL && ( price + mLevelSize ) <= PositionInfo.PriceOpen() ) {
         Trade.PositionClose( ticket );
         continue;
      }
   }
   Recount();
}

void CLeg::OpenTrade( double price ) {

   Trade.PositionOpen( Symbol(), mOrderType, InpVolume, price, 0, 0, InpTradeComment, InpMagic );
   Recount();
}

/*
 *	Recount()
 *
 *	Mainly for restarts
 *	Scans currently open trades and rebuilds the position
 */
void CLeg::Recount() {

   mCount       = 0;
   mEntryPrice  = 0;
   mExitPrice   = 0;

   double high  = 0;
   double low   = 0;

   double lead  = 0;
   double trail = 0;

   for ( int i = PositionInfo.Total() - 1; i >= 0; i-- ) {

      if ( !PositionInfo.SelectByIndex( i, Symbol(), InpMagic, mPositionType ) ) continue;

      mCount++;
      if ( high == 0 || PositionInfo.PriceOpen() > high ) high = PositionInfo.PriceOpen();
      if ( low == 0 || PositionInfo.PriceOpen() < low ) low = PositionInfo.PriceOpen();
   }

   if ( mCount > 0 ) {
      if ( mPositionType == POSITION_TYPE_BUY ) {
         mEntryPrice = low - mLevelSize;
         mExitPrice  = low + mLevelSize;
      }
      else {
         mEntryPrice = high + mLevelSize;
         mExitPrice  = high - mLevelSize;
      }
   }
}
