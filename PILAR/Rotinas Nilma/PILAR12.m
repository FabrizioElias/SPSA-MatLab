%FUNÇÃO QUE CALCULA:MOMENTO DE INÉRCIA,RAIO DE GIRAÇÃO,COMPRIMENTO DE
%FLAMBAGEM E ÍNDICE DE ESBELTEZ

function[Ix,Iy,raiox,raioy,lex,ley,lambdax,lambday]=PILAR12(hx,hy,lo)
%hx       Dimensão do pilar na direção x (cm)
%hy       Dimensão do pilar na direção y (cm)
%lo: Altura do pilar medida entre as faces internas das lajes (cm).
%NBR6118-15.6:lo é a distância entre as faces internas dos elementos estruturais,
%supostos horizontais, que vinculam o pilar.

%Ix: Momento de inércia 
%Iy: Momento de inércia 
%
Ix=(hy*hx^3/12);        %cm4 
Iy=(hx*hy^3/12);        %cm4
raiox=sqrt(Ix/(hx*hy)); %raio de giração (cm)
raioy=sqrt(Iy/(hx*hy)); %raio de giração (cm)

l=lo+12;
%12cm é uma estimativa para a espessura da laje

%Comprimento de flambagem: José Milton Araujo,VOL.3,pg.90 e 128
%Roberto Chust: pg. 317 e 318

%Comprimento de flambagem para a situação de vínculo engaste-engaste:0.5lo
%NBR6118 15.6 - Valores máximos de le:lo+h ou l
%a=[0.5*lo (lo+hx) l];%Valores de lex (cm)
a=[(lo+hx) l];%Valores de lex (cm)
lex=min(a);%Comprimento de flambagem (cm)
%b=[0.5*lo (lo+hy) l];%Valores de ley (cm)
b=[(lo+hy) l];%Valores de ley (cm)
ley=min(b);%Comprimento de flambagem (cm)

lambdax=lex/raiox; %Índice de esbeltez 
lambday=ley/raioy; %Índice de esbeltez 

end

 







            