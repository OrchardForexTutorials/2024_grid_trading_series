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
   double mAverageProfit;
   ulong  mHeadTicket;

   bool   On_Tick_Close();
   bool   On_Tick_Open();

   void   CloseAverage();
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

   Recount(); // There are more efficient ways to do this but to get a result ...
              // Software development is a 2 step process, remember?

   if ( mAverageProfit < mLevelSize ) return true;

   CloseAverage();

   return true;
}

bool CLeg::On_Tick_Open() {

   double priceOpen = PriceOpen();
   if ( mCount == 0 || LE( priceOpen, mEntryPrice ) ) {
      OpenTrade( priceOpen );
   }

   return true;
}

void CLeg::CloseAverage() {

   double priceClose       = PriceClose();
   double maximumPriceOpen = Sub( priceClose, mLevelSize );

   for ( int i = mPositionInfo.Total() - 1; i >= 0; i-- ) {

      if ( !mPositionInfo.SelectByIndex( i, Symbol(), mMagic, mPositionType ) ) continue;
      if ( mPositionInfo.Ticket() != mHeadTicket && GT( mPositionInfo.PriceOpen(), maximumPriceOpen ) ) continue;

      ulong ticket = mPositionInfo.Ticket();
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

   mCount                  = 0;
   mEntryPrice             = 0;
   mExitPrice              = 0;
   mProfitOpen             = 0;
   mVolumeOpen             = 0;
   mHeadTicket             = 0;
   mAverageProfit          = 0;

   double priceClose       = PriceClose();
   double maximumPriceOpen = Sub( priceClose, mLevelSize );

   // First loop just looks for the lead trade, based on open price
   double headPrice        = 0;
   double tailPrice        = 0;
   for ( int i = mPositionInfo.Total() - 1; i >= 0; i-- ) {

      if ( !mPositionInfo.SelectByIndex( i, Symbol(), mMagic, mPositionType ) ) continue;

      double priceOpen = mPositionInfo.PriceOpen();
      if ( headPrice == 0 || GT( priceOpen, headPrice ) ) {
         headPrice   = priceOpen;
         mVolumeOpen = mPositionInfo.Volume();
         mProfitOpen = mPositionInfo.Volume() * Dif( priceClose, priceOpen );
         mHeadTicket = mPositionInfo.Ticket();
         mCount      = 1;
      }
      if ( tailPrice == 0 || LT( priceOpen, tailPrice ) ) tailPrice = priceOpen;
   }

   // Get the total profit for qualifying trades, not the head
   for ( int i = mPositionInfo.Total() - 1; i >= 0; i-- ) {

      if ( !mPositionInfo.SelectByIndex( i, Symbol(), mMagic, mPositionType ) ) continue;
      if ( mPositionInfo.Ticket() == mHeadTicket ) continue;

      double priceOpen = mPositionInfo.PriceOpen();
      if ( GT( priceOpen, maximumPriceOpen ) ) continue;

      double volume = mPositionInfo.Volume();
      double profit = volume * Dif( priceClose, priceOpen );

      mCount++;

      mProfitOpen += profit;
      mVolumeOpen += volume;
   }

   mAverageProfit = mProfitOpen / mVolumeOpen;

   if ( mCount > 0 ) {
      mEntryPrice = Sub( tailPrice, mLevelSize );
      mExitPrice  = Add( tailPrice, mLevelSize );
   }
}
