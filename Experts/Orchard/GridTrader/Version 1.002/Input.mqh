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

//	V2 grid trading is simple, we just need spacing between trades
//		and lot sizes
input int             InpLevelPoints    = 100; //	Trade gap in points

// v1.002 trend filter
input ENUM_TIMEFRAMES InpTrendTimeframe = PERIOD_D1; // Trend timeframe
input int             InpTrendPeriod    = 3;         // Trend consecutive candles

//	Now some general trading info
input double          InpVolume         = 0.01;          //	Order size
input string          InpTradeComment   = "Grid Trader"; //	Trade comment
input int             InpMagic          = 242424;        //	Magic number
