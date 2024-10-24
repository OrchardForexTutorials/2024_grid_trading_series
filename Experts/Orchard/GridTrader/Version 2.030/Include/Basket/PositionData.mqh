/*

   CPositionData

   Just keeps track of data from a position

*/

#include <Object.mqh>

#include "../Common/Enums.mqh"

class CPositionData : public CObject {

   protected:
      virtual int               Compare( const CObject *node, const int mode = 0 ) const;
      template <typename T> int CompareValue( T thisValue, T compareValue, int mode ) const;

   public:
      CPositionData();
      ~CPositionData();

      CPositionData     *Clone();
      void               FillFromCurrent();
      void               Zero();

      // These would normally be functions
      ulong              Ticket;
      string             Symbol;
      long               Magic;
      ENUM_POSITION_TYPE PositionType;

      double             OpenPrice;
      double             Profit;
      double             Volume;

      datetime           Time;
};

CPositionData::CPositionData() { Zero(); }

CPositionData::~CPositionData() {}

CPositionData *CPositionData::Clone() {

   CPositionData *data = new CPositionData();

   data.Ticket         = Ticket;
   data.Symbol         = Symbol;
   data.Magic          = Magic;
   data.PositionType   = PositionType;

   data.OpenPrice      = OpenPrice;
   data.Profit         = Profit;
   data.Volume         = Volume;

   data.Time           = Time;

   return data;
}

void CPositionData::FillFromCurrent() {

   Zero();

#ifdef __MQL4__
   Ticket       = OrderTicket();
   Symbol       = OrderSymbol();
   Magic        = OrderMagicNumber();
   PositionType = (ENUM_POSITION_TYPE)OrderType();

   OpenPrice    = OrderOpenPrice();
   Profit       = OrderProfit();
   Volume       = OrderLots();

   Time         = OrderOpenTime();
#endif

#ifdef __MQL5__
   Ticket       = PositionGetInteger( POSITION_TICKET );
   Symbol       = PositionGetString( POSITION_SYMBOL );
   Magic        = PositionGetInteger( POSITION_MAGIC );
   PositionType = ( ENUM_POSITION_TYPE )PositionGetInteger( POSITION_TYPE );

   OpenPrice    = PositionGetDouble( POSITION_PRICE_OPEN );
   Profit       = PositionGetDouble( POSITION_PROFIT );
   Volume       = PositionGetDouble( POSITION_VOLUME );

   Time         = ( datetime )PositionGetInteger( POSITION_TIME );
#endif

}

void CPositionData::Zero() {

   Ticket       = 0;
   Symbol       = "";
   Magic        = 0;
   PositionType = 0;
   OpenPrice    = 0;
   Profit       = 0;
   Volume = 0;
   Time         = 0;
}

int CPositionData::Compare( const CObject *node, const int mode = 0 ) const {
   CPositionData *data = ( CPositionData * )node; // casting for further use

   switch ( mode ) {
      case 1:
      case -1:
         { // Symbol
            return CompareValue( Symbol, data.Symbol, mode );
         }
      case 2:
      case -2:
         { // Ticket
            return CompareValue( Ticket, data.Ticket, mode );
         }
      case 3:
      case -3:
         { // OpenPrice
            return CompareValue( OpenPrice, data.OpenPrice, mode );
         }
      case 4:
      case -4:
         { // Time
            return CompareValue( Time, data.Time, mode );
         }
      case 5:
      case -5:
         { // Profit
            return CompareValue( Profit, data.Profit, mode );
         }
      case 6:
      case -6:
         { // symbol then profit
            int result = CompareValue( Symbol, data.Symbol, mode );
            if ( result == 0 ) result = CompareValue( OpenPrice, data.OpenPrice, mode );
            return result;
         }
   }

   return 0;
}

template <typename T> int CPositionData::CompareValue( T thisValue, T compareValue, int mode ) const {

   int result = ( thisValue > compareValue ) ? 1 : ( thisValue < compareValue ) ? -1 : 0;
   if ( mode < 0 ) result *= -1;
   return result;
}
