//+------------------------------------------------------------------+
//|                                        pierwszyExpertAdvisor.mq4 |
//|                                                  Tomasz Waszczyk |
//|                                            www.blog.waszczyk.com |
//+------------------------------------------------------------------+
#property copyright "Tomasz Waszczyk"
#property link      "www.blog.waszczyk.com"
#property version   "1.00"
#property strict
//--- input parameters
input string   zmiennaZewnetrzna="Witaj �wiecie";
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   MessageBox(zmiennaZewnetrzna, "Zmieniona nazwa naszego okna");
   EventSetTimer(60);
      
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();
      
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
   
  }
//+------------------------------------------------------------------+
