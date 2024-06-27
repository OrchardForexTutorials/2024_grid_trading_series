/*

   GridTrader
   Input

   Copyright 2024, Orchard Forex
   https://www.orchardforex.com

*/

#include "Config.mqh"

#ifndef app_magic
#define app_magic 123
#endif

//
//	Inputs
//

input int             InpLevelPoints    = 100; //	Trade gap in points

// trading range using moving average

input int             InpRangePeriod    = 14;        // RSI period
input ENUM_TIMEFRAMES InpRangeTimeframe = PERIOD_D1; // RSI timeframe
input double          InpRangeHigh      = 70;        // RSI High
input double          InpRangeLow       = 30;        // RSI Low

//	Now some general trading info
input double          InpVolume         = 0.01;          //	Order size
input string          InpTradeComment   = "Grid Trader"; //	Trade comment
input int             InpMagic          = app_magic;     //	Magic number
