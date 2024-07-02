/*

   GridTrader
   SymbolInfo_mql4

   Copyright 2024, Orchard Forex
   https://www.orchardforex.com

*/

#include <Object.mqh>

class CSymbolInfo : public CObject {

protected:
   string  m_name;

   MqlTick m_tick;

public:
   CSymbolInfo( void );
   ~CSymbolInfo( void );

   bool   Refresh();
   bool   RefreshRates();

   double Ask() { return m_tick.ask; }
   double Bid() { return m_tick.bid; }
};

CSymbolInfo::CSymbolInfo( void ) { m_name = Symbol(); }

CSymbolInfo::~CSymbolInfo( void ) {}

bool CSymbolInfo::Refresh( void ) { return true; }

bool CSymbolInfo::RefreshRates( void ) {
   ::RefreshRates();
   return SymbolInfoTick( m_name, m_tick );
}