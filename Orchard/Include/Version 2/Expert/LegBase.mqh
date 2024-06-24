/*

   GridTrader
   Leg

   Copyright 2024, Orchard Forex
   https://www.orchardforex.com

*/

#include <Object.mqh>

#include "../Common/Enums.mqh"
#include "../Trade/PositionInfoCustom.mqh"
#include "../Trade/SymbolInfoCustom.mqh"
#include "../Trade/TradeCustom.mqh"

class CLegBase : public CObject {

protected:
   CPositionInfoCustom  mPositionInfo;
   CSymbolInfoCustom    mSymbolInfo;
   CTradeCustom         mTrade;

   long                 mMagic;
   ENUM_TRADE_DIRECTION mTradeDirection;
   string               mTradeComment;

   ENUM_POSITION_TYPE   mPositionType;
   ENUM_ORDER_TYPE      mOrderType;

   // Trading ranges
   double               mRangeValue;

   virtual bool         On_Tick_Close() = 0;
   virtual bool         On_Tick_Open()  = 0;

   double               Add( double value1, double value2 ) { return ( mPositionType == POSITION_TYPE_BUY ) ? value1 + value2 : value1 - value2; }
   double               Sub( double value1, double value2 ) { return ( mPositionType == POSITION_TYPE_BUY ) ? value1 - value2 : value1 + value2; }
   double               Dif( double value1, double value2 ) { return ( mPositionType == POSITION_TYPE_BUY ) ? value1 - value2 : value2 - value1; }

   bool                 GE( double value1, double value2 ) { return ( mPositionType == POSITION_TYPE_BUY ) ? value1 >= value2 : value2 >= value1; }
   bool                 GT( double value1, double value2 ) { return ( mPositionType == POSITION_TYPE_BUY ) ? value1 > value2 : value2 > value1; }
   bool                 LE( double value1, double value2 ) { return ( mPositionType == POSITION_TYPE_BUY ) ? value1 <= value2 : value2 <= value1; }
   bool                 LT( double value1, double value2 ) { return ( mPositionType == POSITION_TYPE_BUY ) ? value1 < value2 : value2 < value1; }

   double               PriceOpen() { return ( mPositionType == POSITION_TYPE_BUY ) ? mSymbolInfo.Ask() : mSymbolInfo.Bid(); }
   double               PriceClose() { return ( mPositionType == POSITION_TYPE_BUY ) ? mSymbolInfo.Bid() : mSymbolInfo.Ask(); }

public:
   CLegBase( int type );

   virtual void On_Tick();

   virtual bool Close(); // Close everything for the leg

   long         Magic() { return mMagic; }
   long         Magic( long value ) {
      mMagic = value;
      mTrade.SetExpertMagicNumber( value );
      return value;
   }

   string TradeComment() { return mTradeComment; }
   string TradeComment( string value ) {
      mTradeComment = value;
      return value;
   }

   ENUM_TRADE_DIRECTION TradeDirection() { return mTradeDirection; }
   ENUM_TRADE_DIRECTION TradeDirection( ENUM_TRADE_DIRECTION value ) {
      mTradeDirection = value;
      return value;
   }

   void SetRangeValue( double value ) { mRangeValue = value; }
};

CLegBase::CLegBase( int type ) {

   mSymbolInfo.Refresh();

   mMagic          = 0;
   mTradeDirection = TRADE_DIRECTION_NONE;

   mPositionType   = ( ENUM_POSITION_TYPE )type;
   mOrderType      = ( ENUM_ORDER_TYPE )type;
}

void CLegBase::On_Tick() {

   if ( !mSymbolInfo.RefreshRates() ) {
      Print( "refresh failed" );
      return;
   }

   //	First process the closing rules
   //	On the first run there may be no trades but there is no harm
   if ( !On_Tick_Close() ) return;

   // no need to go further if not trading in this direction
   if ( mTradeDirection != TRADE_DIRECTION_BOTH && ( int )mTradeDirection != ( int )mPositionType ) return;

   //	Finally the new trade entries
   if ( !On_Tick_Open() ) return;
}

bool CLegBase::Close() {

   bool result = true;
   for ( int i = mPositionInfo.Total() - 1; i >= 0; i-- ) {

      if ( !mPositionInfo.SelectByIndex( i, Symbol(), mMagic, mPositionType ) ) continue;

      ulong ticket = mPositionInfo.Ticket();
      result &= mTrade.PositionClose( ticket );
   }

   return result;
}
