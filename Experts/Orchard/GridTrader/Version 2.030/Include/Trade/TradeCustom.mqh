/*

   GridTrader
   Trade

   Copyright 2024, Orchard Forex
   https://www.orchardforex.com

*/

#ifdef __MQL4__
#include "mql4/Trade_MQL4.mqh"
#endif
#ifdef __MQL5__
#include <Trade/Trade.mqh>
#endif

class CTradeCustom : public CTrade {

   public:
      bool PositionOpen( const string symbol, const ENUM_ORDER_TYPE order_type, const double volume, const double price, const double sl, const double tp, const string comment,
                         long magic );
};

bool CTradeCustom::PositionOpen( const string symbol, const ENUM_ORDER_TYPE order_type, const double volume, const double price, const double sl, const double tp,
                                 const string comment, long magic ) {

   ulong savedMagic = m_magic;
   SetExpertMagicNumber( magic );
   bool result = CTrade::PositionOpen( symbol, order_type, volume, price, sl, tp, comment );
   SetExpertMagicNumber( savedMagic );

   return result;
}
