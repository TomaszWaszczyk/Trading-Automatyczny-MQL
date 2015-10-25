#property copyright "Tomasz Waszczyk"
#property link      "https://www.waszczyk.com"
#property version   "1.00"
#property strict

#define MAGIC_NUMBER 20151025
#define OPEN_BUY_SIGNAL 1
#define OPEN_SELL_SIGNAL -1
#define NO_SIGNAL 0

// slowo kluczowe extern pozwala uzytkownikowi wprowadzic wartosci
//zmiennych za pomoca okna eksperta
extern int       OkresSzybkiejSredniej = 10;
extern int       OkresWolnejSredniej  = 50;
// 0.1 = 1 pip
extern int       StopLoss      = 500;
extern int       TakeProfit    = 1600;
// wolumen transakcji
extern double    Lots=1;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
// &ma[] oznacza przeslanie przez referencje
void MaAktualneWartosci(double &ma[],int maPeriod,int numValues=3)
{
// i = 0 oznacza aktualna cene, i = 1 poprzednia cene (bar)
   for(int i=0; i<numValues; i++)
     {
      ma[i]=iMA(NULL,0,maPeriod,0,MODE_SMA,PRICE_CLOSE,i);
     }
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int SprawdzTypWygenerowanegoZlecenia()
  {
   int signal=NO_SIGNAL;

// otworz zlecenie na pierwszym barze, chroni przed zwielokrotnionym
// otwarciem zlecen
   if(Volume[0] > 1) return(0);

// pobierz wartosci MA
   double shortMa[3];
   MaAktualneWartosci(shortMa,OkresSzybkiejSredniej,3);

   double longMa[3];
   MaAktualneWartosci(longMa,OkresWolnejSredniej,3);

// sprawdzanie warunkow dla zlecen typu "kupno" 
   if(shortMa[2]<longMa[2]
      && shortMa[1]>longMa[1])
     {
      signal=OPEN_BUY_SIGNAL;
     }

// sprawdzanie warunkow dla zlecen typu "sprzedaz" 
   if(shortMa[2]>longMa[2]
      && shortMa[1]<longMa[1])
     {
      signal=OPEN_SELL_SIGNAL;
     }
     
   return(signal);
  }
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Funkcja OnTick wywouluje sie przy kazdym nowym ticku             |
//+------------------------------------------------------------------+
void OnTick()
{
   int signal=SprawdzTypWygenerowanegoZlecenia();

// zabezpieczenie sie przed bledem o numerze 138
   int slippage=30;

   if(signal==OPEN_BUY_SIGNAL)
     {
      Print("Sygnal kupna");
      OrderSend(Symbol(),OP_BUY,Lots,Bid,slippage,
                Bid-StopLoss*Point,// cena SL
                Bid+TakeProfit*Point,// cena TP
                NULL,MAGIC_NUMBER,0,Green);
     }

   else if(signal==OPEN_SELL_SIGNAL)
     {
      Print("Sygnal sprzedazy");
      OrderSend(Symbol(),OP_SELL,Lots,Ask,slippage,
                Ask+StopLoss*Point,// cena SL
                Ask-TakeProfit*Point,// cena TP
                NULL,MAGIC_NUMBER,0,Red);
     }
  }
//+------------------------------------------------------------------+
