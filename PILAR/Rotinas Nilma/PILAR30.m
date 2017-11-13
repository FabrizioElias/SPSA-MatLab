%FUNÇÃO QUE CALCULA O VOLUME DO AÇO

function[Vaco_P,Vlong,Vtrans]=PILAR30(AsdP,lpilar,nestribos,fiTP,cestribo)
%AsdP        Área de aço usada na armadura longitudinal do pilar (cm2)
%lpilar      Altura do pilar medida entre as faces internas das lajes +
%            laje superior (cm)
%nestribos   Número de estribos do pilar
%fiTP        Diâmetro do estribo do pilar (cm)
%cestribo    Comprimento do estribo (cm).

%Volume da armadura longitudinal (cm3):
%Vlong=AsdP*(lpilar+30);%Acrescentei 30cm na base do pilar
Vlong=AsdP*lpilar;

%Volume da armadura transversal (cm3):
Vtrans=nestribos*(pi*fiTP^2/4)*cestribo;

%Volume total de aço (cm3):
Vaco_P=(Vlong)+(Vtrans);
















            