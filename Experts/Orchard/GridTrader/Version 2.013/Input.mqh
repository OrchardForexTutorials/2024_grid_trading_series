/*

   GridTrader
   Input

   Copyright 2024, Orchard Forex
   https://www.orchardforex.com

*/

#include "Config.mqh"

//
//	Inputs
//

input ENUM_TRADE_DIRECTION InpTradeDirection    = TRADE_DIRECTION_BOTH; // Trade direction

input int                  InpLevelPoints       = 100; //	Trade gap in points

// trading range using moving average
input int                  InpRangePeriod       = 200;         // RSI period
input ENUM_TIMEFRAMES      InpRangeTimeframe    = PERIOD_D1;   // RSI timeframe
input ENUM_APPLIED_PRICE   InpRangeAppliedPrice = PRICE_CLOSE; // RSI Applied price
input int                  InpRangeIndex        = 1;           // Candle to check for range
input double               InpRangeBuyLimit     = 70.0;        // Range buy limit
input double               InpRangeSellLimit    = 30.0;        // Range sell limit

//	Now some general trading info
input double               InpVolume            = 0.01;          //	Order size
input string               InpTradeComment      = "Grid Trader"; //	Trade comment
input int                  InpMagic             = app_magic;     //	Magic number
