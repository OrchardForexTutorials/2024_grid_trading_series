/*

   GridTrader
   SymbolInfo

   Copyright 2024, Orchard Forex
   https://www.orchardforex.com

*/

#include <Trade/SymbolInfo.mqh>

class CSymbolInfoCustom : public CSymbolInfo {

public:
   double PointsToDouble( int points ) { return points * Point(); }
};
