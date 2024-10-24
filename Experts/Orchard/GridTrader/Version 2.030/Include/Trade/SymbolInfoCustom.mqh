/*

   GridTrader
   SymbolInfo

   Copyright 2024, Orchard Forex
   https://www.orchardforex.com

*/

#ifdef __MQL4__
#include "mql4/SymbolInfo_MQL4.mqh"
#endif
#ifdef __MQL5__
#include <Trade/SymbolInfo.mqh>
#endif

class CSymbolInfoCustom : public CSymbolInfo {

   public:
      double PointsToDouble( int points ) { return points * Point(); }
};
