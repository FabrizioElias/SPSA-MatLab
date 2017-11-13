%FUN��O QUE CALCULA PAR�METROS UTILIZADOS NOS C�LCULOS

function[Ac,cestribo,lpilar,Nsd,Vsxd,Vsyd,Msx,Msxd,Msy,Msyd,ni0]=...
        PILAR10(fcd,hx,hy,cobp,gamar,Ns,Msx,Msy,Vsx,Vsy,lo)

%PAR�METROS UTILIZADOS NOS C�LCULOS
Ac=hx*hy;  
cestribo=(2*(hx-2*cobp)+2*(hy-2*cobp))+10;
lpilar=lo+12;%Neste exemplo vou considerar a laje superior com 12cm

%hx       Dimens�o do pilar na dire��o x (cm)
%hy       Dimens�o do pilar na dire��o y (cm)
%cobp     Cobrimento das armaduras(cm)
%gamar    Coeficiente de pondera��o das a��es 
%lo       Altura do pilar medida entre as faces internas das lajes (cm).
%Ac       �rea da se��o transversal de concreto (cm2)
%cestribo Comprimento do estribo (cm).
%lpilar   Altura do pilar medida entre as faces internas das lajes + laje
%superior (cm)

%Aplicando os coeficientes de pondera��o:
Nsd=gamar*Ns;  %For�a normal solicitante de c�lculo(KN)
Msxd=gamar*Msx;%Msd:Momento fletor solicitante de c�lculo(KNm)
Msyd=gamar*Msy;
Vsxd=gamar*Vsx;  %For�a cortante solicitante de c�lculo(KN).NBR6118-17.4.2.1 
Vsyd=gamar*Vsy;  %For�a cortante solicitante de c�lculo(KN).NBR6118-17.4.2.1 

%Como as unidades adotadas s�o KN e cm, faz-se a transforma��o de MPa para 
%KN/cm2:

Msxd=Msxd*100; %KNcm
Msx=Msx*100;   %KNcm
Msyd=Msyd*100; %KNcm
Msy=Msy*100;   %KNcm

%ni0: par�metro usado no c�lculo da excentricidade de segunda ordem
%NBR6118-15.8.3.3.2.: ni � a for�a normal adimensional
%(b e h est�o em cm,Nsd em KN e fcd est� em KN/cm2)
ni0=Nsd/(hx*hy*fcd);
if ni0<0.5
ni0=0.5;
end
 
end
