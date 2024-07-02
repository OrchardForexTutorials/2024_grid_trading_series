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

   v1.006
      Add restart capability

*/

#define app_version "1.006"
#define app_magic   240501006

#include "Config.mqh"
#include "Input.mqh"
#include "Leg.mqh"

CLeg  *BuyLeg;
CLeg  *SellLeg;

CGVar *GV;

double EquityStart;

;
int OnInit() {

   string key   = "GridTrader";
   GV           = new CGVar( key );

   // Just to make version tracking easier
   TradeComment = InpTradeComment + " " + app_version;

   EquityStart  = GetEquityStart( 0 );
   if ( EquityStart == 0 ) EquityStart = SetEquityStart( AccountInfoDouble( ACCOUNT_EQUITY ) );

   BuyLeg  = new CLeg( POSITION_TYPE_BUY );
   SellLeg = new CLeg( POSITION_TYPE_SELL );

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
      EquityStart = GetEquityStart( AccountInfoDouble( ACCOUNT_EQUITY ) );
   }

   double equity = AccountInfoDouble( ACCOUNT_EQUITY );
   double profit = equity - EquityStart;

   if ( profit >= InpEquityTarget ) {
      BuyLeg.Close();
      SellLeg.Close();
      EquityStart = SetEquityStart( AccountInfoDouble( ACCOUNT_EQUITY ) );
   }

   BuyLeg.On_Tick();
   SellLeg.On_Tick();

   return;
}

#define GV_EQUITY_START "EquityStart"
double GetEquityStart( double value ) { return GV.Get( GV_EQUITY_START, value ); }
double SetEquityStart( double value ) { return GV.Set( GV_EQUITY_START, value ); }

bool   IsTradeAllowed() {

   //	Is trading and auto trading allowed
   return ( TerminalInfoInteger( TERMINAL_TRADE_ALLOWED ) //
            && MQLInfoInteger( MQL_TRADE_ALLOWED )        //
            && AccountInfoInteger( ACCOUNT_TRADE_EXPERT ) //
            && AccountInfoInteger( ACCOUNT_TRADE_ALLOWED ) );
}

bool IsNewBar() {

   static datetime previous_time = 0;
   datetime        current_time  = iTime( Symbol(), Period(), 0 );
   if ( previous_time != current_time ) {
      previous_time = current_time;
      return true;
   }
   return false;
}
