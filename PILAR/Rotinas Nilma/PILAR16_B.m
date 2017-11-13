%FUNCAO QUE CALCULA A �REA DE A�O LONGITUDINAL
%Nesta fun��o, a metodologia de c�lculo de As para os pilares central (ou
%intermedi�rio), de extremidade (ou lateral) foi retirada do livro CURSO DE
%CONCRETO ARMADO Jos� Milton Araujo VOLUME 3.
%A metodologia de c�lculo de As para os pilares de canto foi adaptada
%daquela utilizada em pilares de extremidade.

function[As,nbarras]=PILAR16_B(Realizacao,Npilar,Nsd,fcd,cobp,ex,ey,hx,hy,POSPILAR,fyd)

ni=Nsd/(hx*hy*0.85*fcd);

if POSPILAR==3
ni=Nsd/(hx*hy*0.80*fcd);   %Ver p�gina 54 de Jos� Milton Araujo, vol. 3.
end

%Nsd:      For�a normal solicitante de c�lculo(KN)
%fcd:      Resist�ncia de c�lculo � compress�o do concreto (KN/cm2).
%cobp:     Cobrimento das armaduras(cm)
%ex e ey: excentricidades finais (cm)
%hx:       Dimens�o do pilar na dire��o x (cm)
%hy:       Dimens�o do pilar na dire��o y (cm)
%POSPILAR  Tipo de pilar quanto � posi��o em planta
%          1-Pilar central  2-Pilar de extremidade  3-Pilar de canto
%fyd:      Resist. de c�lculo ao esc. do a�o de armadura passiva(KN/cm2)
%As        �rea de a�o calculada da armadura longitudinal(cm2)
%nbarras:  N�mero de barras da armadura longitudinal calculada
%ni e mi:  Par�metros de entrada para as tabelas de dimensionamento.

%Espa�amento m�ximo entre as barras longitudinais NBR6118-18.4.2.2:
%"O espa�amento m�ximo entre eixos das barras, ..., deve ser menor ou igual
%a duas vezes a menor dimens�o da se��o no trecho considerado, sem exceder
%400 mm."
if hx<=hy
menordim=hx;%Menor dimens�o da se��o transversal (cm)
maiordim=hy;%Maior dimens�o da se��o transversal (cm)
else
menordim=hy;%Menor dimens�o da se��o transversal (cm)
maiordim=hx;%Maior dimens�o da se��o transversal (cm)
end
espbarras=[(40+2) (2*menordim+2)]; %cm
%Acrescentou-se 2cm(tanto em 40cm como em 2*menordimes�o) para considerar os estribos.
%M�ximo espa�amento admiss�vel (cm) entre barras longitudinais:
sb=min(espbarras);

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

Mdex=Nsd*ex;  %KNcm
b=hy;         %cm
h=hx;         %cm
mi=Mdex/(b*h^2*0.85*fcd);

if POSPILAR==3
mi=Mdex/(b*h^2*0.80*fcd);   %Ver p�gina 54 de Jos� Milton Araujo, vol. 3.
end

deltax=cobp/h;
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

if deltax>0.20
   disp(['Realizacao: ',num2str(Realizacao),' - PILAR ',num2str(Npilar)])    
   disp('deltax � maior que 0,20. Ver Jos� Milton Araujo. Vol.3,pg.186')
end

%Preferencialmente,ser� utilizado o menor n�mero de camadas.Apenas ser�o
%introduzidas novas camadas se o espa�amento entre as barras exceder o
%espa�amento m�ximo:
if (maiordim-2*cobp)<=sb
[omega]=FNcamsDUAS(ni,mi,deltax);%Tabelas para dimensionamento com duas camadas
nbarras=4;
end
if  sb<(maiordim-2*cobp) && (maiordim-2*cobp)/2<=sb 
[omega]=FNcamsTRES(ni,mi,deltax);%Tabelas para dimensionamento com tr�s camadas
nbarras=6;
end
if  sb<(maiordim-2*cobp)/2 && (maiordim-2*cobp)/3<=sb 
[omega]=FNcamsQUATRO(ni,mi,deltax);%Tabelas para dimensionamento com quatro camadas
nbarras=8;
end
if  sb<(maiordim-2*cobp)/3 && (maiordim-2*cobp)/4<=sb 
[omega]=FNcamsCINCO(ni,mi,deltax);%Tabelas para dimensionamento com cinco camadas
nbarras=10;
end
if  sb<(maiordim-2*cobp)/4 && (maiordim-2*cobp)/5<=sb 
[omega]=FNcamsSEIS(ni,mi,deltax);%Tabelas para dimensionamento com seis camadas
nbarras=12;
end

%C�lculo da �rea de a�o segundo a dire��o x:
Asx=omega*b*h*0.85*fcd/fyd;
%Asx: �rea de a�o (cm2)

if POSPILAR==3
Asx=omega*b*h*0.80*fcd/fyd;
%Asx: �rea de a�o (cm2)  
end

%Dimensionamento segundo a dire��o y
Mdey=Nsd*ey;  %KNcm
b=hx;         %cm
h=hy;         %cm
mi=Mdey/(b*h^2*0.85*fcd);

if POSPILAR==3
mi=Mdey/(b*h^2*0.80*fcd);  %Ver p�gina 54 de Jos� Milton Araujo, vol. 3.
end

deltay=cobp/h;
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

if deltay>0.20
   disp(['Realizacao: ',num2str(Realizacao),' - PILAR ',num2str(Npilar)])    
   disp('deltay � maior que 0,20. Ver Jos� Milton Araujo. Vol.3,pg.186')
end

%Preferencialmente ser� utilizado o menor n�mero de camadas. Apenas ser�o
%introduzidas novas camadas se o espa�amento entre as barras exceder o
%espa�amento m�ximo.
if (maiordim-2*cobp)<=sb
[omega]=FNcamsDUAS(ni,mi,deltay);%Tabelas para dimensionamento com duas camadas
nbarras=4;
end
if  sb<(maiordim-2*cobp) && (maiordim-2*cobp)/2<=sb 
[omega]=FNcamsTRES(ni,mi,deltay);%Tabelas para dimensionamento com tr�s camadas
nbarras=6;
end
if  sb<(maiordim-2*cobp)/2 && (maiordim-2*cobp)/3<=sb 
[omega]=FNcamsQUATRO(ni,mi,deltay);%Tabelas para dimensionamento com quatro camadas
nbarras=8;
end
if  sb<(maiordim-2*cobp)/3 && (maiordim-2*cobp)/4<=sb 
[omega]=FNcamsCINCO(ni,mi,deltay);%Tabelas para dimensionamento com cinco camadas
nbarras=10;
end
if  sb<(maiordim-2*cobp)/4 && (maiordim-2*cobp)/5<=sb 
[omega]=FNcamsSEIS(ni,mi,deltay);%Tabelas para dimensionamento com seis camadas
nbarras=12;
end

%C�lculo da �rea de a�o segundo a dire��o y:
Asy=omega*b*h*0.85*fcd/fyd;
%Asy: �rea de a�o (cm2)

if POSPILAR==3
Asy=omega*b*h*0.80*fcd/fyd;
%Asy: �rea de a�o (cm2)  
end

%�REA DE A�O LONGITUDINAL FINAL PARA PILARES CENTRAIS E LATERAIS
%A �rea de a�o deve ser o maior valor:Asx ou Asy
areas=[Asx Asy];
As=max(areas); %cm2

if POSPILAR ==3
%No caso de pilar de canto, como a metodologia de c�lculo de As � uma
%adapta��o da metodologia de pilar de extremidade, ent�o a �rea de a�o
%final � a soma das duas �reas:
As=Asx+Asy;    %cm2  
end

end %Fim do loop switch

