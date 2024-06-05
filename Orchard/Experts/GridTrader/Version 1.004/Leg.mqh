/*

   GridTrader
   Leg

   Copyright 2024, Orchard Forex
   https://www.orchardforex.com

*/

#include <Orchard/Expert/Leg.mqh>

#include "Config.mqh"
#include "Input.mqh"

class CLeg : public CLegBase {

protected:
   double mLevelSize;
   double mStopLoss;
   double mTakeProfit;

   int    mCount;
   double mHeadEntryPrice;
   double mTailEntryPrice;
   // double              mExitPrice;
   double mStopLossExitPrice;
   double mTakeProfitExitPrice;

   void   CloseAll( double price );
   void   OpenTrade( double price );
   void   Recount();

public:
   CLeg( int type );

   void On_Tick();
};

CLeg::CLeg( int type ) : CLegBase( type ) {

   mLevelSize  = mSymbolInfo.PointsToDouble( InpLevelPoints );
   mStopLoss   = mSymbolInfo.PointsToDouble( InpStopLossPoints );
   mTakeProfit = mSymbolInfo.PointsToDouble( InpTakeProfitPoints );

   if ( mTakeProfit == 0 ) mTakeProfit = mLevelSize;

   Recount();
}

void CLeg::On_Tick() {

   if ( !mSymbolInfo.RefreshRates() ) {
      Print( "refresh failed" );
      return;
   }

   //	First process the closing rules
   //	On the first run there may be no trades but there is no harm
   double priceClose = PriceClose();
   if ( ( mStopLoss > 0 && LE( priceClose, mStopLossExitPrice ) ) //
        || ( mTakeProfit > 0 && GE( priceClose, mTakeProfitExitPrice ) ) ) {
      CloseAll( priceClose );
   }

   //	Finally the new trade entries
   double priceOpen = PriceOpen();
   if ( mCount == 0 || LE( priceOpen, mTailEntryPrice ) || GE( priceOpen, mHeadEntryPrice ) ) {
      OpenTrade( priceOpen );
   }
}

void CLeg::CloseAll( double priceClose ) {

   for ( int i = mPositionInfo.Total() - 1; i >= 0; i-- ) {

      if ( !mPositionInfo.SelectByIndex( i, Symbol(), InpMagic, mPositionType ) ) continue;

      ulong  ticket    = mPositionInfo.Ticket();
      double priceOpen = mPositionInfo.PriceOpen();

      if ( ( mStopLoss > 0 && LE( priceClose, Sub( priceOpen, mStopLoss ) ) ) //
           || ( mTakeProfit > 0 && GE( priceClose, Add( priceOpen, mTakeProfit ) ) ) ) {
         mTrade.PositionClose( ticket );
      }
   }
   Recount();
}

void CLeg::OpenTrade( double priceOpen ) {

   mTrade.PositionOpen( Symbol(), mOrderType, InpVolume, priceOpen, 0, 0, InpTradeComment, InpMagic );
   Recount();
}

/*
 *	Recount()
 *
 *	Mainly for restarts
 *	Scans currently open trades and rebuilds the position
 */
void CLeg::Recount() {

   mCount               = 0;
   mHeadEntryPrice      = 0;
   mTailEntryPrice      = 0;
   mStopLossExitPrice   = 0;
   mTakeProfitExitPrice = 0;

   double head          = 0;
   double tail          = 0;

   for ( int i = mPositionInfo.Total() - 1; i >= 0; i-- ) {

      if ( !mPositionInfo.SelectByIndex( i, Symbol(), InpMagic, mPositionType ) ) continue;

      mCount++;
      double priceOpen = mPositionInfo.PriceOpen();
      if ( head == 0 || GT( priceOpen, head ) ) head = priceOpen;
      if ( tail == 0 || LT( priceOpen, tail ) ) tail = priceOpen;
   }

   if ( mCount > 0 ) {
      mHeadEntryPrice      = Add( head, mLevelSize );
      mTailEntryPrice      = Sub( tail, mLevelSize );

      mTakeProfitExitPrice = Add( tail, mTakeProfit );
      mStopLossExitPrice   = ( mStopLoss == 0 ) ? 0 : Sub( head, mStopLoss );
   }
}
