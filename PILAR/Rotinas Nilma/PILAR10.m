%FUNÇÃO QUE CALCULA PARÂMETROS UTILIZADOS NOS CÁLCULOS

function[Ac,cestribo,lpilar,Nsd,Vsxd,Vsyd,Msx,Msxd,Msy,Msyd,ni0]=...
        PILAR10(fcd,hx,hy,cobp,gamar,Ns,Msx,Msy,Vsx,Vsy,lo)

%PARÂMETROS UTILIZADOS NOS CÁLCULOS
Ac=hx*hy;  
cestribo=(2*(hx-2*cobp)+2*(hy-2*cobp))+10;
lpilar=lo+12;%Neste exemplo vou considerar a laje superior com 12cm

%hx       Dimensão do pilar na direção x (cm)
%hy       Dimensão do pilar na direção y (cm)
%cobp     Cobrimento das armaduras(cm)
%gamar    Coeficiente de ponderação das ações 
%lo       Altura do pilar medida entre as faces internas das lajes (cm).
%Ac       Área da seção transversal de concreto (cm2)
%cestribo Comprimento do estribo (cm).
%lpilar   Altura do pilar medida entre as faces internas das lajes + laje
%superior (cm)

%Aplicando os coeficientes de ponderação:
Nsd=gamar*Ns;  %Força normal solicitante de cálculo(KN)
Msxd=gamar*Msx;%Msd:Momento fletor solicitante de cálculo(KNm)
Msyd=gamar*Msy;
Vsxd=gamar*Vsx;  %Força cortante solicitante de cálculo(KN).NBR6118-17.4.2.1 
Vsyd=gamar*Vsy;  %Força cortante solicitante de cálculo(KN).NBR6118-17.4.2.1 

%Como as unidades adotadas são KN e cm, faz-se a transformação de MPa para 
%KN/cm2:

Msxd=Msxd*100; %KNcm
Msx=Msx*100;   %KNcm
Msyd=Msyd*100; %KNcm
Msy=Msy*100;   %KNcm

%ni0: parâmetro usado no cálculo da excentricidade de segunda ordem
%NBR6118-15.8.3.3.2.: ni é a força normal adimensional
%(b e h estão em cm,Nsd em KN e fcd está em KN/cm2)
ni0=Nsd/(hx*hy*fcd);
if ni0<0.5
ni0=0.5;
end
 
end
