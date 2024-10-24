/*

   GridTrader
   Functions

   Copyright 2024, Orchard Forex
   https://www.orchardforex.com

*/

#include "Config.mqh"

double GetVolume( double volumeInitial, double volumeIncrement, int stepCount, int count ) {

   if ( volumeIncrement == 0 ) return volumeInitial;

   // volume increment is specified in number of lots to increment
   int    steps  = int( count / stepCount ); // How many steps to increment by
   double volume = volumeInitial + ( steps * volumeIncrement );
   volume        = NormalizeVolume( volume );
   return volume;
}

double NormalizeVolume( double volume ) { // This is very basic

   double volumeStep = SymbolInfoDouble( Symbol(), SYMBOL_VOLUME_STEP );
   double volumeMin  = SymbolInfoDouble( Symbol(), SYMBOL_VOLUME_MIN );

   volume            = volumeStep * int( volume / volumeStep );
   if ( volume < volumeMin ) volume = volumeMin;

   return volume;
}
