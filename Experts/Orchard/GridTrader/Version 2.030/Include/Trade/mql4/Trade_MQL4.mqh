/*

   GridTrader
   Trade_MQL4

   Copyright 2024, Orchard Forex
   https://www.orchardforex.com

*/

#include <Object.mqh>
#include "PositionInfo_mql4.mqh"

class CTrade : public CObject {

   protected:
      ulong m_ticket;
      ulong m_magic;

   public:
      CTrade();

      void SetExpertMagicNumber( long magic ) { m_magic = magic; }

      bool PositionClose( ulong ticket );
      bool PositionClosePartial( ulong ticket, double volume );
      bool PositionOpen( string symbol, ENUM_ORDER_TYPE type, double volume, double price, double sl, double tp, string comment );
};

CTrade::CTrade() { m_magic = 0; }

bool CTrade::PositionClose( ulong ticket ) {

   if ( !OrderSelect( ( int )ticket, SELECT_BY_TICKET ) ) return false;                 // not found
   if ( OrderCloseTime() > 0 ) return false;                                            // already closed
   if ( OrderType() != ORDER_TYPE_BUY && OrderType() != ORDER_TYPE_SELL ) return false; // Not a market order
   return ( OrderClose( ( int )ticket, OrderLots(), OrderClosePrice(), 0 ) );
}

bool CTrade::PositionClosePartial( ulong ticket, double volume ) {

   if ( !OrderSelect( ( int )ticket, SELECT_BY_TICKET ) ) return false;                 // not found
   if ( OrderCloseTime() > 0 ) return false;                                            // already closed
   if ( OrderType() != ORDER_TYPE_BUY && OrderType() != ORDER_TYPE_SELL ) return false; // Not a market order
   if ( volume > OrderLots() ) volume = OrderLots();
   return ( OrderClose( ( int )ticket, volume, OrderClosePrice(), 0 ) );
}

bool CTrade::PositionOpen( string symbol, ENUM_ORDER_TYPE type, double volume, double price, double sl, double tp, string comment ) {

   m_ticket = 0;
   if ( type != ORDER_TYPE_BUY && type != ORDER_TYPE_SELL ) return false;

   m_ticket = OrderSend( symbol, type, volume, price, 0, sl, tp, comment, ( int )m_magic );
   return ( m_ticket > 0 );
}
