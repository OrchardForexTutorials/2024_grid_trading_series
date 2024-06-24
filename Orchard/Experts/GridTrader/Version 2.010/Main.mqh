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

*/

#define app_version "2.010"
#define app_magic   240502010

#include "Config.mqh"
#include "Input.mqh"
#include "Leg.mqh"

CLeg  *BuyLeg;
CLeg  *SellLeg;

CGVar *GV;

;
int OnInit() {

   string key = Symbol() + "_" + string( InpMagic );
   GV         = new CGVar( key );

   BuyLeg     = new CLeg( POSITION_TYPE_BUY );
   SellLeg    = new CLeg( POSITION_TYPE_SELL );

   // Manual trading range
   BuyLeg.SetRangeValue( InpRangeHigh );
   SellLeg.SetRangeValue( InpRangeLow );

   return INIT_SUCCEEDED;
}

void OnDeinit( const int reason ) {
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
