//+------------------------------------------------------------------+
//|                                            operatoryLogiczne.mq4 |
//|                                                  Tomasz Waszczyk |
//|                                         https://www.waszczyk.com |
//+------------------------------------------------------------------+
#property copyright "Tomasz Waszczyk"
#property link      "https://www.waszczyk.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+


void OnStart()
{  
   if(true){
      Print("Prawda: Uczy sie operatorow logicznych w MQL");
   }
   
   if(false){
      Print("Falsz: Tego tekstu nie zobaczymy w konsoli Meta Trader");
   }
   
   int a = 5;
   int b = 10;
   
   if(a == 5 && b == 10){
      Print("Koniunkcja: Sprawdzamy czy a = 5 oraz b = 10");
   }
   
   if(a == 6 && b == 10){
      Print("Koniunkcja: Sprawdzamy czy a = 5 oraz b = 10");
   }
   
   if(a != 6){
      Print("Rozne od: zmienna a nie jest rowne 6- wyrazenie prawdziwe poniewaz a = 5, 5 != 6");
   }
   
   // alternatywa czyli aby petla sie wykonala jedno z wyrazen musi byc spelnione
   if(a == 6 || b == 10){
      Print("Alternatywa: sprawdzamy czy a = 5 lub b = 10 ");
   }
   
   
}
//+------------------------------------------------------------------+
