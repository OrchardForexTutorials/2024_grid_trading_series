/*

   GridTrader
   Main

   Copyright 2024, Orchard Forex
   https://www.orchardforex.com

   History
   v1.000
      Original version
      simple buy and sell at levels

   v1.001
      Just convert to MQL4 and minor code tidy

   v1.003
      Clean code and remove buy/sell options

   v2.000
      Updated include file names (broke earlier code, duh)
      Some refactoring to ease any future dumb mistakes
      Moved common functions into common files
      Kept persistence from earlier branch
      Added input to select trading direction

   v2.010
      Add trading range by manual entry

   v2.011
      Trading range based on 2 trend indicators (ma)

*/

#define app_version "2.011"
#define app_magic   240502011

#include "Config.mqh"
#include "Input.mqh"
#include "Leg.mqh"

CLeg  *BuyLeg;
CLeg  *SellLeg;

CGVar *GV;

int    HandleHigh;
int    HandleLow;

;
int OnInit() {

   string key = Symbol() + "_" + string( InpMagic );
   GV         = new CGVar( key );

   BuyLeg     = new CLeg( POSITION_TYPE_BUY );
   SellLeg    = new CLeg( POSITION_TYPE_SELL );

   // Trend indicator trading range
   HandleHigh = iMA( Symbol(), InpRangeTimeframe, InpRangePeriod, 0, MODE_SMA, PRICE_HIGH );
   HandleLow  = iMA( Symbol(), InpRangeTimeframe, InpRangePeriod, 0, MODE_SMA, PRICE_LOW );

   BuyLeg.SetRangeIndicator( HandleHigh, 0, 1 );
   SellLeg.SetRangeIndicator( HandleLow, 0, 1 );

   return INIT_SUCCEEDED;
}

void OnDeinit( const int reason ) {

   IndicatorRelease( HandleHigh );
   IndicatorRelease( HandleLow );

   delete BuyLeg;
   delete SellLeg;
   delete GV;
}

void OnTick() {

   if ( !IsTradeAllowed() ) return;

   if ( IsNewBar() ) {
   }

   BuyLeg.On_Tick();
   SellLeg.On_Tick();

   return;
}
