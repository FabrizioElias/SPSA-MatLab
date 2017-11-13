%FUN��O QUE FORNECE OS DADOS DO PROBLEMA
function[Es,fck,fy,fywk,rs,cobp,lo,gamac,gamas,gamar,romin,...
         teta,beta,neta1,neta2,neta3,alfaanc,alfaest,POSPILAR]=PILAR6

%PROPRIEDADES DO MATERIAL
Es=210000;         %M�dulo de elasticidade do a�o (MPa)
fck=20;            %Resist�ncia � compress�o do concreto (MPA)
fy=500;            %Resist�ncia ao escoamento do a�o de armadura passiva(MPa)      
fywk=500;          %Resist. ao escoamento do a�o da arm. transversal(MPa)
                   %NBR6118-17.4.1.1.2  
rs=7.85*10^-6*1000;%Massa espec�fica do a�o (kg/cm3).NBR6118-8.3.3
                   %rs=7.85*10^-6; (tonelada/cm3)
               
%CARACTER�STICAS GEOM�TRICAS
cobp=2.5;  %Cobrimento das armaduras(cm)
lo=300;  %Altura do pilar medida entre as faces internas das lajes (cm).

%COEFICIENTES DE PONDERA��O
gamac=1.4;    %Coeficiente de pondera��o da resist�ncia do concreto 
gamas=1.15;   %Coeficiente de pondera��o da resist�ncia do a�o  
gamar=1.4;    %Coeficiente de pondera��o das a��es 

%OUTROS DADOS 
romin=0.15;%Taxa geom�trica m�nima de armadura longitudinal de vigas.NBR6118-Tabela 17.3.   
teta=45;   %�ngulo de inclina��o das fissuras (graus).   
beta=90;   %�ngulo de inclina��o dos estribos (graus).
%neta1,neta2,neta3 Coeficientes para c�lculo da tens�o de ader�ncia da
%armadura passiva.NBR6118-9.1.
neta1=2.25;
neta2=1;
neta3=1;
alfaanc=1;%Coef. para c�lculo do comprimento de ancoragem necess�rio.NBR6118-9.4.2.5.
alfaest=90;
%controlVc

%TIPO DE PILAR QUANTO � POSI��O EM PLANTA
POSPILAR=3;
%POSPILAR=1 para pilares centrais
%POSPILAR=2 para pilares de extremidade
%POSPILAR=3 para pilares de canto





                 
