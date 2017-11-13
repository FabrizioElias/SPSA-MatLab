%FUNÇÃO QUE CALCULA O PESO DO AÇO
function[PesoacoP]=PILAR32(Vaco_P,Vlong,Vtrans,rs)

%Peso de aço total (kg)
PesoacoP=Vaco_P*rs;

%Peso do aço da armadura longitudinal (kg):
Plong   =Vlong*rs;

%Peso do aço da armadura transversal (kg):
Ptrans  =Vtrans*rs;

%Vaco_P      Volume total de aço (cm3 )
%Vlong       Volume da armadura longitudinal (cm3)
%Vtrans      Volume da armadura transversal (cm3):
%rs          Massa específica do aço (kg/cm3). NBR6118-8.3.3
