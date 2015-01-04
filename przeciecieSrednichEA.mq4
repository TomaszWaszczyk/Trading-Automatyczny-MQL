//+------------------------------------------------------------------+
//|                                         przeciecieSrednichEA.mq4 |
//|                                                  Tomasz Waszczyk |
//|                                            www.blog.waszczyk.com |
//+------------------------------------------------------------------+
#include <stderror.mqh>
#include <stdlib.mqh>
//-----------------------------------------
#property copyright "Tomasz Waszczyk"
#property link      "www.blog.waszczyk.com"
#property version   "1.00"
#property strict
//--- oznaczenie "magic code" po ktorym mozemy rozrozniac transakcje naszego EA;
#define MAGIC_CODE     20150104
//-----------------------------------------
extern int     stopLoss                     = 500;
extern int     takeProfit                   = 500;
extern double  loty                         = 0.1;
extern double  maksymalneRyzyko             = 0.02;
extern double  wspolczynnikPowiekszenia     = 3;
extern int     okresSrednichCenyOtwarcia    = 12;
extern int     okresSrednichCenyZamkniecia  = 21;
extern int     przesuniecieSredniej         = 1;
extern color   kolorKupna                   = clrAliceBlue;
extern color   kolorSprzedazy               = clrSandyBrown;
//-----------------------------------------
double SL = 0, TP = 0;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//--- Funkcja startowa naszego EA;
void start()
{
//--- Jesli nie sredniaKroczaca dostepnych 100 swieczek nie sredniaKroczaca mozliwosci handlu;
   if(Bars < 100 || IsTradeAllowed() == false)
      return; // Wyjscie z EA, brak handlu;
//--- Jesli obliczony wolumen trnsakcji jest zgodny z aktualnym depozytem rachunku      
   if(policzAktualneTransakcje(Symbol())==0)
      sprawdzOtwarcieTransakcji();   // EA zaczyna sprawdzac czy jego warunki zawierania transakcji sa spelnione;
   else
      sprawdzZamkniecieTransakcji();  // W przeciwnym razie zamknij transakcje;
}
//+------------------------------------------------------------------+
//| Ustalenie otwartych transakcji;                                  |
//+------------------------------------------------------------------+
int policzAktualneTransakcje(string symbol)
  {
   int kupno = 0, sprzedaz = 0;
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)
         break;
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MAGIC_CODE)
        {
         if(OrderType()==OP_BUY) kupno++;
         if(OrderType()==OP_SELL) sprzedaz++;
        }
     }
//---- Zwrocenie wolumenu transakcji;
   if(kupno > 0)
      return(kupno);
   else
      return(-sprzedaz);
  }
//+------------------------------------------------------------------+
//| Wyliczenie optymalnej wielkosci transakcji                       |
//+------------------------------------------------------------------+
double optymalizacjaWielkosciLotu()
  {
   double lot = loty;
   int    zlecenia = HistoryTotal(); // Cala historia transakcji;
   int    zleceniaStratne = 0;              // Liczba transakcji stratnych;
//---- Wyliczenie wielkosci lotu;
   lot = NormalizeDouble(AccountFreeMargin() * maksymalneRyzyko / 1000.0,1);
//---- Obliczenie liczby transakcji stratnych
   if(wspolczynnikPowiekszenia > 0)
     {
      for(int i=zlecenia-1;i>=0;i--)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false)
           {
            Print("Error in history!");
            break;
           }
         if(OrderSymbol()!=Symbol() || OrderType()>OP_SELL)
            continue;
         //----
         if(OrderProfit()>0)
            break;
         if(OrderProfit()<0)
            zleceniaStratne++;
        }
      if(zleceniaStratne>1)
         lot=NormalizeDouble(lot-lot*zleceniaStratne/wspolczynnikPowiekszenia,1);
     }
//---- Zwrocenie wielkosci lotu
   if(lot < 0.1)
      lot = 0.1;
   return(lot);
  }
//+------------------------------------------------------------------+
//| Funkcji otwierajaca zlecenia ! !                                 |
//+------------------------------------------------------------------+
void sprawdzOtwarcieTransakcji()
  {
   double sredniaKroczaca;
   int    res;
//---- Handluj tylko przy pierwszym ticku nowej swieczki;
   if(Volume[0]>1)
      return;
//---- Pobranie sredniej kroczacej; 
   sredniaKroczaca = iMA(NULL, 0, okresSrednichCenyOtwarcia, przesuniecieSredniej, MODE_SMA,PRICE_CLOSE, 0);
//---- warunki sprzedazy
   if(Open[1] > sredniaKroczaca && Close[1] < sredniaKroczaca)
     {
      if(stopLoss > 0)
         SL = Bid + Point*stopLoss;
      if(takeProfit > 0)
         TP = Bid - Point*takeProfit;
      res = egzekucjaZlecen(Symbol(), OP_SELL, optymalizacjaWielkosciLotu(), Bid, 3, SL, TP,"Moving Average", MAGIC_CODE, 0, kolorSprzedazy);
      if(res < 0)
        {
         Print("Wystapil blady przy otwieraniu zlecenia sprzedazy #",GetLastError());
         Sleep(10000); 
         return;
        }
     }
//---- warunki kupna
   if(Open[1] < sredniaKroczaca && Close[1] > sredniaKroczaca)
     {
      SL=0;TP=0;
      if(stopLoss>0)
         SL = Ask-Point*stopLoss;
      if(takeProfit>0)
         TP = Ask+Point*takeProfit;
      res = egzekucjaZlecen(Symbol(), OP_BUY, optymalizacjaWielkosciLotu(), Ask, 3, SL,TP, "Moving Average", MAGIC_CODE, 0, kolorKupna);
      if(res < 0)
        {
         Print("Wystapil blady przy otwieraniu zlecenia kupna #",GetLastError());
         Sleep(10000);
         return;
        }
     }
//----
  }
//+------------------------------------------------------------------+
//| Funkcja zamykajaca transakcje                                    |
//+------------------------------------------------------------------+
void sprawdzZamkniecieTransakcji()
  {
   double sredniaKroczaca;
//---- Zacznij handlowac na pierwszym ticku nowej swieczki;
   if(Volume[0] > 1) return;
//---- Pobranie sredniej kroczacej;
   sredniaKroczaca = iMA(NULL,0,okresSrednichCenyZamkniecia,przesuniecieSredniej,MODE_SMA,PRICE_CLOSE,0);
//----
   for(int i=0; i < OrdersTotal(); i++)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == false) break;
      if(OrderMagicNumber() != MAGIC_CODE || OrderSymbol()!=Symbol()) continue;
      //---- sprawdz typ zlecenia 
      if(OrderType() == OP_BUY)
        {
         if(Open[1] > sredniaKroczaca && Close[1] < sredniaKroczaca)
            OrderClose(OrderTicket(), OrderLots(), Bid, 3, kolorKupna);     
            break;
        }
      if(OrderType() == OP_SELL)
        {
         if(Open[1] < sredniaKroczaca && Close[1] > sredniaKroczaca)
            OrderClose(OrderTicket(), OrderLots(), Ask, 3, kolorSprzedazy);     
            break;
        }
     }
  }
//+-------------------------------------------------------------------+
//| Otwarcie zlecen po biezacych cenach                               |
//+-------------------------------------------------------------------+
int egzekucjaZlecen(string    symbol,
                 int       cmd,
                 double    volume,
                 double    price,
                 int       slippage,
                 double    stoploss,
                 double    takeprofit,
                 string    comment,
                 int       magic,
                 datetime  expiration,
                 color     arrow_color)
  {
   int ticket = OrderSend(symbol,cmd,volume,price,slippage,0,0,comment,magic,expiration,arrow_color);
   int check = -1;
   if(ticket > 0 && (stoploss != 0 || takeprofit != 0))
     {
      if(!OrderModify(ticket,price,stoploss,takeprofit,expiration,arrow_color))
        {
         check = GetLastError();
         if(check != ERR_NO_MQLERROR)
            Print("OrderModify zglosil blad: ",ErrorDescription(check));
        }
     }
   else
     {
      check=GetLastError();
      if(check!=ERR_NO_ERROR)
         Print("OrderSend zglosil blad: ",ErrorDescription(check));
     }
   return(ticket);
  }
//+------------------------------------------------------------------+