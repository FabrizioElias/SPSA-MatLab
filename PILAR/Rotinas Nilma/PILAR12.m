%FUN��O QUE CALCULA:MOMENTO DE IN�RCIA,RAIO DE GIRA��O,COMPRIMENTO DE
%FLAMBAGEM E �NDICE DE ESBELTEZ

function[Ix,Iy,raiox,raioy,lex,ley,lambdax,lambday]=PILAR12(hx,hy,lo)
%hx       Dimens�o do pilar na dire��o x (cm)
%hy       Dimens�o do pilar na dire��o y (cm)
%lo: Altura do pilar medida entre as faces internas das lajes (cm).
%NBR6118-15.6:lo � a dist�ncia entre as faces internas dos elementos estruturais,
%supostos horizontais, que vinculam o pilar.

%Ix: Momento de in�rcia 
%Iy: Momento de in�rcia 
%
Ix=(hy*hx^3/12);        %cm4 
Iy=(hx*hy^3/12);        %cm4
raiox=sqrt(Ix/(hx*hy)); %raio de gira��o (cm)
raioy=sqrt(Iy/(hx*hy)); %raio de gira��o (cm)

l=lo+12;
%12cm � uma estimativa para a espessura da laje

%Comprimento de flambagem: Jos� Milton Araujo,VOL.3,pg.90 e 128
%Roberto Chust: pg. 317 e 318

%Comprimento de flambagem para a situa��o de v�nculo engaste-engaste:0.5lo
%NBR6118 15.6 - Valores m�ximos de le:lo+h ou l
%a=[0.5*lo (lo+hx) l];%Valores de lex (cm)
a=[(lo+hx) l];%Valores de lex (cm)
lex=min(a);%Comprimento de flambagem (cm)
%b=[0.5*lo (lo+hy) l];%Valores de ley (cm)
b=[(lo+hy) l];%Valores de ley (cm)
ley=min(b);%Comprimento de flambagem (cm)

lambdax=lex/raiox; %�ndice de esbeltez 
lambday=ley/raioy; %�ndice de esbeltez 

end

 







            