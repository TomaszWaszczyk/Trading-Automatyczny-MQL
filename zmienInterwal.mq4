//+------------------------------------------------------------------+
//|                                                zmienInterwal.mq4 |
//+------------------------------------------------------------------+
#property copyright "Tomasz Waszczyk © 2015"


// import biblioteki
#import "user32.dll"
   int PostMessageA(int hWnd,int Msg,int wParam,int lParam);
   int GetWindow(int hWnd,int uCmd);
   int GetParent(int hWnd);
#import

// zmienn¹ naszInterwalCzasowy mozemy dowolnie modyfikowaæ
int naszInterwalCzasowy = PERIOD_M30;
                   
int start()
{      
   bool changeContinue = true;   
   int intParent = GetParent(WindowHandle(Symbol(), Period()));   
   int intChild = GetWindow(intParent, 0);  
   int intCmd; 
   
   switch(naszInterwalCzasowy)
   {
      case PERIOD_M1:   intCmd = 33137;  break;
      case PERIOD_M5:   intCmd = 33138;  break;
      case PERIOD_M15:  intCmd = 33139;  break;
      case PERIOD_M30:  intCmd = 33140;  break;
      case PERIOD_H1:   intCmd = 35400;  break;
      case PERIOD_H4:   intCmd = 33136;  break;
      case PERIOD_D1:   intCmd = 33134;  break;
      case PERIOD_W1:   intCmd = 33141;  break;
      case PERIOD_MN1:  intCmd = 33334;  break;
   }
   
   if (intChild > 0)   
   {
      if (intChild != intParent)   
         PostMessageA(intChild, 0x0111, intCmd, 0);
   }
   else 
      changeContinue = false;   
   
   while(changeContinue)
   {
      intChild = GetWindow(intChild, 2);   
   
      if (intChild > 0)   
      { 
         if (intChild != intParent)   
            PostMessageA(intChild, 0x0111, intCmd, 0);
      }
      else   
         changeContinue = false;   
   }
   
   // Przeslij komunikat do aktualnie otwartego okna
   PostMessageA( intParent, 0x0111, intCmd, 0 );
}