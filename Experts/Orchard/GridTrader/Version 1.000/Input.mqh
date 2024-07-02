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
input int    InpLevelPoints  = 100; //	Trade gap in points

//	Now some general trading info
input double InpVolume       = 0.01;          //	Order size
input string InpTradeComment = "Grid Trader"; //	Trade comment
input int    InpMagic        = 242424;        //	Magic number
