%FUNÇÃO QUE CALCULA O COMPRIMENTO DE ANCORAGEM 

function[lbPnec]=PILAR28(fyd,fbd,As,AsdP,fiLP,alfaanc)
%fyd      Resist. de cálculo ao escoamento do aço de arm. passiva(KN/cm2)
%fbd      Resistência de aderência de cálculo entre armadura e concreto 
%         NBR-6118 9.3.2.1.(KN/cm2)
%As       Área de aço calculada da armadura longitudinal(cm2)
%AsdP     Área de aço usada na armadura longitudinal do pilar (cm2)
%fiLP     Barra de aço da armadura longitudinal do pilar (cm)
%alfaanc  Coeficiente definido no item 9.4.2.5 NBR6118
%lbnec    Comprimento de ancoragem necessário

lbP=fyd/(4*fbd)*fiLP;
lbPnec=alfaanc*lbP*As/AsdP;
    

















            