//+------------------------------------------------------------------+
//|                Expert Advisor source c0de: EA_Solitude.mq5 v:1.0 |
//|                                        by:      Jurica Preksavec |
//|                                                jurprek@gmail.com |
//+------------------------------------------------------------------+

//-------------------------------------------------------------------------------------------->>>
#property copyright "Jurica Preksavec"
#property link      "jurprek@gmail.com"
#property version   "1.00"
#include <Trade\Trade.mqh>
#import "shell32.dll"
    int ShellExecuteW(int hwnd, string lpOperation, string lpFile, string lpParameters, string lpDirectory, int nShowCmd);
#import

CTrade trade;
enum MODE {EVERY_TICK,EVERY_SEC};

 string BS="---------BASIC SETTING---------";
 MODE CheckMode=EVERY_SEC;//Checking Mode
 int Slippage=30;
 int MagicNumber=19810403;//Magic Number
 string comm="EA_Solitude";//Comment
 string PARA="---------PARAMETERs SETTINGS---------";
 
 string Pair=Symbol();
 //---------------------------------------------------------------------------------------------|
 
 int  Vrijeme=3600*4, READY=0, Ot=0, Day, GO=0, pocek=0, konkav=0, konvex=0, checkin=0,
      cl=0, j=0, Pos=0, Trigger=0, TimeIn=0, CritT=0, CritT2=0, tmr=0, tr=0, zvono=0, OtvorenPar=0, brojilo=0, Trgovao=0, LastTrg=0, open_buy=1, open_sell=1, pause=0, redm=0, redM=0, boja1, boja2, boja3, boja4, bojaX,
      k1=0, j1=0, k2=0, j2=0, k3=0, j3=0, ok_buy=10, ok_sell=10, Zat=0, Pause1=10;
 
 double marker, smjer=0, smjerY=0, H1[], H2[], trenBal=1000, TrenVal=0, part=0, Dan=0, tmpVal=0, mark1=0, mark2=0,
        Avrg=0, MaxKontraProfit=0, KontraProfit=0, CritTProf=0, CritTProf2=0, TickMax=0, TickMin=9999, SMJER_Tck[], Tck[], MaxProfit=0, MaxLoss=0, Profit=0, tmpProfit1=0, tmpProfit2=0, tmpProfit3=0, tmpProfit4=0, tmpProfit5=0, tmpProfit6=0,
        Balance=0, LotSize=0.01, OpenedAtValue=0, LocalMin=0, LocalMax=0, tmpLocalMin=0, tmpLocalMax=0, rndm=0;
 
 input double diff=0.0250;
 input int bckgclr=1;//1-dark or 0-white bckgrnd
 input int ON=1; //Main Switch       
 input double Risk = 1.00;//Invest%  
 input int email = 1;
  
 double STLS = 25;  //STOP_LOSS (PIPs)

 string smjer0, smjer1, smjer2, smjer3, tmpsmjer0, tmpsmjer1, tmpsmjer2, tmpsmjer3,
        textporuka0="EA_Solitude v.1.0,   created by: Jurica Preksavec",
        textporuka1=" ",
        textporuka2=" ",
        textporuka3=" ",
        textporuka4=" ",
        textporuka5=" ",
        textporuka6=" ",
        textporuka7=" ",
        textporuka8=" ",
        textporuka9=" ",
        textporuka10=" ",
        textporuka11=" ",
        textporuka12=" ",
        textporuka13=" ",
        textporuka14=" ",
        textporuka15=" ",
        textporuka16=" ",
        textporuka17=" ";
        ENUM_POSITION_TYPE tiip;
datetime TimeStamp=0, TimeStampY=0;
//----------------------------------------------------------------------------------------------|

int OnInit(){//------------------------------------------------------------------------------->>>
//---

   ObjectCreate(0,"NultiRed",OBJ_LABEL,0,0,0,0,0,0,0);
   ObjectSetString(0,"NultiRed",OBJPROP_TEXT,textporuka0);
   ObjectSetInteger(0,"NultiRed",OBJPROP_XDISTANCE,250);
   ObjectSetInteger(0,"NultiRed",OBJPROP_YDISTANCE,20);
   ObjectSetInteger(0,"NultiRed",OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,"NultiRed",OBJPROP_COLOR,clrLightBlue);
   
   ObjectCreate(0,"SdmnstiRed",OBJ_LABEL,0,0,0,0,0,0,0);
   ObjectSetString(0,"SdmnstiRed",OBJPROP_TEXT,textporuka17);
   ObjectSetInteger(0,"SdmnstiRed",OBJPROP_XDISTANCE,820);
   ObjectSetInteger(0,"SdmnstiRed",OBJPROP_YDISTANCE,40);
   ObjectSetInteger(0,"SdmnstiRed",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,"SdmnstiRed",OBJPROP_COLOR,clrLightBlue);
   
   ArrayResize(Tck,Vrijeme);
   ArrayFill(Tck,0,Vrijeme-1,0);
   ArrayResize(SMJER_Tck,Vrijeme);
   ArrayFill(SMJER_Tck,0,Vrijeme-1,0);
   
   ArrayResize(H1,12);
   ArrayFill(H1,0,12-1,0);
   ArrayResize(H2,12);
   ArrayFill(H2,0,12-1,0);
   
   trade.SetExpertMagicNumber(MagicNumber);
   textporuka0="Starting...";
   EventSetTimer(1);
   return(INIT_SUCCEEDED);
}//---------------------------------------------------------------------------------------------|

void OnDeinit(const int reason){//------------------------------------------------------------>>>
   EventKillTimer();
}//---------------------------------------------------------------------------------------------|

void OnTimer(){//----------------------------------------------------------------------------->>>
   if(TimeStamp!=iTime(_Symbol,PERIOD_H1,0)) {for(int t=0;t<11;t++)H1[t]=H1[t+1]; H1[11]=SymbolInfoDouble(Pair,SYMBOL_ASK);TimeStamp=iTime(_Symbol,PERIOD_H1,0);} 
   if(TimeStampY!=iTime(_Symbol,PERIOD_M20,0)) {for(int t=0;t<11;t++)H2[t]=H2[t+1]; H2[11]=SymbolInfoDouble(Pair,SYMBOL_ASK);TimeStampY=iTime(_Symbol,PERIOD_M20,0);} 
      
//M1
   for(int i=0;i<Vrijeme-2;i++){
      Tck[i]=Tck[i+1];
      SMJER_Tck[i]=SMJER_Tck[i+1];
   }
   Tck[Vrijeme-2]=SymbolInfoDouble(Pair,SYMBOL_ASK);
   smjer =((6*H1[11]+3*H1[10]+2*H1[9]+H1[8]+H1[7])-(6*H1[0]+3*H1[1]+2*H1[2]+H1[3]+H1[4]));
   smjerY=((6*H2[11]+3*H2[10]+2*H2[9]+H2[8]+H2[7])-(6*H2[0]+3*H2[1]+2*H2[2]+H2[3]+H2[4])); 
   
   SMJER_Tck[Vrijeme-2]=smjer;
   
    if(smjer >0.00001) smjer=1; else if(smjer <-0.00001) smjer =-1; else smjer=0;
    if(smjerY>0.00001)smjerY=1; else if(smjerY<-0.00001) smjerY=-1; else smjerY=0;
    
   if(CheckMode==EVERY_SEC)
      CheckForEntry();
}//---------------------------------------------------------------------------------------------|

void OnTick(){//------------------------------------------------------------------------------>>>
      
   if(CheckMode==EVERY_TICK)   
      CheckForEntry();   
}//---------------------------------------------------------------------------------------------- 

void CheckForEntry(){//----------------------------------------------------------------------->>>
   Solitude();
}//---------------------------------------------------------------------------------------------|

void Solitude()//------------------------------------------------------------------------------>>>
{  if(j<Vrijeme) {j++; textporuka0=IntegerToString(j);}
      
   if(bckgclr==0){
      boja1=clrDarkBlue;
      boja2=clrDarkMagenta;
      boja3=clrDarkRed;
      boja4=clrRed;
      bojaX=clrBlue;
   }else{
      boja1=clrLightBlue;
      boja2=clrLightCoral;
      boja3=clrLightGreen;
      boja4=clrWhiteSmoke;
      bojaX=clrBlue;
   }
   
   ObjectCreate(0,"NultiRed",OBJ_LABEL,0,0,0,0,0,0,0);
   ObjectSetString(0,"NultiRed",OBJPROP_TEXT,textporuka0);
   ObjectSetInteger(0,"NultiRed",OBJPROP_XDISTANCE,820);
   ObjectSetInteger(0,"NultiRed",OBJPROP_YDISTANCE,20);
   ObjectSetInteger(0,"NultiRed",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,"NultiRed",OBJPROP_COLOR,boja1);
   
   ObjectCreate(0,"PrviRed",OBJ_LABEL,0,0,0,0,0,0,0);
   ObjectSetString(0,"PrviRed",OBJPROP_TEXT,textporuka1);
   ObjectSetInteger(0,"PrviRed",OBJPROP_XDISTANCE,120);
   ObjectSetInteger(0,"PrviRed",OBJPROP_YDISTANCE,40);
   ObjectSetInteger(0,"PrviRed",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,"PrviRed",OBJPROP_COLOR,boja1);
     
   ObjectCreate(0,"DrugiRed",OBJ_LABEL,0,0,0,0,0,0,0);
   ObjectSetString(0,"DrugiRed",OBJPROP_TEXT,textporuka2);
   ObjectSetInteger(0,"DrugiRed",OBJPROP_XDISTANCE,120);
   ObjectSetInteger(0,"DrugiRed",OBJPROP_YDISTANCE,60);
   ObjectSetInteger(0,"DrugiRed",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,"DrugiRed",OBJPROP_COLOR,boja1);
   
   ObjectCreate(0,"TreciRed",OBJ_LABEL,0,0,0,0,0,0,0);
   ObjectSetString(0,"TreciRed",OBJPROP_TEXT,textporuka3);
   ObjectSetInteger(0,"TreciRed",OBJPROP_XDISTANCE,120);
   ObjectSetInteger(0,"TreciRed",OBJPROP_YDISTANCE,80);
   ObjectSetInteger(0,"TreciRed",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,"TreciRed",OBJPROP_COLOR,boja1);
   
   ObjectCreate(0,"CetiRed",OBJ_LABEL,0,0,0,0,0,0,0);
   ObjectSetString(0,"CetiRed",OBJPROP_TEXT,textporuka4);
   ObjectSetInteger(0,"CetiRed",OBJPROP_XDISTANCE,320);
   ObjectSetInteger(0,"CetiRed",OBJPROP_YDISTANCE,20);
   ObjectSetInteger(0,"CetiRed",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,"CetiRed",OBJPROP_COLOR,boja2);
   
   ObjectCreate(0,"PetiRed",OBJ_LABEL,0,0,0,0,0,0,0);
   ObjectSetString(0,"PetiRed",OBJPROP_TEXT,textporuka5);
   ObjectSetInteger(0,"PetiRed",OBJPROP_XDISTANCE,320);
   ObjectSetInteger(0,"PetiRed",OBJPROP_YDISTANCE,40);
   ObjectSetInteger(0,"PetiRed",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,"PetiRed",OBJPROP_COLOR,boja2);
   
   ObjectCreate(0,"SestiRed",OBJ_LABEL,0,0,0,0,0,0,0);
   ObjectSetString(0,"SestiRed",OBJPROP_TEXT,textporuka6);
   ObjectSetInteger(0,"SestiRed",OBJPROP_XDISTANCE,320);
   ObjectSetInteger(0,"SestiRed",OBJPROP_YDISTANCE,60);
   ObjectSetInteger(0,"SestiRed",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,"SestiRed",OBJPROP_COLOR,boja2);
   
   ObjectCreate(0,"SedmiRed",OBJ_LABEL,0,0,0,0,0,0,0);
   ObjectSetString(0,"SedmiRed",OBJPROP_TEXT,textporuka7);
   ObjectSetInteger(0,"SedmiRed",OBJPROP_XDISTANCE,320);
   ObjectSetInteger(0,"SedmiRed",OBJPROP_YDISTANCE,80);
   ObjectSetInteger(0,"SedmiRed",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,"SedmiRed",OBJPROP_COLOR,boja2);


   ObjectCreate(0,"OsmiRed",OBJ_LABEL,0,0,0,0,0,0,0);
   ObjectSetString(0,"OsmiRed",OBJPROP_TEXT,textporuka8);
   ObjectSetInteger(0,"OsmiRed",OBJPROP_XDISTANCE,520);
   ObjectSetInteger(0,"OsmiRed",OBJPROP_YDISTANCE,20);
   ObjectSetInteger(0,"OsmiRed",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,"OsmiRed",OBJPROP_COLOR,boja3);
   
   ObjectCreate(0,"DvtiRed",OBJ_LABEL,0,0,0,0,0,0,0);
   ObjectSetString(0,"DvtiRed",OBJPROP_TEXT,textporuka9);
   ObjectSetInteger(0,"DvtiRed",OBJPROP_XDISTANCE,520);
   ObjectSetInteger(0,"DvtiRed",OBJPROP_YDISTANCE,40);
   ObjectSetInteger(0,"DvtiRed",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,"DvtiRed",OBJPROP_COLOR,boja3);
   
   ObjectCreate(0,"DstiRed",OBJ_LABEL,0,0,0,0,0,0,0);
   ObjectSetString(0,"DstiRed",OBJPROP_TEXT,textporuka10);
   ObjectSetInteger(0,"DstiRed",OBJPROP_XDISTANCE,520);
   ObjectSetInteger(0,"DstiRed",OBJPROP_YDISTANCE,60);
   ObjectSetInteger(0,"DstiRed",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,"DstiRed",OBJPROP_COLOR,boja3);
   
   ObjectCreate(0,"JdnstiRed",OBJ_LABEL,0,0,0,0,0,0,0);
   ObjectSetString(0,"JdnstiRed",OBJPROP_TEXT,textporuka11);
   ObjectSetInteger(0,"JdnstiRed",OBJPROP_XDISTANCE,520);
   ObjectSetInteger(0,"JdnstiRed",OBJPROP_YDISTANCE,80);
   ObjectSetInteger(0,"JdnstiRed",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,"JdnstiRed",OBJPROP_COLOR,boja3);
   
   ObjectCreate(0,"DvnstiRed",OBJ_LABEL,0,0,0,0,0,0,0);
   ObjectSetString(0,"DvnstiRed",OBJPROP_TEXT,textporuka12);
   ObjectSetInteger(0,"DvnstiRed",OBJPROP_XDISTANCE,720);
   ObjectSetInteger(0,"DvnstiRed",OBJPROP_YDISTANCE,100);
   ObjectSetInteger(0,"DvnstiRed",OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,"DvnstiRed",OBJPROP_COLOR,boja4);                
 //---------------------------------------------------------------------
   ObjectCreate(0,"TrnstiRed",OBJ_LABEL,0,0,0,0,0,0,0);
   ObjectSetString(0,"TrnstiRed",OBJPROP_TEXT,textporuka13);
   ObjectSetInteger(0,"TrnstiRed",OBJPROP_XDISTANCE,210);
   ObjectSetInteger(0,"TrnstiRed",OBJPROP_YDISTANCE,100);
   ObjectSetInteger(0,"TrnstiRed",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,"TrnstiRed",OBJPROP_COLOR,boja4);
   
   ObjectCreate(0,"CtrnstiRed",OBJ_LABEL,0,0,0,0,0,0,0);
   ObjectSetString(0,"CtrnstiRed",OBJPROP_TEXT,textporuka14);
   ObjectSetInteger(0,"CtrnstiRed",OBJPROP_XDISTANCE,200);
   ObjectSetInteger(0,"CtrnstiRed",OBJPROP_YDISTANCE,100);
   ObjectSetInteger(0,"CtrnstiRed",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,"CtrnstiRed",OBJPROP_COLOR,boja4);
   
   ObjectCreate(0,"PtnstiRed",OBJ_LABEL,0,0,0,0,0,0,0);
   ObjectSetString(0,"PtnstiRed",OBJPROP_TEXT,textporuka15);
   ObjectSetInteger(0,"PtnstiRed",OBJPROP_XDISTANCE,210);
   ObjectSetInteger(0,"PtnstiRed",OBJPROP_YDISTANCE,120);
   ObjectSetInteger(0,"PtnstiRed",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,"PtnstiRed",OBJPROP_COLOR,boja4);
   
   ObjectCreate(0,"SsnstiRed",OBJ_LABEL,0,0,0,0,0,0,0);
   ObjectSetString(0,"SsnstiRed",OBJPROP_TEXT,textporuka16);
   ObjectSetInteger(0,"SsnstiRed",OBJPROP_XDISTANCE,200);
   ObjectSetInteger(0,"SsnstiRed",OBJPROP_YDISTANCE,120);
   ObjectSetInteger(0,"SsnstiRed",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,"SsnstiRed",OBJPROP_COLOR,boja4);
  
   ObjectCreate(0,"SdmnstiRed",OBJ_LABEL,0,0,0,0,0,0,0);
   ObjectSetString(0,"SdmnstiRed",OBJPROP_TEXT,textporuka17);
   ObjectSetInteger(0,"SdmnstiRed",OBJPROP_XDISTANCE,820);
   ObjectSetInteger(0,"SdmnstiRed",OBJPROP_YDISTANCE,40);
   ObjectSetInteger(0,"SdmnstiRed",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,"SdmnstiRed",OBJPROP_COLOR,boja1);
   
  if(ON==1){ 
      textporuka13=" "; textporuka14="/ ON";
      textporuka15="V";textporuka16=" ";
   }else{
      textporuka13="\\"; textporuka14="/ OFF";
      textporuka15="/";textporuka16="\\";
   }
   
   if(OtvorenPar==0){ cl=0; Profit=0; MaxProfit=0;
      trenBal=AccountInfoDouble(ACCOUNT_BALANCE);
      Trgovao=0; Profit=0; MaxProfit=0; MaxLoss=0;
      tiip=-1; OpenedAtValue=0;
      textporuka5="0 opened positions.";
      TickMax=0; TickMin=9999;
   }
   else{
      PositionSelect(Pair);
      tiip=(ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);   //buy ili sell
   }   
   
   //if(tiip==-1) ObjectsDeleteAll(ChartID());
      
    textporuka0= "waiting spread <7 ....";
   
   //hitno zatvaranje
 //  if(Trgovao== 1 && (TrenVal<TickMin+0.0010) && Profit<-STLS/2) {if(Ot==1)konkav++; else konvex++; ClosePos(Pair,(double)Ot+(double)cl/10); pause=3600;}
 //  if(Trgovao==-1 && (TrenVal>TickMax-0.0010) && Profit<-STLS/2) {if(Ot==1)konkav++; else konvex++; ClosePos(Pair,(double)Ot+(double)cl/10); pause=3600;}
   if(Trgovao!=0 && (Dan>5.85) /*&& Profit>0*/) ClosePos(Pair,999);
   
  OpenedAtValue=positonPrice(tiip);//----------------------------------------------------------------------------------------------------------------------->>>
  if(SymbolInfoInteger(Pair,SYMBOL_SPREAD)<=7 /*&& OpenedAtValue!=0*/) {
     tmr++;  
     if(tiip==-1) Trgovao= 0;
     if(tiip== 1) Trgovao=-1;
     if(tiip== 0) Trgovao= 1;

     Profit=(SymbolInfoDouble(Pair,SYMBOL_ASK)-OpenedAtValue)   *10000*Trgovao;    
     tmpProfit6=tmpProfit5; tmpProfit5=tmpProfit4; tmpProfit4=tmpProfit3; tmpProfit3=tmpProfit2;tmpProfit2=tmpProfit1; tmpProfit1=Profit;
     Profit=(tmpProfit6+tmpProfit5+tmpProfit4+tmpProfit3+tmpProfit2+tmpProfit1+Profit)/7;        
     
     for(int i=0; i<3; i++){
         string upitPar =PositionGetSymbol(i);
         if( (upitPar=="EURUSD"  || upitPar=="EURUSD_TD") && Profit==0 && MaxProfit==0)  OtvorenPar=1;//ClosePos(Pair,-99999);
     }
    
 
     TickMin=MinMax("minimum", 1); TickMax=MinMax("maksimum", 1); 

     KontraProfit=Profit-MaxLoss;
     if(MaxKontraProfit<KontraProfit) MaxKontraProfit=KontraProfit;
     if(MaxProfit<Profit) MaxProfit=Profit;
     if(MaxLoss>Profit) {MaxLoss=Profit; KontraProfit=0; MaxKontraProfit=0;}
     
     TrenVal=SymbolInfoDouble(Pair,SYMBOL_ASK); 
     

//------------------------------------------------------------------------------------------->>>
      if(j==Vrijeme-14100 && email==1) {ShellExecuteW(0,"open","E:\\eMailSender.lnk"," "," ",1); textporuka0="poslao";}
      if(ON==1 && j==Vrijeme /*&& OtvorenPar==0 && tmr>8 && Tck[0]>0 && SymbolInfoInteger(Pair,SYMBOL_SPREAD)<3*/){
      if(brojilo<30)brojilo++;else brojilo=0;
      
      double mid=(TickMax+TickMin)/2, pola=(TrenVal+Tck[0])/2;
      int i;
      for(i=0;i<Vrijeme-1;i++)Avrg=Tck[i]+Avrg;
      Avrg=Avrg/Vrijeme;
      if(pause>0) pause--;
 
 //DAN u tjednu:    
      int now = (int)TimeCurrent();
      Day = (now/86400+4) %7; // DAN U TJEDNU
      part = ((double)now/86400)-(int)((double)now/86400);
      Dan=double(Day)+part;    if(Dan<6.51 && Dan>=6.50) checkin++; else checkin=0; if(checkin==1 && email==1) ShellExecuteW(0,"open","E:\\eMailSender.lnk"," "," ",1);
 //-------------------------    

//otvaranje

//konkavno:
  //    if(Dan<5.65 && pause==0 && Trgovao==0 && SymbolInfoInteger(Pair,SYMBOL_SPREAD)<3 && OtvorenPar<3 && pola<mid && mid>Avrg+0.0002 && TrenVal>TickMax-0.0005 && TrenVal<TickMax-0.0015 && TickMax-TickMin>0.0020 && TrenVal-Tck[0]>0.0002) {if(GO==0)tmpVal=TrenVal; GO=-1; pocek++; } {if(GO==-1 && pocek>2 && TrenVal<=tmpVal+0.0002 && TrenVal<TickMax-0.0000){GO=0; ClosePos(Pair,-1);Ot=1; OrderEntry(Pair, POSITION_TYPE_SELL); mark1=pola-mid; mark2=mid-Avrg;}}
  //    if(Dan<5.65 && pause==0 && Trgovao==0  && SymbolInfoInteger(Pair,SYMBOL_SPREAD)<3 && OtvorenPar<3 && mid<pola && Avrg>mid+0.0002 && TrenVal<TickMin+0.0005 && TrenVal>TickMin+0.0015 && TickMax-TickMin>0.0020 && Tck[0]-TrenVal>0.0002) {if(GO==0)tmpVal=TrenVal; GO=1; pocek++;} {if(GO== 1 && pocek>2 && TrenVal>=tmpVal+0.0002 && TrenVal>TickMin+0.0000){GO=0; ClosePos(Pair,1);Ot=1; OrderEntry(Pair, POSITION_TYPE_BUY ); mark1=pola-mid; mark2=mid-Avrg;}}
  //    if(pocek>360){pocek==0;GO=0;}


//konveksno:
double RASPON=-0.0000, odmak=-0.0000, akceler=0.0000;
   int qw=1;
   for(int z=0;z<12;z++) if(H1[z]<=0 || H2[z]<=0) qw=0;
   if(qw==1 && Dan>1.15 && Dan<5.5 && pause==0 && SymbolInfoInteger(Pair,SYMBOL_SPREAD)<3 && OtvorenPar<3 && TickMax-TickMin>RASPON){

         if(Trgovao==0 && SMJER_Tck[Vrijeme-2]-SMJER_Tck[2]<-diff/*((mid<pola+akceler && mid>pola+akceler/10  && pola>Avrg+odmak))*/) 
           {if(smjer==1 && smjerY==-1 && TrenVal<=TickMin+0.0005 && TrenVal>=TickMin+0.0000/**/) {marker=smjer; OrderEntry(Pair, POSITION_TYPE_BUY);} }

         if(Trgovao==0 && SMJER_Tck[Vrijeme-2]-SMJER_Tck[2]>diff/* ((pola<mid+akceler && pola>mid+akceler/10  && Avrg>pola+odmak))*/)
           {if(smjer==-1 && smjerY==1 && TrenVal>=TickMax-0.0005 && TrenVal<=TickMax-0.0000/**/) {marker=smjer; OrderEntry(Pair, POSITION_TYPE_SELL);} }
   }

     //if(qw==0) 
      textporuka0= "smjer: "+DoubleToString(smjer,0)+", "+DoubleToString(smjerY,0) + "  (" + DoubleToString(((6*H1[11]+3*H1[10]+2*H1[9]+H1[8]+H1[7])-(6*H1[0]+3*H1[1]+2*H1[2]+H1[3]+H1[4])),4) + "),  (" + DoubleToString(((6*H2[11]+3*H2[10]+2*H2[9]+H2[8]+H2[7])-(6*H2[0]+3*H2[1]+2*H2[2]+H2[3]+H2[4])),4) + ")" ;
     // else textporuka0="Pocek -"+ IntegerToString(qw) +"h";
      textporuka17=IntegerToString(OtvorenPar) + "      " + DoubleToString(Dan,2)+ "      " +DoubleToString(SMJER_Tck[Vrijeme-2]-SMJER_Tck[2],5);
           
      
//zatvaranje
      /*if(Ot==1 && ((MaxProfit>20 && Profit<10)) || (MaxLoss<-20 && Profit>-10))) cl=1.1; else*/
      /*if(Ot==2 && ((MaxProfit>20 && Profit<10)) || (MaxLoss<-20 && Profit>-10))) cl=1.2; else*/
      if(Profit>1) {MaxKontraProfit=0; MaxLoss=0; KontraProfit=0;}
      if((MaxProfit>=30 && Profit<MaxProfit*0.50) /*|| (MaxProfit<30 && MaxProfit>=15 && Profit<MaxProfit*0.40) || (MaxLoss<=-30 && MaxKontraProfit>1 && KontraProfit<MaxKontraProfit*0.90)*/) cl=2; else
      if((MaxProfit>=40 && Profit<MaxProfit*0.65) /*|| (Profit>=5 && Profit<15 && MaxKontraProfit>10 && KontraProfit<MaxKontraProfit*0.25)*/) cl=3; else
      if((MaxProfit>=50 && Profit<MaxProfit*0.70) /*|| (Profit>=-30 && Profit<5 && MaxKontraProfit>20 && KontraProfit<MaxKontraProfit*0.85)*/) cl=4; else
      if((MaxProfit>=70&& Profit<MaxProfit*0.75) /*|| (MaxLoss<=-14 && MaxKontraProfit>7 && KontraProfit<MaxKontraProfit*0.75)*/) cl=5; else 
      if((MaxProfit>=100&& Profit<MaxProfit*0.80) /*|| (MaxLoss<=-10 && MaxKontraProfit>10 && KontraProfit<MaxKontraProfit*0.65)*/) cl=6; else
      if((MaxProfit>=150&& Profit<MaxProfit*0.85) /**/|| (MaxLoss<= -10 && MaxKontraProfit>15 && KontraProfit<MaxKontraProfit*0.80)) cl=7; else
      if(AccountInfoDouble(ACCOUNT_EQUITY)<trenBal*0.75) cl=8; else
      if(Profit<-STLS) cl=9;
      
      if(cl!=0 && Profit>0 && Ot==1) konkav++; if(cl!=0 && Profit>0) konvex++;
      if(cl!=0) {ClosePos(Pair,(double)Ot+(double)cl/10); pause=0;}
   }
}
 if(tiip==-1) {textporuka5="0 opened positions."; bojaX=clrBlue;}
}//---------------------------------------------------------------------------------------------|        

double positonPrice(long type)
{
   double price = 0;
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      string symbol = PositionGetSymbol(i);
      long position_type = PositionGetInteger(POSITION_TYPE);
      if(Symbol() == symbol)
      {
         if(position_type == type)
         {
            price = PositionGetDouble(POSITION_PRICE_OPEN);
            break;
         }
      }
   }
   return price;
}

double MinMax(string minORmax, int x){
   double ekstrem=0;
   
   if(minORmax=="minimum"){
      ekstrem=9999; 
      for(int i=Vrijeme-2; i>=x; i--){
         if(Tck[i]<ekstrem) {ekstrem=Tck[i]; redm=i;}
      }
   }
   
   if(minORmax=="maksimum"){
      ekstrem=0; 
      for(int i=Vrijeme-2; i>=x; i--){
         if(Tck[i]>ekstrem) {ekstrem=Tck[i]; redM=i;}
      }
   }
   return ekstrem;
}

void OrderEntry(string symbol,const ENUM_POSITION_TYPE type){//-------------------->>>
   if(OtvorenPar==0 && email==1)  ShellExecuteW(0,"open","E:\\eMailSender.lnk"," "," ",1); 
   double AskPrice=SymbolInfoDouble(symbol,SYMBOL_ASK);
   double BidPrice=SymbolInfoDouble(symbol,SYMBOL_BID);
   READY=0;
   Balance = AccountInfoDouble(ACCOUNT_BALANCE);   
   LotSize=NormalizeDouble(Risk * (Balance *3/12000),2);
   
   if(type==POSITION_TYPE_BUY)
     {
      trade.Buy(LotSize,symbol,AskPrice,AskPrice-diff,AskPrice+diff,comm);
      OpenedAtValue=AskPrice; Trgovao=1;
     }
   if(type==POSITION_TYPE_SELL)
     {
      trade.Sell(LotSize,symbol,BidPrice,BidPrice+diff,BidPrice-diff,comm);
      OpenedAtValue=BidPrice; Trgovao=-1; 
     } 
     brojilo=0; GO=0;
     string upitPar;
     for(int t=0;t<10;t++) {upitPar =PositionGetSymbol(t);
         if(upitPar=="EURUSD_TD" || upitPar=="EURUSD") OtvorenPar++;}
     PlaySound("openTrade.wav"); // ShellExecuteW(0,"open","E:\\eMailSender.lnk"," "," ",1);  
}//---------------------------------------------------------------------------------------------|

void ClosePos(string PAR, double stop){//--------------------------------------------------->>>
      while(OtvorenPar>0){
         ulong Ticket=PositionGetTicket(0);
         string syb=PositionGetString(POSITION_SYMBOL);
         if(syb==PAR){
            trade.PositionClose(Ticket,Slippage);
            comm="EA_Solitude (" + DoubleToString(stop) + ")";
         }
        if(OtvorenPar>0)OtvorenPar--;}
        MaxKontraProfit=0; KontraProfit=0; Trigger=0; TimeIn=0; CritTProf=0; CritTProf2=0; tmr=0;
        zvono=0; bojaX=clrBlue; Ot=0; Trgovao=0; cl=0; GO=0;
     
     PlaySound("openTrade.wav");
   if(OtvorenPar==0 && email==1)  ShellExecuteW(0,"open","E:\\eMailSender.lnk"," "," ",1); 

}//-------------------------------------------------------------------------------------end c0de.
