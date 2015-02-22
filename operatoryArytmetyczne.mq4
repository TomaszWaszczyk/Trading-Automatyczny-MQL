//+------------------------------------------------------------------+
//|                                        operatoryArytmetyczne.mq4 |
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
   int a = 2;
   int b = 10;
   
   //suma
   int suma = a + b;
   Print("Suma " + suma);
   
   //roznica
   int roznica = a - b;
   Print("Roznica " + roznica);
   
   //iloczyn
   int iloczyn = a * b;
   Print("Iloczyn " + iloczyn);
   
   //iloraz
   int iloraz = b / a;
   Print("Iloraz " +iloraz);
   
   //zmiana znaku
   int zmianaZnaku = -a;
   Print("Zmiana znaku " + zmianaZnaku);
   
   //reszta z dzielenia - modulo
   int resztaZDzielenia = b % a;
   Print("Reszta z dzielenia " + resztaZDzielenia);
}
//+------------------------------------------------------------------+
