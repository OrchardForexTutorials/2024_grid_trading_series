/*

   GridTrader
   Config

   Copyright 2024, Orchard Forex
   https://www.orchardforex.com

*/

#include <Object.mqh>
#include <Indicators/Trend.mqh>

#include <Orchard/Version 2/Common/Enums.mqh>
#include <Orchard/Version 2/Common/Functions.mqh>
#include <Orchard/Version 2/Expert/LegBase.mqh>
#include <Orchard/Version 2/Trade/TradeCustom.mqh>
#include <Orchard/Version 2/Trade/PositionInfoCustom.mqh>
#include <Orchard/Version 2/Trade/SymbolInfoCustom.mqh>
#include <Orchard/Version 2/Persistence/GVar.mqh>

// Just because the error on undefined annoys me
#ifndef app_magic
#define app_magic 1
#endif

#ifndef app_version
#define app_version "0.000"
#endif
