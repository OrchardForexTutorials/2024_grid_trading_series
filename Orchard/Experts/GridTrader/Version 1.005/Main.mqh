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

   v1.005
      Equity grab, close all on equity target

*/

#define app_version "1.005"
#define app_magic   240501005

#include "Config.mqh"
#include "Input.mqh"
#include "Leg.mqh"

CLeg  *BuyLeg;
CLeg  *SellLeg;

double EquityStart;
;
int OnInit() {

   // Just to make version tracking easier
   TradeComment = InpTradeComment + " " + app_version;

   EquityStart  = AccountInfoDouble( ACCOUNT_EQUITY );

   BuyLeg       = new CLeg( POSITION_TYPE_BUY );
   SellLeg      = new CLeg( POSITION_TYPE_SELL );

   return INIT_SUCCEEDED;
}

void OnDeinit( const int reason ) {
   delete BuyLeg;
   delete SellLeg;
}

void OnTick() {

   if ( !TradeAllowed() ) return;

   double equity = AccountInfoDouble( ACCOUNT_EQUITY );
   double profit = equity - EquityStart;
   if ( profit >= InpProfitTarget ) {
      BuyLeg.Close();
      SellLeg.Close();
      EquityStart = AccountInfoDouble( ACCOUNT_EQUITY );
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
