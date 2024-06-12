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

input int    InpLevelPoints  = 100; //	Trade gap in points

// The equity target
input double InpProfitTarget = 100.00; // Equity profit target in deposit currency

//	Now some general trading info
input double InpVolume       = 0.01;          //	Order size
input string InpTradeComment = "Grid Trader"; //	Trade comment
input int    InpMagic        = app_magic;     //	Magic number
