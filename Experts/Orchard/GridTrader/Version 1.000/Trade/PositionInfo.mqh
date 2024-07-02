/*

   GridTrader
   PositionInfo

   Copyright 2024, Orchard Forex
   https://www.orchardforex.com

*/

#include <Trade/PositionInfo.mqh>

class CPositionInfoCustom : public CPositionInfo {

public:
   bool SelectByIndex( const int index, const string symbol ) {
      if ( !CPositionInfo::SelectByIndex( index ) ) return false;
      return ( this.Symbol() == symbol );
   }
   bool SelectByIndex( const int index, const string symbol, const long magic ) {
      if ( !this.SelectByIndex( index, symbol ) ) return false;
      return ( this.Magic() == magic );
   }
   bool SelectByIndex( const int index, const string symbol, const long magic, int type ) {
      if ( !this.SelectByIndex( index, symbol, magic ) ) return false;
      return ( this.PositionType() == type );
   }

   int Total() { return PositionsTotal(); }
};
