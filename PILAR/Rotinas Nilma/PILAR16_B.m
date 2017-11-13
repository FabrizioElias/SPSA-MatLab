%FUNCAO QUE CALCULA A ÁREA DE AÇO LONGITUDINAL
%Nesta função, a metodologia de cálculo de As para os pilares central (ou
%intermediário), de extremidade (ou lateral) foi retirada do livro CURSO DE
%CONCRETO ARMADO José Milton Araujo VOLUME 3.
%A metodologia de cálculo de As para os pilares de canto foi adaptada
%daquela utilizada em pilares de extremidade.

function[As,nbarras]=PILAR16_B(Realizacao,Npilar,Nsd,fcd,cobp,ex,ey,hx,hy,POSPILAR,fyd)

ni=Nsd/(hx*hy*0.85*fcd);

if POSPILAR==3
ni=Nsd/(hx*hy*0.80*fcd);   %Ver página 54 de José Milton Araujo, vol. 3.
end

%Nsd:      Força normal solicitante de cálculo(KN)
%fcd:      Resistência de cálculo à compressão do concreto (KN/cm2).
%cobp:     Cobrimento das armaduras(cm)
%ex e ey: excentricidades finais (cm)
%hx:       Dimensão do pilar na direção x (cm)
%hy:       Dimensão do pilar na direção y (cm)
%POSPILAR  Tipo de pilar quanto à posição em planta
%          1-Pilar central  2-Pilar de extremidade  3-Pilar de canto
%fyd:      Resist. de cálculo ao esc. do aço de armadura passiva(KN/cm2)
%As        Área de aço calculada da armadura longitudinal(cm2)
%nbarras:  Número de barras da armadura longitudinal calculada
%ni e mi:  Parâmetros de entrada para as tabelas de dimensionamento.

%Espaçamento máximo entre as barras longitudinais NBR6118-18.4.2.2:
%"O espaçamento máximo entre eixos das barras, ..., deve ser menor ou igual
%a duas vezes a menor dimensão da seção no trecho considerado, sem exceder
%400 mm."
if hx<=hy
menordim=hx;%Menor dimensão da seção transversal (cm)
maiordim=hy;%Maior dimensão da seção transversal (cm)
else
menordim=hy;%Menor dimensão da seção transversal (cm)
maiordim=hx;%Maior dimensão da seção transversal (cm)
end
espbarras=[(40+2) (2*menordim+2)]; %cm
%Acrescentou-se 2cm(tanto em 40cm como em 2*menordimesão) para considerar os estribos.
%Máximo espaçamento admissível (cm) entre barras longitudinais:
sb=min(espbarras);

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

Mdex=Nsd*ex;  %KNcm
b=hy;         %cm
h=hx;         %cm
mi=Mdex/(b*h^2*0.85*fcd);

if POSPILAR==3
mi=Mdex/(b*h^2*0.80*fcd);   %Ver página 54 de José Milton Araujo, vol. 3.
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
   disp('deltax é maior que 0,20. Ver José Milton Araujo. Vol.3,pg.186')
end

%Preferencialmente,será utilizado o menor número de camadas.Apenas serão
%introduzidas novas camadas se o espaçamento entre as barras exceder o
%espaçamento máximo:
if (maiordim-2*cobp)<=sb
[omega]=FNcamsDUAS(ni,mi,deltax);%Tabelas para dimensionamento com duas camadas
nbarras=4;
end
if  sb<(maiordim-2*cobp) && (maiordim-2*cobp)/2<=sb 
[omega]=FNcamsTRES(ni,mi,deltax);%Tabelas para dimensionamento com três camadas
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

%Cálculo da área de aço segundo a direção x:
Asx=omega*b*h*0.85*fcd/fyd;
%Asx: Área de aço (cm2)

if POSPILAR==3
Asx=omega*b*h*0.80*fcd/fyd;
%Asx: Área de aço (cm2)  
end

%Dimensionamento segundo a direção y
Mdey=Nsd*ey;  %KNcm
b=hx;         %cm
h=hy;         %cm
mi=Mdey/(b*h^2*0.85*fcd);

if POSPILAR==3
mi=Mdey/(b*h^2*0.80*fcd);  %Ver página 54 de José Milton Araujo, vol. 3.
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
   disp('deltay é maior que 0,20. Ver José Milton Araujo. Vol.3,pg.186')
end

%Preferencialmente será utilizado o menor número de camadas. Apenas serão
%introduzidas novas camadas se o espaçamento entre as barras exceder o
%espaçamento máximo.
if (maiordim-2*cobp)<=sb
[omega]=FNcamsDUAS(ni,mi,deltay);%Tabelas para dimensionamento com duas camadas
nbarras=4;
end
if  sb<(maiordim-2*cobp) && (maiordim-2*cobp)/2<=sb 
[omega]=FNcamsTRES(ni,mi,deltay);%Tabelas para dimensionamento com três camadas
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

%Cálculo da área de aço segundo a direção y:
Asy=omega*b*h*0.85*fcd/fyd;
%Asy: Área de aço (cm2)

if POSPILAR==3
Asy=omega*b*h*0.80*fcd/fyd;
%Asy: Área de aço (cm2)  
end

%ÁREA DE AÇO LONGITUDINAL FINAL PARA PILARES CENTRAIS E LATERAIS
%A área de aço deve ser o maior valor:Asx ou Asy
areas=[Asx Asy];
As=max(areas); %cm2

if POSPILAR ==3
%No caso de pilar de canto, como a metodologia de cálculo de As é uma
%adaptação da metodologia de pilar de extremidade, então a área de aço
%final é a soma das duas áreas:
As=Asx+Asy;    %cm2  
end

end %Fim do loop switch

