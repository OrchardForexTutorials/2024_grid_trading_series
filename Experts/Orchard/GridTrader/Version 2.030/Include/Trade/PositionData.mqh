/*

   GridTrader
   PositionData

   Copyright 2024, Orchard Forex
   https://www.orchardforex.com

*/

#include <Object.mqh>

class CPositionData : public CObject {

   protected:
      double mOpenPrice;
      ulong  mTicket;
      double mVolume;

   public:
      CPositionData();

      void   Fill();
      void   Zero();

      double OpenPrice() { return mOpenPrice; }
      ulong  Ticket() { return mTicket; }
      double Volume() { return mVolume; }
};

CPositionData::CPositionData( void ) { Zero(); }

#ifdef __MQL4__

void CPositionData::Fill() {

   mOpenPrice = OrderOpenPrice();
   mTicket    = OrderTicket();
   mVolume    = OrderLots();
}

#endif

#ifdef __MQL5__

void CPositionData::Fill() {

   mOpenPrice = PositionGetDouble( POSITION_PRICE_OPEN );
   mTicket    = PositionGetInteger( POSITION_TICKET );
   mVolume    = PositionGetDouble( POSITION_VOLUME );
}

#endif

void CPositionData::Zero() {

   mOpenPrice = 0;
   mTicket    = 0;
   mVolume    = 0;
}
