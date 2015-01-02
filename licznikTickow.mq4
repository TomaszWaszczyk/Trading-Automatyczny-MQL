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
   //return(0);                                      // Wyjscie z init()
//---
   return(INIT_SUCCEEDED);
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
  Count++;
  Alert("Nowy tick- zmiana ceny: ",Count,"   Cena Ask to: ", Ask);

  }
//+------------------------------------------------------------------+
