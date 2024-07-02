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

   v2.012
      MT4 version of 2.011

   v2.013
      Replace trend indicator with oscillator (RSI)

*/

#define app_version "2.012"
#define app_magic   240502012

#include "Config.mqh"
#include "Input.mqh"
#include "Leg.mqh"

CLeg  *BuyLeg;
CLeg  *SellLeg;

CGVar *GV;

CiRSI *Indicator;

;
int OnInit() {

   TesterHideIndicators( false );

   string key = Symbol() + "_" + string( InpMagic );
   GV         = new CGVar( key );

   BuyLeg     = new CLeg( POSITION_TYPE_BUY );
   SellLeg    = new CLeg( POSITION_TYPE_SELL );

   // Trend indicator trading range
   Indicator  = new CiRSI;
   Indicator.Create( Symbol(), InpRangeTimeframe, InpRangePeriod, InpRangeAppliedPrice );

   BuyLeg.SetRangeIndicatorObject( Indicator, 0, InpRangeIndex );
   BuyLeg.SetRangeValue( InpRangeBuyLimit );

   SellLeg.SetRangeIndicatorObject( Indicator, 0, InpRangeIndex );
   SellLeg.SetRangeValue( InpRangeSellLimit );

   return INIT_SUCCEEDED;
}

void OnDeinit( const int reason ) {

   delete Indicator;

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
