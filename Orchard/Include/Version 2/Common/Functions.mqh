/*

   Common/Functions

   Copyright 2024, Orchard Forex
   https://www.orchardforex.com

*/

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
