%FUNÇÃO QUE FORNECE OS DADOS DO PROBLEMA
function[Es,fck,fy,fywk,rs,cobp,lo,gamac,gamas,gamar,romin,...
         teta,beta,neta1,neta2,neta3,alfaanc,alfaest,POSPILAR]=PILAR6

%PROPRIEDADES DO MATERIAL
Es=210000;         %Módulo de elasticidade do aço (MPa)
fck=20;            %Resistência à compressão do concreto (MPA)
fy=500;            %Resistência ao escoamento do aço de armadura passiva(MPa)      
fywk=500;          %Resist. ao escoamento do aço da arm. transversal(MPa)
                   %NBR6118-17.4.1.1.2  
rs=7.85*10^-6*1000;%Massa específica do aço (kg/cm3).NBR6118-8.3.3
                   %rs=7.85*10^-6; (tonelada/cm3)
               
%CARACTERÍSTICAS GEOMÉTRICAS
cobp=2.5;  %Cobrimento das armaduras(cm)
lo=300;  %Altura do pilar medida entre as faces internas das lajes (cm).

%COEFICIENTES DE PONDERAÇÃO
gamac=1.4;    %Coeficiente de ponderação da resistência do concreto 
gamas=1.15;   %Coeficiente de ponderação da resistência do aço  
gamar=1.4;    %Coeficiente de ponderação das ações 

%OUTROS DADOS 
romin=0.15;%Taxa geométrica mínima de armadura longitudinal de vigas.NBR6118-Tabela 17.3.   
teta=45;   %Ângulo de inclinação das fissuras (graus).   
beta=90;   %Ângulo de inclinação dos estribos (graus).
%neta1,neta2,neta3 Coeficientes para cálculo da tensão de aderência da
%armadura passiva.NBR6118-9.1.
neta1=2.25;
neta2=1;
neta3=1;
alfaanc=1;%Coef. para cálculo do comprimento de ancoragem necessário.NBR6118-9.4.2.5.
alfaest=90;
%controlVc

%TIPO DE PILAR QUANTO À POSIÇÃO EM PLANTA
POSPILAR=3;
%POSPILAR=1 para pilares centrais
%POSPILAR=2 para pilares de extremidade
%POSPILAR=3 para pilares de canto





                 
