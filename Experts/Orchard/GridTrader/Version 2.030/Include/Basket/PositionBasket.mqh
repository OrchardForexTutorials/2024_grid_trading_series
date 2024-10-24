/*

   CPositionBasket

   Just keeps track of data from a position

*/

#include <Arrays/List.mqh>

#include "../Trade/PositionInfoCustom.mqh"
#include "PositionData.mqh"

class CPositionBasket : public CList {

	protected:
	
		CPositionInfoCustom PositionInfo;
		
   public:
      CPositionBasket();
      ~CPositionBasket();

      int  Add( CPositionData *data );
      // void Fill();
      // void Fill(string symbol);
      // void Fill(string symbol, long magic);
      void Fill( int sortMode = 0, string symbol = "", long magic = -1, ENUM_POSITION_TYPE type = -1 );
};

CPositionBasket::CPositionBasket() {}

CPositionBasket::~CPositionBasket() {}

int  CPositionBasket::Add( CPositionData *data ) { return CList::Add( data ); }

void CPositionBasket::Fill( int sortMode = 0, string symbol = "", long magic = -1, ENUM_POSITION_TYPE type = -1 ) {

   Clear();

	for (int i=PositionInfo.Total() - 1; i>=0; i--) {
	
   	if (!PositionInfo.SelectByIndex(i, symbol, magic, type)) continue;

	   CPositionData *data = new CPositionData();
      data.FillFromCurrent();
      Add( data );

   }

   Sort( sortMode );
}
