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

   v1.002
      Add a trend filter based on consecutive candles

*/

#define app_version "1.002"

#include "Config.mqh"
#include "Input.mqh"
#include "Leg.mqh"

CLeg *BuyLeg;
CLeg *SellLeg;

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

   if ( !TradeAllowed() ) return;

   ENUM_ORDER_TYPE trendCurrent = TrendRefresh( InpTrendPeriod );

   BuyLeg.On_Tick( trendCurrent );
   SellLeg.On_Tick( trendCurrent );

   return;
}

bool TradeAllowed() {

   //	Is trading and auto trading allowed
   return ( TerminalInfoInteger( TERMINAL_TRADE_ALLOWED ) //
            && MQLInfoInteger( MQL_TRADE_ALLOWED )        //
            && AccountInfoInteger( ACCOUNT_TRADE_EXPERT ) //
            && AccountInfoInteger( ACCOUNT_TRADE_ALLOWED ) );
}

ENUM_ORDER_TYPE TrendRefresh( int count ) {

   MqlRates rates[];
   int      trendCurrent = -1;
   CopyRates( Symbol(), InpTrendTimeframe, 0, count, rates );
   ArraySetAsSeries( rates, true );
   for ( int i = 0; i < count; i++ ) {
      int trend = ( rates[i].close > rates[i].open ) ? ORDER_TYPE_BUY : ( rates[i].close < rates[i].open ) ? ORDER_TYPE_SELL : -1;

      if ( i == 0 ) {

         trendCurrent = trend;
      }

      if ( trendCurrent != trend ) {

         return -1;
      }
   }

   return ( ENUM_ORDER_TYPE )trendCurrent;
}