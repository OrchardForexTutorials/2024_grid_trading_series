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

   long                mMagic;

   ENUM_POSITION_TYPE  mPositionType;
   ENUM_ORDER_TYPE     mOrderType;

   // Trading ranges
   double              mRangeValue;
   int                 mRangeHandle;
   int                 mRangeBuffer;

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

   void         On_Tick();

   virtual bool Close(); // Close everything for the leg

   long         Magic() { return mMagic; }
   long         Magic( long value ) {
      mMagic = value;
      mTrade.SetExpertMagicNumber( value );
      return value;
   }

   void SetRangeValue( double value ) { mRangeValue = value; }
   void SetRangeIndicator( int handle, int buffer ) {
      mRangeHandle = handle;
      mRangeBuffer = buffer;
   }
};

CLegBase::CLegBase( int type ) {

   mSymbolInfo.Refresh();

   mMagic        = 0;

   mPositionType = ( ENUM_POSITION_TYPE )type;
   mOrderType    = ( ENUM_ORDER_TYPE )type;
}

void CLegBase::On_Tick() {

   if ( !mSymbolInfo.RefreshRates() ) {
      Print( "refresh failed" );
      return;
   }
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
