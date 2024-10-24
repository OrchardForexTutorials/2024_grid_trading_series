/*

   GridTrader
   Config

   Copyright 2024, Orchard Forex
   https://www.orchardforex.com

*/

#include <Object.mqh>

//
//	These are just here because it's easier to manage the
//	tutorial versions. You probably want them as global includes with
//	#include <Orchard/...>"
//
#include "Include/Common/Enums.mqh"
#include "Include/Common/Functions.mqh"

#include "Include/Basket/PositionBasket.mqh" // https://youtu.be/0oeBuDfvSPs
#include "Include/Expert/LegBase.mqh"
#include "Include/Trade/TradeCustom.mqh"
#include "Include/Trade/PositionInfoCustom.mqh"
#include "Include/Trade/SymbolInfoCustom.mqh"
////#include <Orchard/Version 2/Persistence/GVar.mqh>

// Just because the error on undefined annoys me
#ifndef app_magic
#define app_magic 1
#endif

#ifndef app_version
#define app_version "0.000"
#endif
