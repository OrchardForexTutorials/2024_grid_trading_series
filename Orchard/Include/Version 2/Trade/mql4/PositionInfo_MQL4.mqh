/*

   GridTrader
   PositionInfo_MQL4

   Copyright 2024, Orchard Forex
   https://www.orchardforex.com

*/

#include <Object.mqh>

#include "../../Common/Enums.mqh"

class CPositionInfo : public CObject {

public:
   string             Symbol() { return OrderSymbol(); }
   long               Magic() { return OrderMagicNumber(); }
   ENUM_POSITION_TYPE PositionType() { return ( ENUM_POSITION_TYPE )OrderType(); }
   double             PriceOpen() { return OrderOpenPrice(); }
   ulong              Ticket() { return ( ulong )OrderTicket(); }

   int                PositionsTotal() { return OrdersTotal(); }

   bool               SelectByIndex( int index ) {
      if ( !OrderSelect( index, SELECT_BY_POS, MODE_TRADES ) ) return false;
      if ( OrderType() == ORDER_TYPE_BUY || OrderType() == ORDER_TYPE_SELL ) return true;
      return false;
   }
};
