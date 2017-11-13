%FUN��O QUE CALCULA O VOLUME DO A�O

function[Vaco_P,Vlong,Vtrans]=PILAR30(AsdP,lpilar,nestribos,fiTP,cestribo)
%AsdP        �rea de a�o usada na armadura longitudinal do pilar (cm2)
%lpilar      Altura do pilar medida entre as faces internas das lajes +
%            laje superior (cm)
%nestribos   N�mero de estribos do pilar
%fiTP        Di�metro do estribo do pilar (cm)
%cestribo    Comprimento do estribo (cm).

%Volume da armadura longitudinal (cm3):
%Vlong=AsdP*(lpilar+30);%Acrescentei 30cm na base do pilar
Vlong=AsdP*lpilar;

%Volume da armadura transversal (cm3):
Vtrans=nestribos*(pi*fiTP^2/4)*cestribo;

%Volume total de a�o (cm3):
Vaco_P=(Vlong)+(Vtrans);
















            