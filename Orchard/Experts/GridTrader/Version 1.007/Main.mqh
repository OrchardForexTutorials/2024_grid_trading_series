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

   v1.007
      Add multi symbol capability

*/

#define app_version "1.007"
#define app_magic   240501007

#include "Config.mqh"
#include "Input.mqh"
#include "Leg.mqh"

CLeg               *BuyLeg;
CLeg               *SellLeg;

CPositionInfoCustom PositionInfo;

CGVar              *GV;

const bool          UseSimpleEquity = false;
double              EquityStart;
datetime            ProfitStartTime;
;
int OnInit() {

   string key   = UseSimpleEquity ? "GridTrader" : Symbol() + "_" + string( InpMagic );

   GV           = new CGVar( key );

   // Just to make version tracking easier
   TradeComment = InpTradeComment + " " + app_version;

   EquityStart  = GetEquityStart( 0 );
   if ( EquityStart == 0 ) EquityStart = SetEquityStart( AccountInfoDouble( ACCOUNT_EQUITY ) );

   ProfitStartTime = GetProfitStartTime( 0 );
   if ( ProfitStartTime == 0 ) ProfitStartTime = SetProfitStartTime( TimeCurrent() );

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
      EquityStart     = GetEquityStart( AccountInfoDouble( ACCOUNT_EQUITY ) );
      ProfitStartTime = GetProfitStartTime( TimeCurrent() );
   }

   double equity = AccountInfoDouble( ACCOUNT_EQUITY );
   double profit = UseSimpleEquity ? equity - EquityStart : GetProfit();

   if ( profit >= InpEquityTarget ) {
      BuyLeg.Close();
      SellLeg.Close();
      EquityStart     = SetEquityStart( AccountInfoDouble( ACCOUNT_EQUITY ) );
      ProfitStartTime = SetProfitStartTime( TimeCurrent() );
   }

   BuyLeg.On_Tick();
   SellLeg.On_Tick();

   return;
}

#define GV_EQUITY_START "EquityStart"
double GetEquityStart( double value ) { return GV.Get( GV_EQUITY_START, value ); }
double SetEquityStart( double value ) { return GV.Set( GV_EQUITY_START, value ); }

#define GV_PROFIT_START_TIME "ProfitStartTime"
datetime GetProfitStartTime( datetime value ) { return ( datetime )GV.Get( GV_PROFIT_START_TIME, value ); }
datetime SetProfitStartTime( datetime value ) { return ( datetime )GV.Set( GV_PROFIT_START_TIME, ( double )value ); }

double   GetProfit() {

   double profit = GetProfitClosed() + GetProfitOpen();
   return profit;
}

double GetProfitClosed() {

   double profit = 0;
   HistorySelect( ProfitStartTime + 1, TimeCurrent() );
   int total = HistoryDealsTotal();
   for ( int i = 0; i < total; i++ ) {

      ulong ticket = HistoryDealGetTicket( i );

      if ( ticket == 0 ) continue;
      if ( HistoryDealGetString( ticket, DEAL_SYMBOL ) != Symbol() ) continue;
      if ( HistoryDealGetInteger( ticket, DEAL_MAGIC ) != InpMagic ) continue;

      if ( HistoryDealGetInteger( ticket, DEAL_ENTRY ) != DEAL_ENTRY_OUT ) continue;
      // if (HistoryDealGetInteger(ticket, DEAL_TIME)<=ProfitStartTime) continue;
      profit += HistoryDealGetDouble( ticket, DEAL_PROFIT );
      profit += HistoryDealGetDouble( ticket, DEAL_COMMISSION );
      profit += HistoryDealGetDouble( ticket, DEAL_SWAP );
   }
   return profit;
}

double GetProfitOpen() {

   double profit = 0;
   for ( int i = PositionsTotal() - 1; i >= 0; i-- ) {
      if ( !PositionInfo.SelectByIndex( i, Symbol(), InpMagic ) ) continue;
      profit += PositionInfo.Profit();
      profit += PositionInfo.Commission();
      profit += PositionInfo.Swap();
   }
   return profit;
}

bool IsTradeAllowed() {

   //	Is trading and auto trading allowed
   return ( TerminalInfoInteger( TERMINAL_TRADE_ALLOWED ) //
            && MQLInfoInteger( MQL_TRADE_ALLOWED )        //
            && AccountInfoInteger( ACCOUNT_TRADE_EXPERT ) //
            && AccountInfoInteger( ACCOUNT_TRADE_ALLOWED ) );
}

bool IsNewBar() {

   static datetime previous_time = 0;
   return IsNewBar( Symbol(), ( ENUM_TIMEFRAMES )Period(), previous_time );
}

bool IsNewBar( string symbol, ENUM_TIMEFRAMES timeframe, datetime &previous_time ) {

   datetime current_time = iTime( symbol, timeframe, 0 );
   if ( previous_time != current_time ) {
      previous_time = current_time;
      return true;
   }
   return false;
}
