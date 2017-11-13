%FUN��O QUE CALCULA O PESO DO A�O
function[PesoacoP]=PILAR32(Vaco_P,Vlong,Vtrans,rs)

%Peso de a�o total (kg)
PesoacoP=Vaco_P*rs;

%Peso do a�o da armadura longitudinal (kg):
Plong   =Vlong*rs;

%Peso do a�o da armadura transversal (kg):
Ptrans  =Vtrans*rs;

%Vaco_P      Volume total de a�o (cm3 )
%Vlong       Volume da armadura longitudinal (cm3)
%Vtrans      Volume da armadura transversal (cm3):
%rs          Massa espec�fica do a�o (kg/cm3). NBR6118-8.3.3
