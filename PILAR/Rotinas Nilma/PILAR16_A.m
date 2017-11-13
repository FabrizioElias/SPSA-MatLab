%FUNCAO QUE CALCULA A �REA DE A�O
%Nesta fun��o, a metodologia de c�lculo de As para os pilares central (ou
%intermedi�rio), de extremidade (ou lateral) foi retirada do livro CURSO DE
%CONCRETO ARMADO Jos� Milton Araujo VOLUME 3.
%A metodologia de c�lculo de As para os pilares de canto foi retirada de:
%APOSTILA - ESTRUTURA DE CONCRETO: �bacos para flex�o obl�qua
%Lib�nio Miranda Pinheiro - L�vio T�lio Baraldi - Marcelo Eduardo Porem
%PILAR DE CANTO: est� incompleto. A fun��o FOcamsDUAS.m, que cont�m as
%tabelas que fornecem omega (taxa de armadura), est� incompleta.

function[As]=PILAR16_A(Nsd,fcd,cob,~,ey,hx,hy,POSPILAR,fyd)

ni=Nsd/(hx*hy*0.85*fcd);
%Nsd:      For�a normal solicitante de c�lculo(KN)
%ni e mi:  Par�metros de entrada para as tabelas de dimensionamento.
%hx: Dimens�o do pilar na dire��o x (cm)
%hy: Dimens�o do pilar na dire��o y (cm)
%fcd: Resist�ncia de c�lculo � compress�o do concreto (KN/cm2).
%fyd: Resist. de c�lculo ao escoamento do a�o de armadura passiva(KN/cm2)

%Espa�amento m�ximo entre as barras longitudinais NBR6118-18.4.2.2:
%"O espa�amento m�ximo entre eixos das barras, ..., deve ser menor ou igual
%a duas vezes a menor dimens�o da se��o no trecho considerado, sem exceder
%400 mm."
espbarras=[(40+2) (2*hx+2)]; %cm
%Acrescentou-se 2cm(tanto em 40cm como em 2hx) para considerar os estribos.
%M�ximo espa�amento admiss�vel (cm) entre barras longitudinais:
sb=min(espbarras);

switch POSPILAR
case 1%-----------------------------------------------------PILAR CENTRAL
%TABELAS PARA DIMENSIONAMENTO � FLEXO-COMPRESS�O NORMAL (SE��ES RETANGULARES)
%CURSO DE CONCRETO ARMADO Jos� Milton Araujo VOLUME 3
%Flexo-compress�o normal      sigmacd=0.85fcd - A�o CA-50
%ANEXO 1

%Nas tabelas de Jos� Milton Araujo, h � o lado paralelo � excentricidade.

%Como h � o lado paralelo � excentricidade,no dimensionamento segundo a
%dire��o x, h deve ser igual a hx, e no dimensionamento segundo a dire��o
%y, h deve ser igual a hy.

%Como h pode ser igual a hx ou a hy (dependendo de qual dire��o est� sendo
%usada),delta tem dois valores: um para o dimensionamento segundo x e outro
%segundo y.
%delta: Par�metro de entrada para as tabelas.
%"Se o par�metro delta do problema n�o coincidir com nenhum dos valores
%tabelados, pode-se empregar a tabela correspondente ao par�metro delta
%imediatamente superior ao valor c�lculado.  Se delta>20, pode-se fazer uma
%extrapola��o a partir dos resultados obtidos para delta=0,15 e
%delta=0,20." (Pg. 186 - Jos� Milton Araujo)

%Neste rotina n�o est�o contemplados valores de delta maiores que 0,20.

%Dimensionamento segundo a dire��o x

%ex=5.66:DADO TEMPOR�RIO****************************************************    
ex=5.66;%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
%ex=5.66:DADO TEMPOR�RIO****************************************************    
Mdex=Nsd*ex;  %KNcm
b=hy;         %cm
h=hx;         %cm
mi=Mdex/(b*h^2*0.85*fcd);

deltax=cob/h;
if 0.0<deltax && deltax<=0.05
deltax=0.05;
end
if 0.05<deltax && deltax<=0.1
deltax=0.1;
end
if 0.1<deltax && deltax<=0.15
deltax=0.15;
end
if 0.15<deltax && deltax<=0.20
deltax=0.20;
end

%Preferencialmente,ser� utilizado o menor n�mero de camadas.Apenas ser�o
%introduzidas novas camadas se o espa�amento entre as barras exceder o
%espa�amento m�ximo:
if (hy-2*cob)<=sb
[omega]=FNcamsDUAS(ni,mi,deltax);%Tabelas para dimensionamento com duas camadas
end
if  sb<(hy-2*cob) && (hy-2*cob)/2<=sb 
[omega]=FNcamsTRES(ni,mi,deltax);%Tabelas para dimensionamento com tr�s camadas
end
if  sb<(hy-2*cob)/2 && (hy-2*cob)/3<=sb 
[omega]=FNcamsQUATRO(ni,mi,deltax);%Tabelas para dimensionamento com quatro camadas
end
if  sb<(hy-2*cob)/3 && (hy-2*cob)/4<=sb 
[omega]=FNcamsCINCO(ni,mi,deltax);%Tabelas para dimensionamento com cinco camadas
end
if  sb<(hy-2*cob)/4 && (hy-2*cob)/5<=sb 
[omega]=FNcamsSEIS(ni,mi,deltax);%Tabelas para dimensionamento com seis camadas
end

%C�lculo da �rea de a�o segundo a dire��o x:
Asx=omega*b*h*0.85*fcd/fyd;
%Asx: �rea de a�o (cm2)

%Dimensionamento segundo a dire��o y
Mdey=Nsd*ey;  %KNcm
b=hx;         %cm
h=hy;         %cm
mi=Mdey/(b*h^2*0.85*fcd);

deltay=cob/h;
if 0.0<deltay && deltay<=0.05
deltay=0.05;
end
if 0.05<deltay && deltay<=0.1
deltay=0.1;
end
if 0.1<deltay && deltay<=0.15
deltay=0.15;
end
if 0.15<deltay && deltay<=0.20
deltay=0.20;
end

%Preferencialmente ser� utilizado o menor n�mero de camadas. Apenas ser�o
%introduzidas novas camadas se o espa�amento entre as barras exceder o
%espa�amento m�ximo.
if (hy-2*cob)<=sb
[omega]=FNcamsDUAS(ni,mi,deltay);%Tabelas para dimensionamento com duas camadas
end
if  sb<(hy-2*cob) && (hy-2*cob)/2<=sb 
[omega]=FNcamsTRES(ni,mi,deltay);%Tabelas para dimensionamento com tr�s camadas
end
if  sb<(hy-2*cob)/2 && (hy-2*cob)/3<=sb 
[omega]=FNcamsQUATRO(ni,mi,deltay);%Tabelas para dimensionamento com quatro camadas
end
if  sb<(hy-2*cob)/3 && (hy-2*cob)/4<=sb 
[omega]=FNcamsCINCO(ni,mi,deltay);%Tabelas para dimensionamento com cinco camadas
end
if  sb<(hy-2*cob)/4 && (hy-2*cob)/5<=sb 
[omega]=FNcamsSEIS(ni,mi,deltay);%Tabelas para dimensionamento com seis camadas
end

%C�lculo da �rea de a�o segundo a dire��o y:
Asy=omega*b*h*0.85*fcd/fyd;
%Asy: �rea de a�o (cm2)

%A �rea de a�o deve ser o maior:Asx ou Asy
areas=[Asx Asy];
As=max(areas); %cm2

case 2%----------------------------------------------PILAR DE EXTREMIDADE  
%TABELAS PARA DIMENSIONAMENTO � FLEXO-COMPRESS�O NORMAL (SE��ES RETANGULARES)
%CURSO DE CONCRETO ARMADO Jos� Milton Araujo VOLUME 3
%Flexo-compress�o normal      sigmacd=0.85fcd - A�o CA-50
%ANEXO 1

%Nas tabelas de Jos� Milton Araujo, h � o lado paralelo � excentricidade.

%Como h � o lado paralelo � excentricidade,no dimensionamento segundo a
%dire��o x, h deve ser igual a hx, e no dimensionamento segundo a dire��o
%y, h deve ser igual a hy.

%Como h pode ser igual a hx ou a hy (dependendo de qual dire��o est� sendo
%usada),delta tem dois valores: um para o dimensionamento segundo x e outro
%segundo y.
%delta: Par�metro de entrada para as tabelas.
%"Se o par�metro delta do problema n�o coincidir com nenhum dos valores
%tabelados, pode-se empregar a tabela correspondente ao par�metro delta
%imediatamente superior ao valor c�lculado.  Se delta>20, pode-se fazer uma
%extrapola��o a partir dos resultados obtidos para delta=0,15 e
%delta=0,20." (Pg. 186 - Jos� Milton Araujo)

%Neste rotina n�o est�o contemplados valores de delta maiores que 0,20.  
    
%Dimensionamento segundo a dire��o x
%ex=6.24:DADO TEMPOR�RIO****************************************************    
ex=6.24;%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
%ex=6.24:DADO TEMPOR�RIO****************************************************
Mdex=Nsd*ex;   %KNcm   
b=hy;          %cm
h=hx;          %cm
mi=Mdex/(b*h^2*0.85*fcd);

deltax=cob/h;
if 0.0<deltax && deltax<=0.05
deltax=0.05;
end
if 0.05<deltax && deltax<=0.1
deltax=0.1;
end
if 0.1<deltax && deltax<=0.15
deltax=0.15;
end
if 0.15<deltax && deltax<=0.20
deltax=0.20;
end

%Preferencialmente,ser� utilizado o menor n�mero de camadas.Apenas ser�o
%introduzidas novas camadas se o espa�amento entre as barras exceder o
%espa�amento m�ximo:
if (hy-2*cob)<=sb
[omega]=FNcamsDUAS(ni,mi,deltax);%Tabelas para dimensionamento com duascamadas
end
if  sb<(hy-2*cob) && (hy-2*cob)/2<=sb 
[omega]=FNcamsTRES(ni,mi,deltax);%Tabelas para dimensionamento com tr�s camadas
end
if  sb<(hy-2*cob)/2 && (hy-2*cob)/3<=sb 
[omega]=FNcamsQUATRO(ni,mi,deltax);%Tabelas para dimensionamento com quatro camadas
end
if  sb<(hy-2*cob)/3 && (hy-2*cob)/4<=sb 
[omega]=FNcamsCINCO(ni,mi,deltax);%Tabelas para dimensionamento com cinco camadas
end
if  sb<(hy-2*cob)/4 && (hy-2*cob)/5<=sb 
[omega]=FNcamsSEIS(ni,mi,deltax);%Tabelas para dimensionamento com seis camadas
end

%C�lculo da �rea de a�o segundo a dire��o x:
Asx=omega*b*h*0.85*fcd/fyd;
%Asx: �rea de a�o (cm2)

%Dimensionamento segundo a dire��o y
Mdey=Nsd*ey;     %KNcm
b=hx;            %cm
h=hy;            %cm
mi=Mdey/(b*h^2*0.85*fcd);

%Como h pode ser igual a hx ou a hy(dependendo de qual dire��o est� sendo
%usada),delta tem dois valores:um para o dimensionamento segundo x e outro
%segundo y:
deltay=cob/h;
if 0.0<deltay && deltay<=0.05
deltay=0.05;
end
if 0.05<deltay && deltay<=0.1
deltay=0.1;
end
if 0.1<deltay && deltay<=0.15
deltay=0.15;
end
if 0.15<deltay && deltay<=0.20
deltay=0.20;
end

%Preferencialmente ser� utilizado o menor n�mero de camadas. Apenas ser�o
%introduzidas novas camadas se o espa�amento entre as barras exceder o
%espa�amento m�ximo.
if (hy-2*cob)<=sb
[omega]=FNcamsDUAS(ni,mi,deltay);%Tabelas para dimensionamento com duas camadas
end
if  sb<(hy-2*cob) && (hy-2*cob)/2<=sb 
[omega]=FNcamsTRES(ni,mi,deltay);%Tabelas para dimensionamento com tr�s camadas
end
if  sb<(hy-2*cob)/2 && (hy-2*cob)/3<=sb 
[omega]=FNcamsQUATRO(ni,mi,deltay);%Tabelas para dimensionamento com quatro camadas
end
if  sb<(hy-2*cob)/3 && (hy-2*cob)/4<=sb 
[omega]=FNcamsCINCO(ni,mi,deltay);%Tabelas para dimensionamento com cinco camadas
end
if  sb<(hy-2*cob)/4 && (hy-2*cob)/5<=sb 
[omega]=FNcamsSEIS(ni,mi,deltay);%Tabelas para dimensionamento com seis camadas
end

%C�lculo da �rea de a�o segundo a dire��o y:
Asy=omega*b*h*0.85*fcd/fyd;
%Asy: �rea de a�o (cm2)

%A �rea de a�o deve ser o maior:Asx ou Asy
areas=[Asx Asy];
As=max(areas);    %cm2
        
otherwise%-------------------------------------------------PILAR DE CANTO
    
%TABELAS: Apostila Estruturas de concreto: �bacos para flex�o obl�qua
%Lib�nio Miranda Pinheiro - L�vio T�lio Baraldi - Marcelo Eduardo Porem
ni=Nsd/(hx*hy*fcd);

%Aproxima��o dos valores de ni (se ni=0, seu valor n�o � mudado)
if 0.0<ni && ni<=0.20
ni=0.20;
end
if 0.20<ni && ni<=0.40
ni=0.40;
end
if 0.40<ni && ni<=0.60
ni=0.60;
end
if 0.60<ni && ni<=0.80
ni=0.80;
end
if 0.80<ni && ni<=1.0
ni=1.0;
end
if 1.0<ni && ni<=1.20
ni=1.20;
end
if 1.20<ni && ni<=1.40
ni=1.40;
end

%Segundo a apostila,"para valores de d'y/hy e d'x/hx diferentes dos
%indicados nos �bacos, podem ser usados valores aproximados" (pg. 14).
%Aproxima��o dos valores de deltax e deltay:
deltax=cob/hx;
if 0.0<deltax && deltax<=0.10
deltax=0.10;
end
if 0.10<deltax && deltax<=0.15
deltax=0.15;
end
if 0.15<deltax && deltax<=0.20
deltax=0.20;
end
if 0.20<deltax && deltax<=0.25
deltax=0.25;
end

deltay=cob/hy;
if 0.0<deltay && deltay<=0.10
deltay=0.10;
end
if 0.10<deltay && deltay<=0.15
deltay=0.15;
end

%Combina��es de deltax e deltay-Tabela 1(pg.15)
if deltay==0.05 && deltax==0.25
comb=1;
end
if deltay==0.10 && deltax==0.25
comb=2;
end
if deltay==0.15 && deltax==0.25
comb=3;
end
if deltay==0.05 && deltax==0.20
comb=4;
end
if deltay==0.10 && deltax==0.20
comb=5;
end
if deltay==0.15 && deltax==0.20
comb=6;
end
if deltay==0.05 && deltax==0.15
comb=7;
end
if deltay==0.10 && deltax==0.15
comb=8;
end
if deltay==0.15 && deltax==0.15
comb=9;
end
if deltay==0.10 && deltax==0.10
comb=10;
end

%Vetor ex:
%Coluna 1-primeira situacao de calculo
%Coluna 2-segunda situa��o de c�lculo
%Vetor ey:
%Coluna 1-primeira situacao de calculo
%Coluna 2-segunda situa��o de c�lculo

%PRIMEIRA SITUA��O DE C�LCULO
%DADO TEMPOR�RIO****************************************************    
ex=[6.86 2.33];%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
ey=[4.67 7.00];%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
%*******************************************************************

Mdex=Nsd*ex(1);
Mdey=Nsd*ey(1);
mix=Mdex/(hy*hx^2*fcd);
miy=Mdey/(hx*hy^2*fcd);

%Preferencialmente,ser� utilizado o menor n�mero de camadas.Apenas ser�o
%introduzidas novas camadas se o espa�amento entre as barras exceder o
%espa�amento m�ximo:
if (hy-2*cob)<=sb
[omega]=FOcamsDUAS(ni,mix,miy,deltax,deltay,comb);
end
% if  sb<(hy-2*cob) && (hy-2*cob)/2<=sb 
% [omega]=FOcamsTRES(ni,mix,miy,deltax,deltay,comb);
% end
% if  sb<(hy-2*cob)/2 && (hy-2*cob)/3<=sb 
% [omega]=FOcamsQUATRO(ni,mix,miy,deltax,deltay,comb);
% end
% if  sb<(hy-2*cob)/3 && (hy-2*cob)/4<=sb 
% [omega]=FOcamsCINCO(ni,mix,miy,deltax,deltay,comb);
% end
% if  sb<(hy-2*cob)/4 && (hy-2*cob)/5<=sb 
% [omega]=FOcamsSEIS(ni,mix,miy,deltax,deltay,comb);
% end

As1=omega*hx*hy*fcd/fyd;%As para a primeira situa��o de c�lculo

%SEGUNDA SITUA��O DE C�LCULO
%DADO TEMPOR�RIO****************************************************    
ex=[6.86 2.33];%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
ey=[4.67 7.00];%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
%*******************************************************************

Mdex=Nsd*ex(1);
Mdey=Nsd*ey(1);
mix=Mdex/(hy*hx^2*fcd);
miy=Mdey/(hx*hy^2*fcd);

%Preferencialmente,ser� utilizado o menor n�mero de camadas.Apenas ser�o
%introduzidas novas camadas se o espa�amento entre as barras exceder o
%espa�amento m�ximo:
if (hy-2*cob)<=sb
[omega]=FOcamsDUAS(ni,mix,miy,comb);
end
% if  sb<(hy-2*cob) && (hy-2*cob)/2<=sb 
% [omega]=FOcamsTRES(ni,mix,miy,deltax,deltay,comb);
% end
% if  sb<(hy-2*cob)/2 && (hy-2*cob)/3<=sb 
% [omega]=FOcamsQUATRO(ni,mix,miy,deltax,deltay,comb);
% end
% if  sb<(hy-2*cob)/3 && (hy-2*cob)/4<=sb 
% [omega]=FOcamsCINCO(ni,mix,miy,deltax,deltay,comb);
% end
% if  sb<(hy-2*cob)/4 && (hy-2*cob)/5<=sb 
% [omega]=FOcamsSEIS(ni,mix,miy,deltax,deltay,comb);
% end

As2=omega*hx*hy*fcd/fyd;%As para a segunda situa��o de c�lculo

%A �rea de a�o deve ser o maior:As1 ou As2
areas=[As1 As2];
As=max(areas);
    
end %Fim do loop switch
   
end

 







            