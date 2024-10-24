/*


   Global Variables

   Copyright 2024, Orchard Forex
   https://www.orchardforex.com

*/

#include <Object.mqh>

class CGVar : public CObject {

   protected:
      string mKey;

      string GetKey( string subKey );

   public:
      CGVar( string key );

      double Get( string subKey, double defValue = 0 );
      double Set( string subKey, double value );
};

CGVar::CGVar( string key ) { mKey = key; }

string CGVar::GetKey( string subKey ) {

   string key = mKey + "_" + subKey;
   return key;
}

double CGVar::Get( string subKey, double defValue = 0 ) {

   double value = defValue;
   string key   = GetKey( subKey );
   if ( !GlobalVariableGet( key, value ) ) value = defValue;
   return value;
}

double CGVar::Set( string subKey, double value ) {

   string key = GetKey( subKey );
   GlobalVariableSet( key, value );
   return value;
}
