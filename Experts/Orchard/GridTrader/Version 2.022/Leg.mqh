/*

   GridTrader
   Leg

   Copyright 2024, Orchard Forex
   https://www.orchardforex.com

*/

#include "Config.mqh"
#include "Input.mqh"
#include "Functions.mqh"

class CLeg : public CLegBase {

protected:
   double mLevelSize;

   int    mCount;
   double mEntryPrice;
   double mExitPrice;
   double mProfitOpen;
   double mVolumeOpen;

   bool   On_Tick_Close();
   bool   On_Tick_Open();

   void   CloseProfitTrades( double price );
   void   OpenTrade( double price );
   void   Recount();

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

   double priceClose = PriceClose();
   CloseProfitTrades( priceClose );

   return true;
}

bool CLeg::On_Tick_Open() {

   double priceOpen = PriceOpen();
   if ( mCount == 0 || LE( priceOpen, mEntryPrice ) ) {
      OpenTrade( priceOpen );
   }

   return true;
}

void CLeg::CloseProfitTrades( double priceClose ) {

   for ( int i = mPositionInfo.Total() - 1; i >= 0; i-- ) {

      if ( !mPositionInfo.SelectByIndex( i, Symbol(), InpMagic, mPositionType ) ) continue;

      ulong  ticket           = mPositionInfo.Ticket();

      double minimumExitPrice = Add( mPositionInfo.PriceOpen(), mLevelSize );
      if ( LT( priceClose, minimumExitPrice ) ) continue;

      mTrade.PositionClose( ticket );
   }
   Recount();
}

void CLeg::OpenTrade( double priceOpen ) {

   double volume = GetVolume( InpVolume, InpVolumeIncrementFactor, InpVolumeIncrementTrades, mCount );

   mTrade.PositionOpen( Symbol(), mOrderType, volume, priceOpen, 0, 0, mTradeComment );
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
   mProfitOpen = 0;
   mVolumeOpen = 0;

   double head = 0;
   double tail = 0;

   for ( int i = mPositionInfo.Total() - 1; i >= 0; i-- ) {

      if ( !mPositionInfo.SelectByIndex( i, Symbol(), mMagic, mPositionType ) ) continue;

      mCount++;

      mProfitOpen += mPositionInfo.Profit();
      mProfitOpen += mPositionInfo.Commission();
      mProfitOpen += mPositionInfo.Swap();

      mVolumeOpen += mPositionInfo.Volume();

      double priceOpen = mPositionInfo.PriceOpen();
      if ( head == 0 || GT( priceOpen, head ) ) head = priceOpen;
      if ( tail == 0 || LT( priceOpen, tail ) ) tail = priceOpen;
   }

   if ( mCount > 0 ) {
      mEntryPrice = Sub( tail, mLevelSize );
      mExitPrice  = Add( tail, mLevelSize );
   }
}
