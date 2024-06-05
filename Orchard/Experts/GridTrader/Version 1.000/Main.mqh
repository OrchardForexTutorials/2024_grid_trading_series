/*

   GridTrader
   Main

   Copyright 2024, Orchard Forex
   https://www.orchardforex.com

   History
   v1.000
      Original version
      simple buy and sell at levels

*/

#define app_version "1.000"
#define app_magic   240501000

#include "Config.mqh"
#include "Input.mqh"
#include "Leg.mqh"

CLeg *BuyLeg;
CLeg *SellLeg;

;
int OnInit() {

   if ( !SymbolInfo.Refresh() ) return INIT_FAILED;

   BuyLeg  = new CLeg( POSITION_TYPE_BUY );
   SellLeg = new CLeg( POSITION_TYPE_SELL );

   return INIT_SUCCEEDED;
}

void OnDeinit( const int reason ) {
   delete BuyLeg;
   delete SellLeg;
}

void OnTick() {

   if ( !TradeAllowed() ) return;
   if ( !SymbolInfo.RefreshRates() ) {
      Print( "refresh failed" );
      return;
   }

   BuyLeg.On_Tick();
   SellLeg.On_Tick();

   return;
}

bool TradeAllowed() {

   //	Is trading and auto trading allowed
   return ( TerminalInfoInteger( TERMINAL_TRADE_ALLOWED ) //
            && MQLInfoInteger( MQL_TRADE_ALLOWED )        //
            && AccountInfoInteger( ACCOUNT_TRADE_EXPERT ) //
            && AccountInfoInteger( ACCOUNT_TRADE_ALLOWED ) );
}
