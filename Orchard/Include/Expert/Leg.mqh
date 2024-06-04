/*

   GridTrader
   Leg

   Copyright 2024, Orchard Forex
   https://www.orchardforex.com

*/

#include <Object.mqh>

#include "../Trade/PositionInfo.mqh"
#include "../Trade/SymbolInfo.mqh"
#include "../Trade/Trade.mqh"

class CLegBase : public CObject {

protected:
   CPositionInfoCustom mPositionInfo;
   CSymbolInfoCustom   mSymbolInfo;
   CTradeCustom        mTrade;

   ENUM_POSITION_TYPE  mPositionType;
   ENUM_ORDER_TYPE     mOrderType;

   void                Loop( MqlTick &lastTick );

   double              Add( double value1, double value2 ) { return ( mPositionType == POSITION_TYPE_BUY ) ? value1 + value2 : value1 - value2; }
   double              Sub( double value1, double value2 ) { return ( mPositionType == POSITION_TYPE_BUY ) ? value1 - value2 : value1 + value2; }
   double              Dif( double value1, double value2 ) { return ( mPositionType == POSITION_TYPE_BUY ) ? value1 - value2 : value2 - value1; }

   bool                GE( double value1, double value2 ) { return ( mPositionType == POSITION_TYPE_BUY ) ? value1 >= value2 : value2 >= value1; }
   bool                GT( double value1, double value2 ) { return ( mPositionType == POSITION_TYPE_BUY ) ? value1 > value2 : value2 > value1; }
   bool                LE( double value1, double value2 ) { return ( mPositionType == POSITION_TYPE_BUY ) ? value1 <= value2 : value2 <= value1; }
   bool                LT( double value1, double value2 ) { return ( mPositionType == POSITION_TYPE_BUY ) ? value1 < value2 : value2 < value1; }

   double              PriceOpen() { return ( mPositionType == POSITION_TYPE_BUY ) ? mSymbolInfo.Ask() : mSymbolInfo.Bid(); }
   double              PriceClose() { return ( mPositionType == POSITION_TYPE_BUY ) ? mSymbolInfo.Bid() : mSymbolInfo.Ask(); }

public:
   CLegBase( int type );

   void On_Tick();
};

CLegBase::CLegBase( int type ) {

   mSymbolInfo.Refresh();

   mPositionType = ( ENUM_POSITION_TYPE )type;
   mOrderType    = ( ENUM_ORDER_TYPE )type;
}

void CLegBase::On_Tick() {

   if ( !mSymbolInfo.RefreshRates() ) {
      Print( "refresh failed" );
      return;
   }
}
