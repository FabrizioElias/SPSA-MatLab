%FUNCAO QUE CALCULA A ÁREA DE AÇO
%Nesta função, a metodologia de cálculo de As para os pilares central (ou
%intermediário), de extremidade (ou lateral) foi retirada do livro CURSO DE
%CONCRETO ARMADO José Milton Araujo VOLUME 3.
%A metodologia de cálculo de As para os pilares de canto foi retirada de:
%APOSTILA - ESTRUTURA DE CONCRETO: Ábacos para flexão oblíqua
%Libânio Miranda Pinheiro - Lívio Túlio Baraldi - Marcelo Eduardo Porem
%PILAR DE CANTO: está incompleto. A função FOcamsDUAS.m, que contém as
%tabelas que fornecem omega (taxa de armadura), está incompleta.

function[As]=PILAR16_A(Nsd,fcd,cob,~,ey,hx,hy,POSPILAR,fyd)

ni=Nsd/(hx*hy*0.85*fcd);
%Nsd:      Força normal solicitante de cálculo(KN)
%ni e mi:  Parâmetros de entrada para as tabelas de dimensionamento.
%hx: Dimensão do pilar na direção x (cm)
%hy: Dimensão do pilar na direção y (cm)
%fcd: Resistência de cálculo à compressão do concreto (KN/cm2).
%fyd: Resist. de cálculo ao escoamento do aço de armadura passiva(KN/cm2)

%Espaçamento máximo entre as barras longitudinais NBR6118-18.4.2.2:
%"O espaçamento máximo entre eixos das barras, ..., deve ser menor ou igual
%a duas vezes a menor dimensão da seção no trecho considerado, sem exceder
%400 mm."
espbarras=[(40+2) (2*hx+2)]; %cm
%Acrescentou-se 2cm(tanto em 40cm como em 2hx) para considerar os estribos.
%Máximo espaçamento admissível (cm) entre barras longitudinais:
sb=min(espbarras);

switch POSPILAR
case 1%-----------------------------------------------------PILAR CENTRAL
%TABELAS PARA DIMENSIONAMENTO À FLEXO-COMPRESSÃO NORMAL (SEÇÕES RETANGULARES)
%CURSO DE CONCRETO ARMADO José Milton Araujo VOLUME 3
%Flexo-compressão normal      sigmacd=0.85fcd - Aço CA-50
%ANEXO 1

%Nas tabelas de José Milton Araujo, h é o lado paralelo à excentricidade.

%Como h é o lado paralelo à excentricidade,no dimensionamento segundo a
%direção x, h deve ser igual a hx, e no dimensionamento segundo a direção
%y, h deve ser igual a hy.

%Como h pode ser igual a hx ou a hy (dependendo de qual direção está sendo
%usada),delta tem dois valores: um para o dimensionamento segundo x e outro
%segundo y.
%delta: Parâmetro de entrada para as tabelas.
%"Se o parâmetro delta do problema não coincidir com nenhum dos valores
%tabelados, pode-se empregar a tabela correspondente ao parâmetro delta
%imediatamente superior ao valor cálculado.  Se delta>20, pode-se fazer uma
%extrapolação a partir dos resultados obtidos para delta=0,15 e
%delta=0,20." (Pg. 186 - José Milton Araujo)

%Neste rotina não estão contemplados valores de delta maiores que 0,20.

%Dimensionamento segundo a direção x

%ex=5.66:DADO TEMPORÀRIO****************************************************    
ex=5.66;%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
%ex=5.66:DADO TEMPORÀRIO****************************************************    
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

%Preferencialmente,será utilizado o menor número de camadas.Apenas serão
%introduzidas novas camadas se o espaçamento entre as barras exceder o
%espaçamento máximo:
if (hy-2*cob)<=sb
[omega]=FNcamsDUAS(ni,mi,deltax);%Tabelas para dimensionamento com duas camadas
end
if  sb<(hy-2*cob) && (hy-2*cob)/2<=sb 
[omega]=FNcamsTRES(ni,mi,deltax);%Tabelas para dimensionamento com três camadas
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

%Cálculo da área de aço segundo a direção x:
Asx=omega*b*h*0.85*fcd/fyd;
%Asx: Área de aço (cm2)

%Dimensionamento segundo a direção y
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

%Preferencialmente será utilizado o menor número de camadas. Apenas serão
%introduzidas novas camadas se o espaçamento entre as barras exceder o
%espaçamento máximo.
if (hy-2*cob)<=sb
[omega]=FNcamsDUAS(ni,mi,deltay);%Tabelas para dimensionamento com duas camadas
end
if  sb<(hy-2*cob) && (hy-2*cob)/2<=sb 
[omega]=FNcamsTRES(ni,mi,deltay);%Tabelas para dimensionamento com três camadas
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

%Cálculo da área de aço segundo a direção y:
Asy=omega*b*h*0.85*fcd/fyd;
%Asy: Área de aço (cm2)

%A área de aço deve ser o maior:Asx ou Asy
areas=[Asx Asy];
As=max(areas); %cm2

case 2%----------------------------------------------PILAR DE EXTREMIDADE  
%TABELAS PARA DIMENSIONAMENTO À FLEXO-COMPRESSÃO NORMAL (SEÇÕES RETANGULARES)
%CURSO DE CONCRETO ARMADO José Milton Araujo VOLUME 3
%Flexo-compressão normal      sigmacd=0.85fcd - Aço CA-50
%ANEXO 1

%Nas tabelas de José Milton Araujo, h é o lado paralelo à excentricidade.

%Como h é o lado paralelo à excentricidade,no dimensionamento segundo a
%direção x, h deve ser igual a hx, e no dimensionamento segundo a direção
%y, h deve ser igual a hy.

%Como h pode ser igual a hx ou a hy (dependendo de qual direção está sendo
%usada),delta tem dois valores: um para o dimensionamento segundo x e outro
%segundo y.
%delta: Parâmetro de entrada para as tabelas.
%"Se o parâmetro delta do problema não coincidir com nenhum dos valores
%tabelados, pode-se empregar a tabela correspondente ao parâmetro delta
%imediatamente superior ao valor cálculado.  Se delta>20, pode-se fazer uma
%extrapolação a partir dos resultados obtidos para delta=0,15 e
%delta=0,20." (Pg. 186 - José Milton Araujo)

%Neste rotina não estão contemplados valores de delta maiores que 0,20.  
    
%Dimensionamento segundo a direção x
%ex=6.24:DADO TEMPORÀRIO****************************************************    
ex=6.24;%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
%ex=6.24:DADO TEMPORÀRIO****************************************************
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

%Preferencialmente,será utilizado o menor número de camadas.Apenas serão
%introduzidas novas camadas se o espaçamento entre as barras exceder o
%espaçamento máximo:
if (hy-2*cob)<=sb
[omega]=FNcamsDUAS(ni,mi,deltax);%Tabelas para dimensionamento com duascamadas
end
if  sb<(hy-2*cob) && (hy-2*cob)/2<=sb 
[omega]=FNcamsTRES(ni,mi,deltax);%Tabelas para dimensionamento com três camadas
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

%Cálculo da área de aço segundo a direção x:
Asx=omega*b*h*0.85*fcd/fyd;
%Asx: Área de aço (cm2)

%Dimensionamento segundo a direção y
Mdey=Nsd*ey;     %KNcm
b=hx;            %cm
h=hy;            %cm
mi=Mdey/(b*h^2*0.85*fcd);

%Como h pode ser igual a hx ou a hy(dependendo de qual direção está sendo
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

%Preferencialmente será utilizado o menor número de camadas. Apenas serão
%introduzidas novas camadas se o espaçamento entre as barras exceder o
%espaçamento máximo.
if (hy-2*cob)<=sb
[omega]=FNcamsDUAS(ni,mi,deltay);%Tabelas para dimensionamento com duas camadas
end
if  sb<(hy-2*cob) && (hy-2*cob)/2<=sb 
[omega]=FNcamsTRES(ni,mi,deltay);%Tabelas para dimensionamento com três camadas
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

%Cálculo da área de aço segundo a direção y:
Asy=omega*b*h*0.85*fcd/fyd;
%Asy: Área de aço (cm2)

%A área de aço deve ser o maior:Asx ou Asy
areas=[Asx Asy];
As=max(areas);    %cm2
        
otherwise%-------------------------------------------------PILAR DE CANTO
    
%TABELAS: Apostila Estruturas de concreto: Ábacos para flexão oblíqua
%Libânio Miranda Pinheiro - Lívio Túlio Baraldi - Marcelo Eduardo Porem
ni=Nsd/(hx*hy*fcd);

%Aproximação dos valores de ni (se ni=0, seu valor não é mudado)
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
%indicados nos ábacos, podem ser usados valores aproximados" (pg. 14).
%Aproximação dos valores de deltax e deltay:
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

%Combinações de deltax e deltay-Tabela 1(pg.15)
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
%Coluna 2-segunda situação de cálculo
%Vetor ey:
%Coluna 1-primeira situacao de calculo
%Coluna 2-segunda situação de cálculo

%PRIMEIRA SITUAÇÃO DE CÁLCULO
%DADO TEMPORÁRIO****************************************************    
ex=[6.86 2.33];%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
ey=[4.67 7.00];%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
%*******************************************************************

Mdex=Nsd*ex(1);
Mdey=Nsd*ey(1);
mix=Mdex/(hy*hx^2*fcd);
miy=Mdey/(hx*hy^2*fcd);

%Preferencialmente,será utilizado o menor número de camadas.Apenas serão
%introduzidas novas camadas se o espaçamento entre as barras exceder o
%espaçamento máximo:
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

As1=omega*hx*hy*fcd/fyd;%As para a primeira situação de cálculo

%SEGUNDA SITUAÇÃO DE CÁLCULO
%DADO TEMPORÁRIO****************************************************    
ex=[6.86 2.33];%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
ey=[4.67 7.00];%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
%*******************************************************************

Mdex=Nsd*ex(1);
Mdey=Nsd*ey(1);
mix=Mdex/(hy*hx^2*fcd);
miy=Mdey/(hx*hy^2*fcd);

%Preferencialmente,será utilizado o menor número de camadas.Apenas serão
%introduzidas novas camadas se o espaçamento entre as barras exceder o
%espaçamento máximo:
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

As2=omega*hx*hy*fcd/fyd;%As para a segunda situação de cálculo

%A área de aço deve ser o maior:As1 ou As2
areas=[As1 As2];
As=max(areas);
    
end %Fim do loop switch
   
end

 







            