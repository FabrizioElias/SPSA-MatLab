%FUN��O QUE CALCULA O COMPRIMENTO DE ANCORAGEM 

function[lbPnec]=PILAR28(fyd,fbd,As,AsdP,fiLP,alfaanc)
%fyd      Resist. de c�lculo ao escoamento do a�o de arm. passiva(KN/cm2)
%fbd      Resist�ncia de ader�ncia de c�lculo entre armadura e concreto 
%         NBR-6118 9.3.2.1.(KN/cm2)
%As       �rea de a�o calculada da armadura longitudinal(cm2)
%AsdP     �rea de a�o usada na armadura longitudinal do pilar (cm2)
%fiLP     Barra de a�o da armadura longitudinal do pilar (cm)
%alfaanc  Coeficiente definido no item 9.4.2.5 NBR6118
%lbnec    Comprimento de ancoragem necess�rio

lbP=fyd/(4*fbd)*fiLP;
lbPnec=alfaanc*lbP*As/AsdP;
    

















            