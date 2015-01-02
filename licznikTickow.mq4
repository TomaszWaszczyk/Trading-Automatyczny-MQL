//+------------------------------------------------------------------+
//|                                                licznikTickow.mq4 |
//|                                                  Tomasz Waszczyk |
//|                                            www.blog.waszczyk.com |
//+------------------------------------------------------------------+
#property copyright "Tomasz Waszczyk"
#property link      "www.blog.waszczyk.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int Count = 0;

int OnInit()
  {
//---
   Alert ("Funkcja init() wywolana na poczatku");    // Alert
   //return(0);                                      
//---
   return(INIT_SUCCEEDED);                            // Wyjscie z init()
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   Alert("Wyjscie");
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
  double aktualnaCena = Bid;
  licznikTickow(); // Wywolanie funkcji licznikTickow();
  Alert("Nowy tick- zmiana ceny: ",Count,"   Cena Ask to: ", Ask);

  }
//+------------------------------------------------------------------+

void licznikTickow()
{
   Count++; // Inkrementacja zmiennej Count;
}