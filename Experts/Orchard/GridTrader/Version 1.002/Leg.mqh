/*

   GridTrader
   Leg

   Copyright 2024, Orchard Forex
   https://www.orchardforex.com

*/

#include "Config.mqh"
#include "Input.mqh"

class CLeg {

protected:
   CPositionInfoCustom mPositionInfo;
   CSymbolInfoCustom   mSymbolInfo;
   CTradeCustom        mTrade;

   ENUM_POSITION_TYPE  mPositionType;
   double              mLevelSize;
   ENUM_ORDER_TYPE     mOrderType;

   int                 mCount;
   double              mEntryPrice;
   double              mExitPrice;

   void                CloseAll( double price );
   void                OpenTrade( double price );
   void                Recount();
   void                Loop( MqlTick &lastTick );

public:
   CLeg( ENUM_POSITION_TYPE type );

   void On_Tick( ENUM_ORDER_TYPE trendCurrent );
};

CLeg::CLeg( ENUM_POSITION_TYPE type ) {

   mSymbolInfo.Refresh();

   mPositionType = type;
   mLevelSize    = mSymbolInfo.PointsToDouble( InpLevelPoints );
   mOrderType    = ( ENUM_ORDER_TYPE )mPositionType;

   Recount();
}

void CLeg::On_Tick( ENUM_ORDER_TYPE trendCurrent ) {

   if ( !mSymbolInfo.RefreshRates() ) {
      Print( "refresh failed" );
      return;
   }

   double ask = mSymbolInfo.Ask();
   double bid = mSymbolInfo.Bid();

   //	First process the closing rules
   //	On the first run there may be no trades but there is no harm
   if ( mPositionType == POSITION_TYPE_BUY && bid >= mExitPrice ) {
      CloseAll( bid );
   }
   else if ( mPositionType == POSITION_TYPE_SELL && ask <= mExitPrice ) {
      CloseAll( ask );
   }

   //	Finally the new trade entries
   if ( trendCurrent != mOrderType ) return; // No trading if trend does not match

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

   for ( int i = mPositionInfo.Total() - 1; i >= 0; i-- ) {

      if ( !mPositionInfo.SelectByIndex( i, Symbol(), InpMagic, mPositionType ) ) continue;

      ulong ticket = mPositionInfo.Ticket();

      if ( mPositionInfo.PositionType() == POSITION_TYPE_BUY && ( price - mLevelSize ) >= mPositionInfo.PriceOpen() ) {
         mTrade.PositionClose( ticket );
         continue;
      }

      if ( mPositionInfo.PositionType() == POSITION_TYPE_SELL && ( price + mLevelSize ) <= mPositionInfo.PriceOpen() ) {
         mTrade.PositionClose( ticket );
         continue;
      }
   }
   Recount();
}

void CLeg::OpenTrade( double price ) {

   mTrade.PositionOpen( Symbol(), mOrderType, InpVolume, price, 0, 0, InpTradeComment, InpMagic );
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

   for ( int i = mPositionInfo.Total() - 1; i >= 0; i-- ) {

      if ( !mPositionInfo.SelectByIndex( i, Symbol(), InpMagic, mPositionType ) ) continue;

      mCount++;
      if ( high == 0 || mPositionInfo.PriceOpen() > high ) high = mPositionInfo.PriceOpen();
      if ( low == 0 || mPositionInfo.PriceOpen() < low ) low = mPositionInfo.PriceOpen();
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
