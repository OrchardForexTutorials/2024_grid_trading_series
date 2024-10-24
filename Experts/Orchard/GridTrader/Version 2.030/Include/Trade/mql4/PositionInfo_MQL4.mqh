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
      double             Commission() { return OrderCommission(); }
      long               Magic() { return OrderMagicNumber(); }
      ENUM_POSITION_TYPE PositionType() { return ( ENUM_POSITION_TYPE )OrderType(); }
      double             PriceOpen() { return OrderOpenPrice(); }
      double             Profit() { return OrderProfit(); }
      double             Swap() { return OrderSwap(); }
      string             Symbol() { return OrderSymbol(); }
      ulong              Ticket() { return ( ulong )OrderTicket(); }
      double             Volume() { return OrderLots(); }

      int                PositionsTotal() { return OrdersTotal(); }

      bool               SelectByIndex( int index ) {
         if ( !OrderSelect( index, SELECT_BY_POS, MODE_TRADES ) ) return false;
         if ( OrderType() == ORDER_TYPE_BUY || OrderType() == ORDER_TYPE_SELL ) return true;
         return false;
      }
};
