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

   v2.000 https://youtu.be/lEtf8oblpF4
      Updated include file names (broke earlier code, duh)
      Some refactoring to ease any future dumb mistakes
      Moved common functions into common files
      Kept persistence from earlier branch
      Added input to select trading direction

   v2.030
   	Updated include files - just for tutorial management
      Partial close head trade

*/

#define app_version "2.030"
#define app_magic   240500000

#include "Config.mqh"
#include "Input.mqh"
#include "Leg.mqh"

CLeg *BuyLeg;
CLeg *SellLeg;

// CGVar *GV;

;
int OnInit() {

   BuyLeg  = new CLeg( POSITION_TYPE_BUY );
   SellLeg = new CLeg( POSITION_TYPE_SELL );

   return INIT_SUCCEEDED;
}

void OnDeinit( const int reason ) {
   delete BuyLeg;
   delete SellLeg;
}

void OnTick() {

   if ( !IsTradeAllowed() ) return;

   if ( IsNewBar() ) {
   }

   BuyLeg.On_Tick();
   SellLeg.On_Tick();

   return;
}
