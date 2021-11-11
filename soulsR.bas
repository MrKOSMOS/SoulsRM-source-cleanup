:rem ==============================================================================================================================================
:rem                                              DECLARACION DE VARIABLES
:rem ==============================================================================================================================================

#include "sprites.bas"
#include "mapas.bas"
:rem #PRAGMA org=24000

DIM iniUDGS,ani,anisube,anienem,t,contestamina,topcontestamina AS UINTEGER
iniUDGS = 23675  : REM inicio UDG's / valor de 16 bits
ani=0
anisube=0
anienem=0
topcontestamina=200      :rem cuanto mas nivel el tope sube y te cansas menos

DIM tablaenem(89)AS UBYTE=>{_
0,1,3,3,  3,3,0,3,  1,0,_
0,0,  0,1,0,1,  2,2,1,3,_
3,0,1,0,  0,3,0,3,  0,3,_
0,0,  0,1,1,0,  0,3,0,3,_
0,0,0,3, 0,0,0,2, 0,0,_
0,0,  1,1,3,3,  0,2,0,3,_
1,0,0,2,  0,3,1,0,  3,0,_
0,1,  0,1,1,2,  0,0,0,0,_
0,0,1,0,  2,2,2,2,  2,0} :rem ------------------------- tabla donde hay enemigos  //copy at start?

DIM tablaenemtmp(89)AS UBYTE=>{_
0,1,3,3,3,3,0,3,1,0,_
0,0,0,1,0,1,2,2,1,3,_
3,0,1,0,0,3,0,3,0,3,_
0,0,0,1,1,0,0,3,0,3,_
0,0,0,3,0,0,0,2,0,0,_
0,0,1,1,3,3,0,2,0,3,_
1,0,0,2,0,3,1,0,3,0,_
0,1,0,1,1,2,0,0,0,0,_
0,0,1,0,2,2,2,2,2,0} :rem -------------------------- tabla para recargar enemigos

DIM enemigo,contani,topecontani,contanienem,topecontanienem,pant,ataca,atacaenem,retirada,parado,escudo,energia,magia,estamina,topenergia,nivel,souls,llaves,c1,c2,c3,c4,c5,c6,c7,c8,c9 AS UBYTE
DIM energiaenem,energiatmp,energiajefe,xx,yy,cae,sube,tile,xcur,ycur,xh,yh,panth,pantsouls,soulstmp,contdisparo,contbola,disparando,xb,yb,contb,tipo,magiamago AS UBYTE

pant=80                  :rem número de pantalla
nivel=1                  :rem nivel de experiencia del caballero
souls=0                  :rem almas recogidas (18 es el tope)
soulstmp=0               :rem almas que se te han caído
pantsouls=0              :rem pantalla donde se te han caído las almas
enemigo=0                :rem 1=hay enemigo en pantalla

contani=0                :rem contador animacion caballero
topecontani=12           :rem mas alto mas lento anima caballero
contanienem=0            :rem contador animacion enemigo
topecontanienem=10        :rem mas alto mas lento anima enemigo

ataca=0                  :rem 1=caballero ataca
parado=1                 :rem caballero 1=parado 0=se mueve
sube=0                   :rem 1 si sube una escalera
escudo=0                 :rem 0=no protege 1=protege
magiamago=0              :rem 0=magia no aprendida 1=magia aprendida
atacaenem=0              :rem 1=enemigo atacando
retirada=0               :rem 1=el enemigo huye
:rem quien=0                  :rem quien quita energia (1=caballero 0=enemigo)

topenergia=6             :rem maxima energia del caballero segun el nivel /la energia sera esta la maxima posible
energia=topenergia       :rem energia caballero
magia=0                  :rem magia del caballero
estamina=12              :rem estamina del caballero
llaves=0                 :rem cantidad de llaves recogidas

energiaenem=12           :rem energia del enemigo
energiatmp=-3            :rem energia para calcular si huye

DIM dir,direnem,x,y,xesq,yesq AS BYTE

dir=-1
direnem=-1


:rem ==============================================================================================================================================
mipause(14000)
intro()

x=6:y=12
xh=x:yh=y:panth=pant

1  :rem ----------- inicio

xcur=x:ycur=y
energia=topenergia
pantalla()
ink 7
IF dir=1  THEN POKE UINTEGER iniUDGS,@caballero3(ani):print at y,x;"\{i7}\a\b\c":print at y+1,x;"\{i7}\d\{i6}\e\f":print at y+2,x;"\{i7}\g\{i6}\h\i":END IF
IF dir=-1 THEN POKE UINTEGER iniUDGS,@caballero3(ani+72):print at y,x;"\{i7}\a\b\c":print at y+1,x;"\{i7}\d\{i6}\e\f":print at y+2,x;"\{i7}\g\{i6}\h\i":END IF

10 :rem --------------- bucle

IF enemigo=1 THEN enemesq():ELSE:mipause(6):END IF

cursor()
prota()

IF energia=0 THEN muerte():goto 1:END IF

IF contestamina>=topcontestamina THEN
   contestamina=0
   IF estamina>0 THEN print at 21,estamina-1;" ":estamina=estamina-1:topecontani=topecontani+1:END IF
END IF

IF pant=pantsouls and soulstmp>0 THEN 
    souls=souls+soulstmp:soulstmp=0:pintaener()
    beep 0.0125,-60:beep 0.0125,-40:beep 0.0125,-20
    beep 0.05,-30:border 7:beep 0.05,0:border 0:beep 0.05,-30:border 7
    beep 0.05,0:border 0:beep 0.05,-30:border 7:beep 0.05,0:border 0
    beep 0.05,-30:border 7:beep 0.05,-10:border 0:beep 0.05,-30:border 7
    beep 0.05,-20:border 0:beep 0.05,-30:border 7:beep 0.05,-20:border 0:beep 0.05,-30
END IF

IF souls>=17 THEN       :rem check only when receive souls?
   FOR n=0 to 16 
      print at n,30;"\{p0}\{i0}  "
      beep 0.0125,-60:beep 0.0125,-40:beep 0.0125,-20
      souls=0
   next n
   nivel=nivel+1:topcontestamina=topcontestamina+10
   IF topecontani>2 THEN topecontani=topecontani-1
   IF topenergia<12 THEN topenergia=topenergia+1
   energia=topenergia
   pintaener()
   beep 0.05,-4:beep 0.05,4
END IF

IF pant=9 THEN 
   jefe()
   IF energiajefe=0 THEN fin()
END IF

goto 10 :rem ----------- fin bucle

:rem ==============================================================================================================================================
:rem                                           PROCESOS
:rem ==============================================================================================================================================

sub intro()
border 0:paper 0:cls
mipause(1000)
border 7:paper 7:cls
mipause(100)
border 0:paper 0:cls
POKE UINTEGER iniUDGS,@logo(0)
print at 10,12;"\{b1}\{i5}\a\b\c\d\e\{b0}\f\g"
print at 11,12;"\{b1}\{i7}\h\i\j\k\l\{b0}\m\n"
print at 12,12;"\{b1}\{i4}\o\p\q\r\{b0}\s\t\u"
beep 0.025,0:beep 0.025,2:beep 0.025,3:beep 0.025,4:beep 0.025,5:
mipause(5000)
border 7:paper 7:cls
mipause(100)
border 0:paper 0:cls
POKE UINTEGER iniUDGS,@titulo(0)
print at 11,11;"\{b1}\{i7}\a\b\c\d\e\f\g\h"
print at 12,11;"\{i6}\i\j\k\l\m\n\o\p"
mipause(5000)
border 7
mipause(100)
border 0
beep 0.0125,-60:beep 0.0125,-40:beep 0.0125,-20
end sub

sub prota() :rem ----------------------------------- CABALLERO ------------------------------------------------------------------------------------

IF cae=0 and sube=0 and mapa(pant,(y+3)/3,x/3)<20 and mapa(pant,(y+3)/3,(x+1)/3)<20 and mapa(pant,(y+3)/3,(x+2)/3)<20 THEN cae=1 :rem ---- se cae

IF cae=1 THEN 
   borraprota(x,y,3)
   y=y+1
   IF y=15 THEN :rem --------------------------------------------- cambia de pantalla por abajo cayendo 
        y=0
        ycur=y
        pant=pant+10
        pantalla()
   END IF
   ink 7
   IF dir=1 THEN POKE UINTEGER iniUDGS,@caballero3(0)
   IF dir=-1 THEN POKE UINTEGER iniUDGS,@caballero3(72)
   imprime()
   IF mapa(pant,(y+3)/3,x/3)>=20 and mapa(pant,(y+3)/3,(x+1)/3)>=20 and mapa(pant,(y+3)/3,(x+2)/3)>=20 THEN cae=0:beep 0.0025,-20:END IF:rem --- encuentra el suelo
   cursor()
END IF

IF ataca=0 THEN
   IF (IN 57342=254 or IN 57342=190 or inkey$="p") and cae=0 and sube=0 THEN :rem --- tecla P
      contani=contani+1
      contestamina=contestamina+1
      dir=1
      parado=0
      IF x=21 THEN :rem -------------------------------------------- cambia de pantalla por la derecha
         x=0:xcur=x:pant=pant+1:pantalla()
         POKE UINTEGER iniUDGS,@caballero(ani)
         ink 7
         imprime()      
      END IF
      IF mapa(pant,y/3,(x+3)/3)=8 THEN mapa(pant,y/3,(x+3)/3)=0:llaves=llaves+1:pintaener():beep 0.001,-10:beep 0.001,30:rem ---------------  recoge una llave
           print at ycur+1,xcur+3;"   ":print at ycur+2,xcur+3;"   "
      END IF
      IF mapa(pant,y/3,(x+3)/3)=38 THEN :rem --------------------  aprende el hechizo
         magiamago=1
         IF magia=0 THEN magia=magia+3
         pintaener()
         border 5:beep 0.075,30:border 1:beep 0.075,-10:border 0
      END IF
      
      IF magia<12 THEN
         IF mapa(pant,y/3,(x+3)/3)=9 THEN mapa(pant,y/3,(x+3)/3)=0:magia=magia+1:pintaener():beep 0.001,-10:beep 0.001,30:rem ---------------  recoge una carga de magia
            print at ycur+1,xcur+3;"   ":print at ycur+2,xcur+3;"   "
         END IF
      END IF
      IF mapa(pant,y/3,(x+3)/3)=25 and llaves>0 THEN :rem ---------------  choca contra una puerta y la abre si tiene una llave
           mapa(pant,y/3,(x+3)/3)=5:tile=5:lista()
           print at y,x+3;ink c1;"\a";ink c2;"\b";ink c3;"\c"
           print at y+1,x+3;ink c4;"\d";ink c5;"\e";ink c6;"\f"
           print at y+2,x+3;ink c7;"\g";ink c8;"\h";ink c9;"\i"
           beep 0.001,0:beep 0.001,10:beep 0.001,20
           llaves=llaves-1
           pintaener()
      END IF
      IF contani>=topecontani and mapa(pant,y/3,(x+3)/3)<20 THEN :rem --------------------- se mueve     
         contani=0
         ani=ani+72
         borraprota(x,y,1)
         IF ani=432 THEN ani=0      :rem apply shiftr and use 1-digit ani
         IF ani=216 or ani=0 THEN beep 0.0025,-20
         IF enemigo=1  THEN :rem -------------------------------------detecta el choque con el enemigo según el tipo por la derecha
         IF xesq<>x+3 THEN x=x+1:ELSE  :rem condensed common in beginning
            IF tipo=1 THEN
               IF y<>yesq THEN x=x+1
               ELSE 
                  IF xesq<>x+3 THEN x=x+1
               END IF         
            END IF
            
            IF tipo=2 THEN
               IF y<>yesq+3 THEN x=x+1
               ELSE 
                  IF xesq<>x+3 THEN x=x+1
               END IF         
            END IF
            
            IF tipo=3 THEN
               IF y<>yesq-1 THEN x=x+1
               ELSE 
                  IF xesq<>x+3 THEN x=x+1
               END IF         
            END IF
         ELSE
            x=x+1
         END IF          
         POKE UINTEGER iniUDGS,@caballero(ani)
         ink 7
         imprime()         
      END IF
   ELSE
      IF (IN 57342=253 or IN 57342=189 or inkey$="o") and cae=0 and sube=0 THEN :rem --- tecla O
         contani=contani+1
         contestamina=contestamina+1
         dir=-1
         parado=0
         IF x=0 THEN :rem --------------------------------------------- cambia de pantalla por la izquierda 
            x=21:xcur=x:pant=pant-1:pantalla()
            POKE UINTEGER iniUDGS,@caballero2(ani)
            ink 7
            imprime()        
         END IF
         IF mapa(pant,y/3,(x-1)/3)=8 THEN mapa(pant,y/3,(x-1)/3)=0:llaves=llaves+1:pintaener():beep 0.001,-10:beep 0.001,30:rem ---------------  recoge una llave
             print at ycur+1,xcur-3;"   ":print at ycur+2,xcur-3;"   "
         END IF
         IF magia<12 THEN
            IF mapa(pant,y/3,(x-1)/3)=9 THEN mapa(pant,y/3,(x-1)/3)=0:magia=magia+1:pintaener():beep 0.001,-10:beep 0.001,30:rem ---------------  recoge una carga de magia
               print at ycur+1,xcur-3;"   ":print at ycur+2,xcur-3;"   "
            END IF
         END IF
         IF mapa(pant,y/3,(x-1)/3)=26 and llaves>0 THEN :rem ---------------  choca contra una puerta y la abre si tiene una llave
            mapa(pant,y/3,(x-1)/3)=6:tile=6:lista()
            print at y,x-3;ink c1;"\a";ink c2;"\b";ink c3;"\c"
            print at y+1,x-3;ink c4;"\d";ink c5;"\e";ink c6;"\f"
            print at y+2,x-3;ink c7;"\g";ink c8;"\h";ink c9;"\i"
            beep 0.001,0:beep 0.001,10:beep 0.001,20
            llaves=llaves-1
            pintaener()
         END IF 
          
         IF contani>=topecontani and mapa(pant,y/3,(x-1)/3)<20 THEN :rem -------------------- se mueve
            contani=0
            ani=ani+72
            borraprota(x,y,2)
            IF ani=432 THEN ani=0
            IF ani=216 or ani=0 THEN beep 0.0025,-20
       
            IF enemigo=0 THEN :rem --------------------------------- detecta el choque con el enemigo según el tipo por la izquierda
               x=x-1
            ELSE 
:rem IF enemigo=1 THEN
               IF tipo=1 THEN
                  IF y<>yesq THEN x=x-1
                  ELSE
                     IF xesq+3<>x THEN x=x-1
                  END IF
               END IF
               
               IF tipo=2 THEN
                  IF y<>yesq+3 THEN x=x-1
                  ELSE
                     IF xesq+3<>x THEN x=x-1
                  END IF
               END IF
               
               IF tipo=3 THEN
                  IF y<>yesq-1 THEN x=x-1
                  ELSE 
                     IF xesq+3<>x THEN x=x-1
                  END IF         
               END IF      
            END IF
            POKE UINTEGER iniUDGS,@caballero2(ani)
            ink 7
            imprime()
         END IF
      ELSE :rem ---------------------------------------------------------- parado
         IF estamina<12 and sube=0 and not (IN 32766=190 OR IN 32766=254 or inkey$=" ") THEN contestamina=contestamina+5    :rem ------------------------ controla el cansancio al moverse
            IF contestamina>=topcontestamina THEN POKE UINTEGER iniUDGS,@vidamagiaestamina(0):contestamina=0:estamina=estamina+1:print at 21,estamina-1;"\{b1}\{i4}\a":topecontani=topecontani-1:END IF
         END IF      
         IF sube=0 THEN contani=0
         ani=0
         ink 7
         IF dir=1 and parado=0 THEN parado=1
            POKE UINTEGER iniUDGS,@caballero3(0):imprime()        
         END IF
         IF dir=-1 and parado=0 THEN parado=1
            POKE UINTEGER iniUDGS,@caballero3(72):imprime()
         END IF    
      END IF
   END IF
END IF

IF (IN 64510=254 OR IN 64510=190 or inkey$="q") and ataca=0 and parado=1 THEN :rem ----- TECLA Q ---------------- se protege y mira si puede subir  //condense ataca=0

   IF mapa(pant,y/3,x/3)=1 and mapa(pant,y/3,(x+1)/3)=1 and mapa(pant,y/3,(x+2)/3)=1 and sube=0 THEN :rem ----- mira si puede subir escaleraxs
      sube=1:contani=0
      POKE UINTEGER iniUDGS,@caballerosube(ani)
      ink 7
      imprime()
   END IF
  
   IF sube=1 THEN contani=contani+1
      IF contani>=topecontani THEN contani=0
         IF mapa(pant,(y+2)/3,x/3)=1 or mapa(pant,(y+2)/3,x/3)=21 THEN
            borraprota(x,y,4)
            y=y-1
            IF y<0 THEN :rem --------------------------------------------- cambia de pantalla por arriba 
               y=15:ycur=y:pant=pant-10:pantalla()
               POKE UINTEGER iniUDGS,@caballerosube(anisube)
               ink 7
               imprime()       
            END IF
            anisube=anisube+72
            IF anisube=144 THEN anisube=0
            POKE UINTEGER iniUDGS,@caballerosube(anisube)
            ink 7
            imprime() 
            beep 0.001,70         
         ELSE
            sube=0
         END IF      
      END IF   
   END IF
   IF sube=0 THEN escudo=1 :rem ------------------------ se protege con el escudo
      IF dir=1  THEN ani=0
      IF dir=-1 THEN ani=72
      POKE UINTEGER iniUDGS,@caballeroescudo(ani)
      ink 7
      imprime()
   END IF 
   
ELSE
   IF escudo=1 THEN escudo=0
      IF dir=1  THEN ani=0
      IF dir=-1 THEN ani=72
      POKE UINTEGER iniUDGS,@caballero3(ani)
      ink 7
      imprime()
   END IF
END IF

IF (IN 65022=254 OR IN 65022=190 or inkey$="a") and ataca=0 THEN :rem ---------- TECLA A ----------------------------- mira si puede bajar
   IF mapa(pant,(y+3)/3,x/3)=21 and mapa(pant,(y+3)/3,(x+1)/3)=21 and mapa(pant,(y+3)/3,(x+2)/3)=21 and sube=0 THEN :rem ----- mira si puede subir escaleras
       sube=1:contani=0
       POKE UINTEGER iniUDGS,@caballerosube(ani)
       ink 7
       imprime()
   END IF 
   IF sube=1 THEN contani=contani+1
      IF y=15 THEN :rem --------------------------------------------- cambia de pantalla por abajo 
         pant=pant+10:pantalla():y=0:ycur=y
         POKE UINTEGER iniUDGS,@caballerosube(anisube)
         ink 7
         imprime()      
      END IF
      IF contani>=topecontani THEN contani=0
         IF mapa(pant,(y+3)/3,x/3)=1 or mapa(pant,(y+3)/3,x/3)=21 THEN
            borraprota(x,y,3)
            y=y+1
            anisube=anisube+72
            IF anisube=144 THEN anisube=0
            POKE UINTEGER iniUDGS,@caballerosube(anisube)
            ink 7
            imprime()
            beep 0.001,70
         ELSE
            sube=0
         END IF   
      END IF
   END IF
   IF mapa(pant,y/3,x/3)=15 and mapa(pant,y/3,(x+1)/3)=15 and mapa(pant,y/3,(x+2)/3)=15 THEN :rem ------ usa una hoguera
      energia=topenergia:pintaener() 
      beep 0.05,-30:border 2:beep 0.05,0:border 6:beep 0.05,-30:border 2
      beep 0.05,0:border 6:beep 0.05,-30:border 2:beep 0.05,0:border 6
      beep 0.05,-30:border 2:beep 0.05,-10:border 6:beep 0.05,-30:border 2
      beep 0.05,-20:border 6:beep 0.05,-30:border 2:beep 0.05,-20:border 6:beep 0.05,-30:border 0
      FOR n=0 TO 89
         tablaenem(n)=tablaenemtmp(n) :rem replace with ldir assembly
      NEXT n
      xh=x:yh=y:panth=pant
   END IF
END IF

IF (IN 32766=190 OR IN 32766=254 or inkey$=" ") and ataca=0 and sube=0 THEN ataca=1:ani=0:contani=0:END IF :rem ----- TECLA SPACE ----- ataca

IF ataca=1 THEN contani=contani+1
   IF contani>=topecontani THEN contani=0
      IF ani=432 THEN ani=0:ataca=0:contestamina=contestamina+50:END IF
      IF dir=1  THEN POKE UINTEGER iniUDGS,@caballeroatt(ani)
      IF dir=-1 THEN POKE UINTEGER iniUDGS,@caballeroatt2(ani)
      ink 7
      imprime()
      IF ani=144 THEN beep 0.0025,-20
      IF ani=216 THEN 
         ink 7 
         IF dir=1 and x<21 THEN POKE UINTEGER iniUDGS,@espada(0)  :print at y+1,x+3;"\a"
            IF enemigo=1 THEN
               IF xesq=x+3 and ((tipo=1 and y=yesq) or (tipo=2 and y=yesq+3) or (tipo=3 and y=yesq-1)) THEN
                     beep 0.001,-20:beep 0.001,0:beep 0.001,30:restapone(1):energiaenem=energiaenem-1
               END IF
:rem               IF tipo=1 and xesq=x+3 and y=yesq THEN beep 0.001,-20:beep 0.001,0:beep 0.001,30:restapone(1):energiaenem=energiaenem-1:END IF
:rem               IF tipo=2 and xesq=x+3 and y=yesq+3 THEN beep 0.001,-20:beep 0.001,0:beep 0.001,30:restapone(1):energiaenem=energiaenem-1:END IF
:rem               IF tipo=3 and xesq=x+3 and y=yesq-1 THEN beep 0.001,-20:beep 0.001,0:beep 0.001,30:restapone(1):energiaenem=energiaenem-1:END IF
            END IF
            IF mapa(pant,y/3,(x+3)/3)=27 or mapa(pant,y/3,(x+3)/3)=28 or mapa(pant,y/3,(x+3)/3)=29 THEN beep 0.001,-20:beep 0.001,0:beep 0.001,30:coloca(ycur/3,(xcur+3)/3):END IF :rem rompe barriles y coloca cosas si puede
            IF mapa(pant,y/3,(x+3)/3)=37 THEN energiajefe=energiajefe-1:golpejefe():END IF
         END IF
         IF dir=-1 and x>0 THEN POKE UINTEGER iniUDGS,@espada(0)  :print at y+1,x-1;"\b"
            IF enemigo=1 THEN
                 IF xesq=x-3 and ((tipo=1 and y=yesq) or (tipo=2 and y=yesq+3) or (tipo=3 and y=yesq-1)) THEN
                     beep 0.001,-20:beep 0.001,0:beep 0.001,30:restapone(1):energiaenem=energiaenem-1
                 END IF
:rem                 IF tipo=1 and xesq=x-3 and y=yesq THEN beep 0.001,-20:beep 0.001,0:beep 0.001,30:restapone(1):energiaenem=energiaenem-1:END IF
:rem                 IF tipo=2 and xesq=x-3 and y=yesq+3 THEN beep 0.001,-20:beep 0.001,0:beep 0.001,30:restapone(1):energiaenem=energiaenem-1:END IF
:rem                 IF tipo=3 and xesq=x-3 and y=yesq-1 THEN beep 0.001,-20:beep 0.001,0:beep 0.001,30:restapone(1):energiaenem=energiaenem-1:END IF  :rem all have same effect
            END IF     
            IF mapa(pant,y/3,(x-1)/3)=27 or mapa(pant,y/3,(x-1)/3)=28 or mapa(pant,y/3,(x-1)/3)=29 THEN beep 0.001,-20:beep 0.001,0:beep 0.001,30:coloca(ycur/3,(xcur-3)/3):END IF :rem rompe barriles y coloca cosas si puede 
            IF mapa(pant,y/3,(x-1)/3)=36 THEN energiajefe=energiajefe-1:golpejefe():END IF
         END IF
      END IF    
      IF ani=360 THEN
         IF xcur=x THEN
            IF dir=1 THEN beep 0.001,50
               IF x<21 THEN
                  tile=mapa(pant,ycur/3,(xcur/3)+1)
                  lista()
                  print at ycur+1,xcur+3;ink c4;"\d":rem ink c5;"\e";ink c6;"\f"                                      
               END IF
            END IF
            IF dir=-1 THEN beep 0.001,50
               IF x>0 THEN                 
                  tile=mapa(pant,ycur/3,(xcur/3)-1)
                  lista()
                  print at ycur+1,xcur-1;ink c6;"\f"                                      
               END IF
            END IF
         END IF
           
         IF xcur<x THEN
            IF dir=1 THEN beep 0.001,50
               IF x<21 THEN               
                  tile=mapa(pant,ycur/3,(xcur/3)+1)
                  lista()
                  print at ycur+1,xcur+4;ink c5;"\e";ink c6;"\f"                                      
               END IF
            END IF
            IF dir=-1 THEN beep 0.001,50
               IF x>0 THEN                 
                  tile=mapa(pant,ycur/3,xcur/3)
                  lista()
                  print at ycur+1,xcur;ink c4;"\d";ink c5;"\e"                                      
               END IF
            END IF
         END IF  
         
         IF xcur>x THEN
            IF dir=1 THEN beep 0.001,50
               IF x<21 THEN                
                  tile=mapa(pant,ycur/3,xcur/3)
                  lista()
                  print at ycur+1,xcur+1;ink c5;"\e";ink c6;"\f"                                      
               END IF
            END IF
            IF dir=-1 THEN beep 0.001,50
               IF x>0 THEN                 
                  tile=mapa(pant,ycur/3,(xcur/3)-1)
                  lista()
                  print at ycur+1,xcur-3;ink c4;"\d";ink c5;"\e"                                     
               END IF
            END IF
         END IF  
      END IF    
      ani=ani+72
   END IF
END IF

IF (IN 32766=251 or IN 32766=187 or inkey$="m") and magiamago=1 THEN : rem ----------- TECLA M -------------------------------- lanza la magia
   IF magia>0 THEN
      print at 23,magia-1;" ":magia=magia-1
      beep 0.05,-30:border 1:beep 0.05,0:border 0:beep 0.05,-30:border 1
      beep 0.05,0:border 0:beep 0.05,-30:border 1:beep 0.05,0:border 0
      beep 0.05,-30:border 1:beep 0.05,-10:border 0:beep 0.05,-30:border 1
      beep 0.05,-20:border 0:beep 0.05,-30:border 1:beep 0.05,-20:border 0:beep 0.05,-30
      IF enemigo=1 THEN enemigo=0:borraesq(xesq,yesq):tablaenem(pant)=0:souls=souls+2:pintaener():beep 0.0125,-60:beep 0.0125,-40:beep 0.0125,-20:END IF
      IF mapa(pant,ycur/3,(xcur/3)-1)=40 THEN 
         print at ycur,xcur-3;"   "
         print at ycur+1,xcur-3;"   "
         print at ycur+2,xcur-3;"   "
         mapa(pant,ycur/3,(xcur/3)-1)=0
         fxm()
      END IF
      IF mapa(pant,ycur/3,(xcur/3)+1)=39 THEN 
         print at ycur,xcur+3;"   "
         print at ycur+1,xcur+3;"   "
         print at ycur+2,xcur+3;"   "
         mapa(pant,ycur/3,(xcur/3)+1)=0
         fxm()
      END IF
      IF pant=9 THEN energiajefe=energiajefe-1
   END IF
END IF
end sub

sub enemesq() :rem --------------------------------- ENEMIGOS ------------------------------------------------------------------------------------

IF tipo=1 THEN
   ink 7
   IF xesq>x and yesq=y and abs(xesq-x)<=9 and atacaenem=0 and retirada=0 THEN contanienem=contanienem+1:direnem=-1 :rem --- se acerca si esta caballero cerca
      IF contanienem>=topecontanienem+4 THEN 
         contanienem=0
         IF ((xesq>x+3 xor direnem=1) and xesq<>x+3) and mapa(pant,(yesq+3)/3,(xesq-1)/3)<>0 and mapa(pant,yesq/3,(xesq-1)/3)=0 THEN borraesq(xesq,yesq):xesq=xesq-1:END IF:rem og no xor; for both now
         POKE UINTEGER iniUDGS,@esqizq(anienem)
         ink 7
         imprime2()
         IF anienem=72 THEN beep 0.001,58:END IF
         anienem=anienem+72
         IF anienem=144 THEN anienem=0:END IF
      END IF
   END IF :rem duplicate
   
   IF xesq<x and yesq=y and abs(xesq-x)<=9 and atacaenem=0 and retirada=0 THEN contanienem=contanienem+1:direnem=1 :rem --- se acerca si esta caballero cerca
:rem      IF xesq<x THEN direnem=1:END IF
      IF contanienem>=topecontanienem+4 THEN 
         contanienem=0
         IF xesq+3<x and mapa(pant,(yesq+3)/3,(xesq+3)/3)<>0 and mapa(pant,yesq/3,(xesq+3)/3)=0 THEN borraesq(xesq,yesq):xesq=xesq+direnem:END IF :rem OG +1
         POKE UINTEGER iniUDGS,@esqdrch(anienem)
         ink 7
         imprime2()
         IF anienem=72 THEN beep 0.001,58:END IF
         anienem=anienem+72
         IF anienem=144 THEN anienem=0:END IF
      END IF
   END IF
   
   IF direnem=1 and retirada=0 THEN :rem -------------------- mira si ataca
      IF x=xesq+3 and atacaenem=0 THEN IF (int((0-1000+0)*rnd)+1000)>980 THEN atacaenem=1:anienem=0:contanienem=0:END IF:END IF
   END IF
   
   IF direnem=-1 and retirada=0 THEN
      IF x=xesq-3 and atacaenem=0 THEN IF (int((0-1000+0)*rnd)+1000)>980 THEN atacaenem=1:anienem=0:contanienem=0:END IF:END IF
   END IF
   
   IF atacaenem=1 THEN contanienem=contanienem+1
      IF contanienem>=topecontanienem THEN
         contanienem=0
         IF anienem=360 THEN 
            anienem=0
            atacaenem=0
         END IF
         IF direnem=-1 THEN POKE UINTEGER iniUDGS,@esqattizq(anienem):END IF
         IF direnem=1  THEN POKE UINTEGER iniUDGS,@esqattdrch(anienem):END IF
         ink 7
         imprime2()
         IF anienem=360-72 THEN beep 0.001,0:
            IF direnem=-1 THEN IF x=xesq-3 and escudo=0 and y=yesq THEN restapone(0):energia=energia-1:END IF:END IF :rem --- mira si da en el blanco
            IF direnem=1 THEN IF x=xesq+3 and escudo=0 and y=yesq THEN restapone(0):energia=energia-1:END IF:END IF :rem --- mira si da en el blanco
         END IF
         anienem=anienem+72
      END IF
   END IF

   IF energiaenem=energiatmp and atacaenem=0 THEN :rem ------------------------------------- mira si tiene que huir
      energiatmp=energiaenem-3:retirada=1:contanienem=0:anienem=0         
   END IF
   
   IF retirada=1 THEN contanienem=contanienem+1   :rem ------------------------------ huye
      IF contanienem>=topecontanienem+12 THEN contanienem=0
         borraesq(xesq,yesq)
         IF direnem=-1 THEN POKE UINTEGER iniUDGS,@esqizq(anienem)
            IF xesq<21 and mapa(pant,(yesq+3)/3,(xesq+3)/3)<>0 and mapa(pant,yesq/3,(xesq+3)/3)=0 THEN xesq=xesq+1:ELSE:retirada=0:END IF
         END IF
         IF direnem=1  THEN POKE UINTEGER iniUDGS,@esqdrch(anienem)
            IF xesq>0 and mapa(pant,(yesq+3)/3,(xesq-1)/3)<>0 and mapa(pant,yesq/3,(xesq-1)/3)=0 THEN xesq=xesq-1:ELSE:retirada=0:END IF
         END IF
         ink 7
         imprime2()
         IF anienem=72 THEN beep 0.001,58:END IF
         anienem=anienem+72
         IF anienem=144 THEN 
            anienem=0
         END IF
         IF abs(xesq-x)>8 THEN retirada=0:atacaenem=0:END IF :rem a cierta distancia deja de huir   
      END IF
   END IF 
END IF

IF tipo=2 THEN
   ink 4      
   IF abs(xesq-x)<=5 and abs(xesq-x)>4 and y=yesq+3 and atacaenem=0 THEN
      IF anienem<288 THEN  
         anienem=anienem+144
         IF x>xesq THEN POKE UINTEGER iniUDGS,@arboldrch(anienem):END IF
         IF x<xesq THEN POKE UINTEGER iniUDGS,@arbolizq(anienem):END IF
         imprime3()
         beep 0.035,-10:beep 0.035,-5:beep 0.035,0
      END IF
   END IF
   
   IF abs(xesq-x)>5 or y<>yesq+3 and atacaenem=0 THEN    
      IF anienem>0 THEN
         anienem=anienem-144
         IF x>xesq THEN POKE UINTEGER iniUDGS,@arboldrch(anienem):END IF
         IF x<xesq THEN POKE UINTEGER iniUDGS,@arbolizq(anienem):END IF
         imprime3()
         beep 0.035,-10:beep 0.035,-5:beep 0.035,0
      END IF   
   END IF
   
   IF abs(xesq-x)=3 and y=yesq+3 and atacaenem=0 THEN atacaenem=1:anienem=0:END IF
   
   IF atacaenem=1 THEN contanienem=contanienem+1
      IF abs(xesq-x)>3 or y<>yesq+3 THEN 
          atacaenem=0
          anienem=288
          IF x>xesq THEN POKE UINTEGER iniUDGS,@arboldrch(anienem):END IF
          IF x<xesq THEN POKE UINTEGER iniUDGS,@arbolizq(anienem):END IF
          imprime3()
      END IF
      IF contanienem>=topecontanienem+12 THEN contanienem=0
         IF x<xesq THEN POKE UINTEGER iniUDGS,@arbolattizq(anienem):END IF
         IF x>xesq THEN POKE UINTEGER iniUDGS,@arbolattdrch(anienem):END IF
         imprime3()
         IF anienem=288 THEN beep 0.001,-10:beep 0.001,10:IF escudo=0 THEN restapone(0):energia=energia-1:END IF:END IF       
         anienem=anienem+144
         ink 4
         IF anienem=432 THEN anienem=0:END IF       
      END IF  
   END IF   
END IF

IF tipo=3 THEN
   IF abs(xesq-x)<12 and y=yesq-1 THEN contanienem=contanienem+1:atacaenem=1
      IF contanienem>=30 THEN contanienem=0
         borraesq(xesq,yesq)
         IF x>xesq+3  THEN           
            xesq=xesq+1        
         END IF
         IF x+3<xesq THEN           
            xesq=xesq-1        
         END IF
         IF x>xesq THEN 
            direnem=1
            POKE UINTEGER iniUDGS,@ratadrch(anienem)
         ELSE
            direnem=-1
            POKE UINTEGER iniUDGS,@rataizq(anienem)
         END IF
         print at yesq,xesq;"\{i5}\a\b\c"
         print at yesq+1,xesq;"\{i4}\d\e\f"
         anienem=anienem+48:beep 0.001,-5
         IF abs(xesq-x)=3 THEN restapone(0):energia=energia-1:END IF
         IF anienem=96 THEN anienem=0:END IF
      END IF 
   ELSE
      IF atacaenem=1 THEN atacaenem=0:anienem=0:ink 5
         IF direnem=1 THEN POKE UINTEGER iniUDGS,@ratadrch(anienem):END IF
         IF direnem=-1 THEN POKE UINTEGER iniUDGS,@rataizq(anienem):END IF
         print at yesq,xesq;"\{i5}\a\b\c":print at yesq+1,xesq;"\{i4}\d\e\f"
      END IF
   END IF  
END IF

IF energiaenem=0 THEN enemigo=0:borraesq(xesq,yesq):muertesq():tablaenem(pant)=0:END IF  

end sub

sub imprime():rem --------------- imprime al caballero
    print at y,x;"\{i7}\a\b\c"
    print at y+1,x;"\{i7}\d\{i6}\e\f"
    print at y+2,x;"\{i7}\g\{i6}\h\i"
end sub

sub imprime2()
    print at yesq,xesq;"\{i7}\a\b\c"
    print at yesq+1,xesq;"\{i7}\d\{i5}\e\f"
    print at yesq+2,xesq;"\{i5}\g\h\i"
end sub

sub imprime3():rem -------------- imprime al hombre arbol
    print at yesq,xesq;"\{i6}\a\{i4}\b\c"
    print at yesq+1,xesq;"\{i6}\d\{i4}\e\f"
    print at yesq+2,xesq;"\{i6}\g\{i4}\h\i"
    print at yesq+3,xesq;"\{i6}\j\{i4}\k\l"
    print at yesq+4,xesq;"\{i6}\m\{i4}\n\o"
    print at yesq+5,xesq;"\{i6}\p\{i4}\q\r"
end sub

sub pintaener() :rem -------------------------------- PINTA BARRAS DE ENERGIA Y OBJETOS ---------------------------------------------------------------------
bright 1
ink 7
POKE UINTEGER iniUDGS,@letrasvida(0)
print at 18,4;"\a\b\c\d"
print at 18,16;"\a\b\c\d"
POKE UINTEGER iniUDGS,@letrasestamina(0)
print at 20,3;"\a\b\c\d\e\f"
POKE UINTEGER iniUDGS,@letrasmagia(0)
print at 22,4;"\a\b\c\d"
POKE UINTEGER iniUDGS,@letrassouls(0)
print at 16,25;"\a\b\c\d\{i6}\e"
POKE UINTEGER iniUDGS,@letrasnivel(0)
print at 18,25;"\a\b\c\d"
POKE UINTEGER iniUDGS,@barrillave(0)
print at 13,25;"\{i7}\d\e\f"
print at 14,25;"\{i7}\g\{i6}\h\i"
ink 6
print at 14,28;llaves
print at 18,30;nivel
POKE UINTEGER iniUDGS,@almas(0)
FOR n=1 to souls:print at (16-n)+1,30;"\{i7}\a\{i5}\b":IF n=17 THEN exit for:END IF:next n
bright 0
:rem POKE UINTEGER iniUDGS,@marco(0)
:rem ink 6
:rem FOR n=0 to 3:print at 18,n;"\a":next n:FOR n=8 to 11:print at 18,n;"\b":next n
:rem FOR n=12 to 15:print at 18,n;"\a":next n:FOR n=20 to 23:print at 18,n;"\b":next n
:rem FOR n=0 to 2:print at 20,n;"\a":next n:FOR n=9 to 11:print at 20,n;"\b":next n
:rem FOR n=0 to 3:print at 22,n;"\a":next n:FOR n=8 to 11:print at 22,n;"\b":next n
bright 1
POKE UINTEGER iniUDGS,@vidamagiaestamina(0)
FOR n=1 to energia:print at 19,n-1;"\{i2}\a":next n                                      :rem ---- barra energia caballero
IF enemigo=1 THEN FOR n=1 to energiaenem:print at 19,(n+12)-1;"\{i3}\a":next n:ELSE:print at 19,12;"            ":END IF    :rem ---- barra energia esqueleto
FOR n=1 to estamina:print at 21,n-1;"\{i4}\a":next n
FOR n=1 to magia:print at 23,n-1;"\{i1}\a":next n
bright 0
POKE UINTEGER iniUDGS,@logo(0)
print at 20,25;"\{b1}\{i5}\a\b\c\d\e\{b0}\f\g"
print at 21,25;"\{b1}\{i7}\h\i\j\k\l\{b0}\m\n"
print at 22,25;"\{b1}\{i4}\o\p\q\r\{b0}\s\t\u"

POKE UINTEGER iniUDGS,@titulo(0)
print at 21,14;"\{b1}\{i7}\a\b\c\d\e\f\g\h"
print at 22,14;"\{i6}\i\j\k\l\m\n\o\p"
POKE UINTEGER iniUDGS,@remaster(0)
print at 23,14;"\{i2}\a\b\c\d\e\f\g\h"
ink 7
end sub

sub restapone(quien AS UBYTE) :rem -------------------------------- PONE O QUITA ENERGIA ------------------------------------------------------------------------
IF quien=0 THEN ink 0:print at 19,energia-1;" ":END IF :rem se la quita al caballero
IF quien=1 THEN ink 0:print at 19,12+energiaenem-1;" ":END IF :rem se la quita al esqueleto

end sub

sub cursor() :rem ---------------------------- CONTROLA DONDE HAY QUE ACTUALIZAR EL TILE DEL FONDO
IF (x>xcur+2 or x<xcur-2) THEN xcur=x
:rem IF x<xcur-2 THEN xcur=x
IF (y>ycur+2 or y<ycur-2) THEN ycur=y
:rem IF y<ycur-2 THEN ycur=y
end sub

sub borraprota(xsub AS BYTE, ysub AS BYTE, lado AS UBYTE):rem ----------------------------- PARA BORRAR AL CABALLERO ---------------------------------------------------------------------

    :rem xx=xcur/3
    :rem yy=ycur/3
    :rem tile=mapa(pant,yy,xx)
    :rem lista() abc def ghi
    
   tile=mapa(pant,ycur/3,xcur/3)
   lista()
   
   IF lado=1 THEN
      IF xcur<=xsub THEN
         IF abs(xsub-xcur)=0 THEN print at ycur,xcur;ink c1;"\a":print at ycur+1,xcur;ink c4;"\d":print at ycur+2,xcur;ink c7;"\g":END IF
         IF abs(xsub-xcur)=1 THEN print at ycur,xcur+1;ink c2;"\b":print at ycur+1,xcur+1;ink c5;"\e":print at ycur+2,xcur+1;ink c8;"\h":END IF
         IF abs(xsub-xcur)=2 THEN print at ycur,xcur+2;ink c3;"\c":print at ycur+1,xcur+2;ink c6;"\f":print at ycur+2,xcur+2;ink c9;"\i":END IF
      ELSE
         tile=mapa(pant,ycur/3,(xcur/3)-1)
         lista()
         IF abs(xsub-xcur)=1 THEN print at ycur,xcur-1;ink c3;"\c":print at ycur+1,xcur-1;ink c6;"\f":print at ycur+2,xcur-1;ink c9;"\i":END IF
         IF abs(xsub-xcur)=2 THEN print at ycur,xcur-2;ink c2;"\b":print at ycur+1,xcur-2;ink c5;"\e":print at ycur+2,xcur-2;ink c8;"\h":END IF
      END IF   
   END IF
   
   IF lado=2 THEN
      IF xcur>=xsub THEN
         IF abs(xsub-xcur)=0 THEN print at ycur,xcur+2;ink c3;"\c":print at ycur+1,xcur+2;ink c6;"\f":print at ycur+2,xcur+2;ink c9;"\i":END IF
         IF abs(xsub-xcur)=1 THEN print at ycur,xcur+1;ink c2;"\b":print at ycur+1,xcur+1;ink c5;"\e":print at ycur+2,xcur+1;ink c8;"\h":END IF
         IF abs(xsub-xcur)=2 THEN print at ycur,xcur;ink c1;"\a":print at ycur+1,xcur;ink c4;"\d":print at ycur+2,xcur;ink c7;"\g":END IF
      ELSE
         tile=mapa(pant,ycur/3,(xcur/3)+1)
         lista()
         IF abs(xsub-xcur)=1 THEN print at ycur,xcur+3;ink c1;"\a":print at ycur+1,xcur+3;ink c4;"\d":print at ycur+2,xcur+3;ink c7;"\g":END IF
         IF abs(xsub-xcur)=2 THEN print at ycur,xcur+4;ink c2;"\b":print at ycur+1,xcur+4;ink c5;"\e":print at ycur+2,xcur+4;ink c8;"\h":END IF
      END IF   
   END IF
   
   IF lado=4 THEN
      IF ycur>=ysub THEN   
         IF abs(ysub-ycur)=0 THEN print at ycur+2,xcur;ink c7;"\g";ink c8;"\h";ink c9;"\i":END IF
         IF abs(ysub-ycur)=1 THEN print at ycur+1,xcur;ink c4;"\d";ink c5;"\e";ink c6;"\f":END IF
         IF abs(ysub-ycur)=2 THEN print at ycur,xcur;ink c1;"\a";ink c2;"\b";ink c3;"\c":END IF
      ELSE
         tile=mapa(pant,(ycur/3)+1,xcur/3)
         lista()
         IF abs(ysub-ycur)=1 THEN print at ycur+3,xcur;ink c1;"\a";ink c2;"\b";ink c3;"\c":END IF
         IF abs(ysub-ycur)=2 THEN print at ycur+4,xcur;ink c4;"\d";ink c5;"\e";ink c6;"\f":END IF
      END IF   
   END IF
   
   IF lado=3 THEN
      IF ycur<=ysub THEN
         IF abs(ysub-ycur)=0 THEN print at ycur,xcur;ink c1;"\a";ink c2;"\b";ink c3;"\c":END IF
         IF abs(ysub-ycur)=1 THEN print at ycur+1,xcur;ink c4;"\d";ink c5;"\e";ink c6;"\f":END IF
         IF abs(ysub-ycur)=2 THEN print at ycur+2,xcur;ink c7;"\g";ink c8;"\h";ink c9;"\i":END IF
      ELSE
         tile=mapa(pant,(ycur/3)-1,xcur/3)
         lista()
         IF abs(ysub-ycur)=1 THEN print at ycur-1,xcur;ink c7;"\g";ink c8;"\h";ink c9;"\i":END IF
         IF abs(ysub-ycur)=2 THEN print at ycur-2,xcur;ink c4;"\d";ink c5;"\e";ink c6;"\f":END IF
      END IF  
   END IF
       
   
           
end sub

sub borraesq(subxesq AS BYTE, subyesq AS BYTE) :rem ------------------------ PARA BORRAR AL ESQUELETO ---------------------------------------------------------------------
paper 0:ink 0
IF tipo=1 THEN
   print at subyesq,subxesq;"   "
   print at subyesq+1,subxesq;"   "
   print at subyesq+2,subxesq;"   "
END IF  
IF tipo=2 THEN
   print at subyesq,subxesq;"   "
   print at subyesq+1,subxesq;"   "
   print at subyesq+2,subxesq;"   "
   print at subyesq+3,subxesq;"   "
   print at subyesq+4,subxesq;"   "
   print at subyesq+5,subxesq;"   "
END IF
IF tipo=3 THEN
   print at subyesq,subxesq;"   "
   print at subyesq+1,subxesq;"   "
END IF  
        
end sub

sub lista() :rem ----------------------------- LISTA DE GRAFICOS DEL DECORADO ---------------------------------------------------------------------

:rem ------------------- menos de 3 se cae

IF tile=0 THEN POKE UINTEGER iniUDGS,@vacio(0):c1=0:c2=0:c3=0:c4=0:c5=0:c6=0:c7=0:c8=0:c9=0:END IF :rem vacio (traspasable)
IF tile=1 THEN POKE UINTEGER iniUDGS,@escaleraizq(72):c1=3:c2=2:c3=2:c4=3:c5=2:c6=2:c7=3:c8=2:c9=2:END IF :rem escalera izquierda (traspasable)
IF tile=2 THEN POKE UINTEGER iniUDGS,@paredizq(0):c1=1:c2=1:c3=1:c4=1:c5=1:c6=1:c7=1:c8=1:c9=1:END IF :rem pared izquierda (tras)
IF tile=3 THEN POKE UINTEGER iniUDGS,@pareddrch(0):c1=1:c2=1:c3=1:c4=1:c5=1:c6=1:c7=1:c8=1:c9=1:END IF :rem pared derecha (tras)
IF tile=4 THEN POKE UINTEGER iniUDGS,@ladrillos(0):c1=7:c2=7:c3=7:c4=7:c5=7:c6=7:c7=7:c8=7:c9=7:END IF :rem ladrillos de fondo blancos(tras)
IF tile=5 THEN POKE UINTEGER iniUDGS,@puerta(0):c1=5:c2=7:c3=7:c4=5:c5=5:c6=6:c7=5:c8=6:c9=6:END IF :rem puerta abierta (tras)
IF tile=6 THEN POKE UINTEGER iniUDGS,@puertaizq(0):c1=7:c2=7:c3=5:c4=6:c5=5:c6=5:c7=6:c8=6:c9=5:END IF :rem puerta abierta hacia la izquierda (tras)
IF tile=7 THEN POKE UINTEGER iniUDGS,@barrilroto(0):c1=7:c2=7:c3=4:c4=7:c5=6:c6=4:c7=6:c8=6:c9=4:END IF :rem barril roto (tras)
IF tile=8 THEN POKE UINTEGER iniUDGS,@barrillave(0):c1=7:c2=7:c3=7:c4=7:c5=7:c6=7:c7=7:c8=6:c9=6:END IF :rem barril con llave (tras))
IF tile=9 THEN POKE UINTEGER iniUDGS,@barrilmagia(0):c1=5:c2=5:c3=5:c4=5:c5=5:c6=5:c7=5:c8=1:c9=1:END IF :rem barril con magia (tras)
IF tile=10 THEN POKE UINTEGER iniUDGS,@ladrillos(0):c1=3:c2=3:c3=3:c4=3:c5=3:c6=3:c7=3:c8=3:c9=3:END IF :rem ladrillos de fondo lilas (tras)
IF tile=11 THEN POKE UINTEGER iniUDGS,@mesaizq(0):c1=1:c2=1:c3=1:c4=1:c5=1:c6=1:c7=1:c8=1:c9=1:END IF :rem parte izquierda de la mesa grande (tras)
IF tile=12 THEN POKE UINTEGER iniUDGS,@mesadrch(0):c1=1:c2=1:c3=1:c4=1:c5=1:c6=1:c7=1:c8=1:c9=1:END IF :rem parte derecha de la mesa grande (tras)
IF tile=13 THEN POKE UINTEGER iniUDGS,@puertacelda(0):c1=5:c2=7:c3=7:c4=5:c5=5:c6=6:c7=5:c8=6:c9=6:END IF :rem puerta de las celdas (tras)
IF tile=14 THEN POKE UINTEGER iniUDGS,@techotras(0):c1=1:c2=1:c3=1:c4=1:c5=1:c6=1:c7=1:c8=1:c9=1:END IF :rem techo (tras)
IF tile=15 THEN POKE UINTEGER iniUDGS,@hoguera(0):c1=7:c2=7:c3=7:c4=5:c5=5:c6=5:c7=7:c8=6:c9=6:END IF :rem hoguera (tras)
IF tile=16 THEN POKE UINTEGER iniUDGS,@cielo(0):c1=5:c2=5:c3=5:c4=5:c5=5:c6=5:c7=5:c8=5:c9=5:END IF :rem trozo de cielo
IF tile=17 THEN POKE UINTEGER iniUDGS,@techotras2(0):c1=1:c2=1:c3=1:c4=1:c5=1:c6=1:c7=1:c8=1:c9=1:END IF :rem techo (tras)
IF tile=18 THEN POKE UINTEGER iniUDGS,@paredcastdrch(0):c1=7:c2=4:c3=4:c4=5:c5=4:c6=4:c7=5:c8=4:c9=4:END IF :rem pared castillo derecha (tras)
IF tile=19 THEN POKE UINTEGER iniUDGS,@paredcastizq(0):c1=4:c2=4:c3=7:c4=4:c5=4:c6=5:c7=4:c8=4:c9=5:END IF :rem pared castillo izquierda (tras)

IF tile=20 THEN POKE UINTEGER iniUDGS,@suelocentro(0):c1=3:c2=3:c3=3:c4=3:c5=1:c6=3:c7=1:c8=1:c9=1:END IF :rem suelo catacumbas
IF tile=21 THEN POKE UINTEGER iniUDGS,@escaleraizq(0):c1=3:c2=2:c3=2:c4=3:c5=2:c6=2:c7=3:c8=2:c9=2:END IF :rem tope escalera izquierda
IF tile=22 THEN POKE UINTEGER iniUDGS,@techo(0):c1=1:c2=1:c3=1:c4=1:c5=1:c6=1:c7=3:c8=3:c9=3:END IF :rem techo catacumbas
IF tile=23 THEN POKE UINTEGER iniUDGS,@paredizqfija(0):c1=1:c2=1:c3=3:c4=1:c5=1:c6=3:c7=1:c8=1:c9=3:END IF :rem pared izquierda catacumbas
IF tile=24 THEN POKE UINTEGER iniUDGS,@pareddrchfija(0):c1=3:c2=1:c3=1:c4=3:c5=1:c6=1:c7=3:c8=1:c9=1:END IF :rem pared derecha catacumbas
IF tile=25 THEN POKE UINTEGER iniUDGS,@puertacerrada(0):c1=7:c2=7:c3=7:c4=5:c5=5:c6=5:c7=5:c8=5:c9=5:END IF :rem puerta cerrada no traspasable
IF tile=26 THEN POKE UINTEGER iniUDGS,@puertacerradaizq(0):c1=7:c2=7:c3=7:c4=5:c5=5:c6=5:c7=5:c8=5:c9=5:END IF :rem puerta cerrada hacia la izqierda no traspasable
IF tile=27 or tile=28 or tile=29 THEN POKE UINTEGER iniUDGS,@barril(0):c1=7:c2=7:c3=4:c4=7:c5=6:c6=4:c7=6:c8=6:c9=4:END IF :rem barril (destruible)
IF tile=30 THEN POKE UINTEGER iniUDGS,@suelocastillo(0):c1=7:c2=5:c3=5:c4=4:c5=4:c6=4:c7=4:c8=4:c9=4:END IF :rem suelo castillo
IF tile=31 THEN POKE UINTEGER iniUDGS,@suelobosque(0):c1=4:c2=4:c3=4:c4=4:c5=6:c6=4:c7=6:c8=6:c9=6:END IF :rem suelo bosque
IF tile=32 THEN POKE UINTEGER iniUDGS,@plataforma(0):c1=2:c2=2:c3=2:c4=2:c5=2:c6=2:c7=2:c8=2:c9=2:END IF :rem plataformas escalera
IF tile=33 THEN POKE UINTEGER iniUDGS,@paredcastdrch(0):c1=7:c2=4:c3=4:c4=5:c5=4:c6=4:c7=5:c8=4:c9=4:END IF :rem pared castillo derecha
IF tile=34 THEN POKE UINTEGER iniUDGS,@paredcastizq(0):c1=4:c2=4:c3=7:c4=4:c5=4:c6=5:c7=4:c8=4:c9=5:END IF :rem pared castillo izquierda
IF tile=35 THEN POKE UINTEGER iniUDGS,@ojojefe(0):c1=7:c2=6:c3=5:c4=7:c5=6:c6=5:c7=7:c8=6:c9=5:END IF :rem colmillo
IF tile=36 THEN POKE UINTEGER iniUDGS,@garraizq(0):c1=4:c2=4:c3=6:c4=4:c5=6:c6=6:c7=5:c8=7:c9=7:END IF :rem garra izquierda
IF tile=37 THEN POKE UINTEGER iniUDGS,@garradrch(0):c1=6:c2=4:c3=4:c4=6:c5=6:c6=4:c7=7:c8=7:c9=5:END IF :rem garra derecha
IF tile=38 THEN POKE UINTEGER iniUDGS,@mago(0):c1=5:c2=7:c3=7:c4=5:c5=5:c6=7:c7=5:c8=5:c9=7:END IF :rem mago que te enseña a usar la magia
IF tile=39 THEN POKE UINTEGER iniUDGS,@puertarocaizq(0):c1=7:c2=5:c3=5:c4=7:c5=5:c6=5:c7=5:c8=5:c9=5:END IF :rem puerta de roca hacia la izquierda
IF tile=40 THEN POKE UINTEGER iniUDGS,@puertarocadrch(0):c1=5:c2=5:c3=7:c4=5:c5=5:c6=7:c7=5:c8=5:c9=5:END IF :rem puerta de roca hacia la derecha
IF tile=41 THEN POKE UINTEGER iniUDGS,@ladrillos(0):c1=7:c2=7:c3=7:c4=7:c5=7:c6=7:c7=7:c8=7:c9=7:END IF :rem ladrillos de fondo blancos(no traspasables)
IF tile=42 THEN POKE UINTEGER iniUDGS,@ladrillos(0):c1=3:c2=3:c3=3:c4=3:c5=3:c6=3:c7=3:c8=3:c9=3:END IF :rem ladrillos de fondo lilas (no traspasables)
IF tile=43 THEN POKE UINTEGER iniUDGS,@techocastillo(0):c1=4:c2=4:c3=4:c4=4:c5=4:c6=4:c7=7:c8=5:c9=5:END IF :rem techo del castillo

IF pant>6 and pant<10 or pant>16 and pant<20 or pant=29 or pant=39 or pant=49 THEN
   IF tile=20 or tile=22 or tile=23 or tile=24 THEN c1=2:c2=2:c3=2:c4=2:c5=2:c6=2:c7=2:c8=2:c9=2:END IF
END IF

end sub

sub pantalla() :rem ------------------------ PINTA PANTALLA Y COLOCA ENEMIGOS ----------------------------------------------------------------------

energiajefe=100           :rem energia del jefe final
limpia()
FOR yy=0 TO 5  :rem --------------------- pinta la pantalla
   FOR xx=0 TO 7
      tile=mapa(pant,yy,xx)
      lista()
      IF tile=0 THEN
         ink 0 
         print at yy*3,xx*3;"   "
         print at (yy*3)+1,xx*3;"   "
         print at (yy*3)+2,xx*3;"   "
      ELSE
         print at yy*3,xx*3;ink c1;"\a";ink c2;"\b";ink c3;"\c"
         print at (yy*3)+1,xx*3;ink c4;"\d";ink c5;"\e";ink c6;"\f"
         print at (yy*3)+2,xx*3;ink c7;"\g";ink c8;"\h";ink c9;"\i"
      END IF
      bright 0
   NEXT xx
NEXT yy

IF tablaenem(pant)<>0 THEN  :rem ------ mira en la tabla si ha de poner un enemigo    
    IF pant=71 or pant=53 or pant=55 or pant=20 or pant=37 or pant=66 or pant=68 or pant=29 or pant=18 or pant=19 or pant=43 THEN :REM --- según la pantalla los enemigos miran hacia un lado o otro
       direnem=1
    ELSE 
       direnem=-1
    END IF
    
    IF pant=16 THEN topecontanienem=16:ELSE:topecontanienem=10:END IF 
    
    IF tablaenem(pant)=1 THEN tipo=1
       IF direnem=-1 THEN POKE UINTEGER iniUDGS,@esqizq(0):END IF
       IF direnem=1 THEN  POKE UINTEGER iniUDGS,@esqdrch(0):END IF
    END IF
    IF tablaenem(pant)=2 THEN tipo=2
       IF direnem=-1 THEN POKE UINTEGER iniUDGS,@arbolizq(0):ink 4:END IF
       IF direnem=1 THEN  POKE UINTEGER iniUDGS,@arboldrch(0):ink 4:END IF
    END IF
    IF tablaenem(pant)=3 THEN tipo=3
       IF direnem=-1 THEN POKE UINTEGER iniUDGS,@rataizq(48):END IF
       IF direnem=1 THEN  POKE UINTEGER iniUDGS,@ratadrch(48):END IF
    END IF
    enemigo=1:atacaenem=0:contanienem=0:anienem=0:retirada=0
    
    xesq=posenem(pant,0)
    yesq=posenem(pant,1)
    IF tipo=1 THEN energiaenem=6 
       print at yesq,xesq;"\{i7}\a\b\c"
       print at yesq+1,xesq;"\{i7}\d\{i5}\e\f"
       print at yesq+2,xesq;"\{i5}\g\h\i"
    END IF
    IF tipo=2 THEN energiaenem=12
       print at yesq,xesq;"\{i6}\a\{i4}\b\c"
       print at yesq+1,xesq;"\{i6}\d\{i4}\e\f"
       print at yesq+2,xesq;"\{i6}\g\{i4}\h\i"
       print at yesq+3,xesq;"\{i6}\j\{i4}\k\l"
       print at yesq+4,xesq;"\{i6}\m\{i4}\n\o"
       print at yesq+5,xesq;"\{i6}\p\{i4}\q\r"
    END IF 
    IF tipo=3 THEN energiaenem=1 
       print at yesq,xesq;"\{i5}\a\b\c"
       print at yesq+1,xesq;"\{i4}\d\e\f"
    END IF
    energiatmp=energiaenem-3
ELSE 
   enemigo=0
END IF
pintaener()

IF pant=9 THEN 
  POKE UINTEGER iniUDGS,@diente(0)
  FOR xx=10 to 13
      print at 0,xx;"\{i6}\a"
  NEXT xx
END IF

end sub

sub limpia() :rem ------------------------------------ LIMPIA MARCO DE JUEGO -----------------------------------------------------------------------
border 0:paper 0:ink 0:cls
FOR yy=0 to 17
   FOR xx=0 to 23
       print at yy,xx;" "
   NEXT xx
NEXT yy
end sub

sub muerte() :rem ------------------------------------- MUERTE DEL CABALLERO -----------------------------------------------------------------------
:rem use for loop
beep 0.025,-10
border 2
beep 0.025,-9
border 0
beep 0.025,-8
border 2
beep 0.025,-7
border 0
beep 0.025,-6
border 2
beep 0.025,-5
border 0
beep 0.025,-4
border 2
beep 0.025,-3
border 0
beep 0.025,-2
border 2
beep 0.025,-1
border 0
FOR n=0 TO 89
   tablaenem(n)=tablaenemtmp(n)
NEXT n
soulstmp=souls
pantsouls=pant
souls=0
x=xh:y=yh:pant=panth
ataca=0
sube=0
ani=0
end sub

sub muertesq() :rem ---------------------------------- MUERTE DEL ENEMIGO ------------------------------------------------------------------------
POKE UINTEGER iniUDGS,@almas(0)
IF tipo=2 THEN yesq=yesq+3:END IF
IF tipo=3 THEN yesq=yesq-1:END IF
print at yesq,xesq;"\{i7}\a\{i5}\b"
border 7
beep 0.05,-10
print at yesq+1,xesq;"\{i7}\a\{i5}\b\c"
print at yesq,xesq;"\{p0}\{i0}   "
border 0
beep 0.05,-5
print at yesq+2,xesq;"\{i7}\a\{i5}\b\c"
print at yesq+1,xesq;"\{p0}\{i0}   "
POKE UINTEGER iniUDGS,@espada(0)
IF dir=1 THEN print at y+1,x+3;"\{i7}\a":END IF
IF dir=-1 THEN print at y+1,x-1;"\{i7}\b":END IF
border 7
beep 0.05,-1
border 0
mipause(850)
POKE UINTEGER iniUDGS,@calavera(0)
print at yesq+2,xesq;"\{i7}\a\b\c"
border 7
mipause(250)
print at yesq+2,xesq;"\{p0}\{i0}   "
border 0
souls=souls+2
pintaener()
beep 0.0125,-60:beep 0.0125,-40:beep 0.0125,-20
end sub

sub coloca(yc AS UBYTE, xc AS UBYTE) :rem ------------- pone barril roto, llave o magia al romper un barril
tile=mapa(pant,yc,xc)
IF tile=27 THEN mapa(pant,yc,xc)=7:tile=mapa(pant,yc,xc):lista():END IF
IF tile=28 THEN mapa(pant,yc,xc)=8:tile=mapa(pant,yc,xc):lista():END IF
IF tile=29 THEN mapa(pant,yc,xc)=9:tile=mapa(pant,yc,xc):lista():END IF
print at yc*3,xc*3;ink c1;"\a";ink c2;"\b";ink c3;"\c"
print at (yc*3)+1,xc*3;ink c4;"\d";ink c5;"\e";ink c6;"\f"
print at (yc*3)+2,xc*3;ink c7;"\g";ink c8;"\h";ink c9;"\i"
end sub

sub mipause(frames AS UINTEGER) :REM ------ hace una pausa ---------------------------------------------------------------------------------------------
FOR t=0 TO frames:NEXT t
end sub

sub jefe() :REM ---------------------------- ENEMIGO FINAL -----------------------------------------------------------------------------
contdisparo=contdisparo+1

IF contdisparo>=10 and disparando=0 THEN 
   contdisparo=0:disparando=1:yb=2
   IF (int((0-100+0)*rnd)+100)>50 THEN xb=9:ELSE:xb=13:END IF
   IF xb<x THEN direnem=1:END IF
   IF xb>x THEN direnem=-1:END IF
   IF xb=x or xb=x+1 or xb=x+2 THEN direnem=0:END IF   
END IF
IF disparando=1 THEN disparo():END IF
end sub

sub disparo() :REM ------------------------ DISPARO ENEMIGO FINAL ---------------------------------------------------------------------
POKE UINTEGER iniUDGS,@bola(0)
contbola=contbola+1
IF contbola>=8 THEN contbola=0:contb=contb+1
   print at yb,xb;"  "
   print at yb-1,xb;"  "
   IF yb<14 and xb>1 and xb<24 THEN 
      IF contb>=2 THEN contb=0
         IF direnem=1 THEN xb=xb+1:END IF
         IF direnem=-1 THEN xb=xb-1:END IF
      END IF
      yb=yb+1  
      print at yb,xb;"\{i2}\a\a"
      print at yb-1,xb;"\{i2}\a\a"
      
   
      IF yb>=y-1 and xb>=x-1 and xb<=x+3 THEN    
          print at yb,xb;"\{i6}\b"
          contb=0:disparando=0
          print at yb,xb;"\{i6}\b\b"
          print at yb-1,xb;"\{i6}\b\b"
          restapone(0):energia=energia-1
          explos()
          print at yb,xb;"  "
          print at yb-1,xb;"  "  
      ELSE
         IF yb=14 or xb=1 or xb=24 THEN 
            print at yb,xb;"\{i6}\b\b"
            print at yb-1,xb;"\{i6}\b\b"
            contb=0:disparando=0
            explos()
            print at yb,xb;"  "
            print at yb-1,xb;"  "
         END IF
      END IF  
      
   END IF
END IF

end sub

sub explos() :rem --------------- SONIDO DE LA BOLA DEL JEFE FINAL
BORDER 2:BEEP 0.01,-10:BEEP 0.05,-22:BORDER 6:BEEP 0.005,-10: BEEP 0.025,-22:BORDER 7:
BEEP 0.01,-40:BORDER 6:BEEP 0.005,-50:BORDER 2:BEEP 0.01,-40:BORDER 7:BEEP 0.005,-30:BORDER 0
end sub

sub golpejefe() :REM ------------ EFECTO CUANDO GOLPEAS LA GARRA
border 7
beep 0.001,-20:beep 0.001,0:beep 0.001,30
border 0
end sub

sub fin() :REM ----------------- FINAL DEL JUEGO
FOR xx=0 TO 50
   border 2
   beep 0.05,-30
   POKE UINTEGER iniUDGS,@sangre(0)
   ink 2
   print at int((0-24+0)*rnd)+24,int((0-32+0)*rnd)+32;"\{b1}\a"
   print at int((0-24+0)*rnd)+24,int((0-32+0)*rnd)+32;"\b"
   print at int((0-24+0)*rnd)+24,int((0-32+0)*rnd)+32;"\c"
   border 6
   beep 0.05,-50
   border 0
   beep 0.05,-20
NEXT xx
border 7:paper 7:cls
mipause(100)
border 0:paper 0:ink 0:cls
POKE UINTEGER iniUDGS,@letrasfin(0)
print at 11,13;"\{b1}\{i7}\a\b\c"
print at 12,13;"\{i6}\d\e\f"
mipause(7500)
border 7:paper 7:cls
mipause(100)
border 0:paper 0:ink 0:cls
beep 0.001,-20:beep 0.001,0:beep 0.001,30
100
goto 100
end sub

sub fxm()
beep 0.025,-5:beep 0.025,0:beep 0.025,5
end sub
