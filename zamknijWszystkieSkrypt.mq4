//+------------------------------------------------------------------+
//|                                             zamknijWszystkie.mq4 |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
#include <stdlib.mqh>
#include <stderror.mqh>
 
int max_odchylenie_od_ceny = 30;
 
void OnStart()
 {

   int Tip=-1;
   int total=OrdersTotal();
    if (total==0)
    {
           Alert("Nie ma ¿adnych otwartych pozycji");
      return;
    }
      for(int i=total; i>0;i--)
      {
            if (OrderSelect(i-1,SELECT_BY_POS)==true)
               {
                 Tip=OrderType();             
                 double Price=OrderOpenPrice();
                 int Ticket=OrderTicket();
                 double Lot=OrderLots();
                 string symbol=OrderSymbol();
 
 
                  switch(Tip)
                   {
                     case 0:                                                        //------ BUY
                        if ( OrderClose(Ticket,Lot,MarketInfo(symbol,MODE_BID),max_odchylenie_od_ceny)==false )
                        {
                          obsluga_bledu();
                        }
                        break;
                     case 1:                                                       //------ SELL
                        if ( OrderClose(Ticket,Lot,MarketInfo(symbol,MODE_ASK),max_odchylenie_od_ceny)==false )
                        {
                           obsluga_bledu();           
                        }
                        break;
                     default: // ------ zlecenia oczekuj¹ce
                       if ( OrderDelete(Ticket)==false)
                       {
                         obsluga_bledu();
                       }   
                   }
               }
      }
  }
 
void obsluga_bledu() 
{
       int Error=GetLastError();
 
         switch(Error)
         {
          case 5:
            Alert("Stara wersja terminalu klienckiego.");
            break;
          case 64:
            Alert("Konto jest zablokowane.");
            break;
          case 133:
            Alert("Handel jest zabroniony.");
            break;
         default: 
            Alert("Wyst¹pi³ b³¹d numer: ",Error,"  \"",ErrorDescription(Error),"\"");
        } 
}
