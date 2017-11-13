% Definir função "checksection"
clear all
clc

% Entradas de dados - a ser automatizado posteriormente
% SEÇÃO TRANSVERSAL
b=0.2;
h=0.32;
yT=h/2;     % ordenada do topo da seção transversal
yB=-h/2;    % ordenada da base da seção transversal
% PROPRIEDADES DOS MATERIAIS
fck=3000;  % tf/m2
fyk=50000; % tf/m2
Es=21000000;
gamac=1.4;
gamas=1.15;
fyd=fyk/gamas;
fcd=fck/gamac;
sigmacd=0.85*fcd;
epsonyd=1000*fyd/Es; % <-- Multiplicação por 1000 para que a unidade fique em termos de "por mil"
% ARRANJO DA ARMADURA - 6f10.0, 2 ferros por camada
diambarra=0.01;
ncam=3;             % qnt de barras em cada camada
distbarras=[2 2 2]; % vetor contendo a qnt de barras em cada camada
% Primeira camada de barras
ys=[-0.11 0 0.11];  % vetor contendo as coordenadas do CG da camada de barras
As=distbarras*pi*diambarra^2/4;
%ESFORÇOS SOLICITANTES
Nd=81.36; % tf
Md=3.73;  % tf*m

% ESTIMATIVA INICIAL DOS VALORES (e0;k)
epson0=0.5;
k=9.375;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%----------------------------- PROCESSAMENTO -----------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  1 PASSO - cálculo de Nr e Mr
% AÇO - Cálculo da deformação em cada camada de barra
epsonS=epson0+k.*ys;
% AÇO - Cálculo das tensões em cada camada de barra
alfa=zeros(1,ncam);
for i=1:ncam
    if epsonS<-epsonyd
        alfa(i)=-1;
    elseif epsonS>epsonyd
        alfa(i)=1;
    else
        alfa(i)=epsonS(i)/epsonyd;
    end
end
sigmaS=fyd*alfa;
% AÇO - cálculo do esforço normal e momento fletor resitente da armadura
Ns=sum(As.*sigmaS);
Ms=sum(As.*sigmaS.*ys);
% CONCRETO - cálculo das deformações na base, no centro e no topo
epsonC=[epson0+k*yB, epson0, epson0+k*yT];
% CONCRETO - cálculo das tensões na base, no centro e no topo da seção
for i=1:3
    if epsonC(i)<=0
        sigmaC(i)=0;
    elseif epsonC(i)>0 && epsonC(i)<2
        sigmaC(i)=sigmacd*epsonC(i)*(4-epsonC(i))/4;
    else
        sigmaC(i)=sigmacd;
    end
end
% CONCRETO - esforços resistentes
if epsonC(1)==epsonC(3)
    Nc=sigmaC(2)*b*h;
    Mc=0;
else
    % Cálculo de I0base
    if epsonC(1)<0
        I0base=0;
    elseif epsonC(1)>2
        I0base=sigmacd*(epsonC(1)-2/3);
    else
        I0base=sigmacd*epsonC(1)^2/2*(1-epsonC(1)/6);
    end
    % Cálculo de I0topo
    if epsonC(2)<0
        I0topo=0;
    elseif epsonC(3)>2
        I0topo=sigmacd*(epsonC(3)-2/3);
    else
        I0topo=sigmacd*epsonC(3)^2/2*(1-epsonC(3)/6);
    end
    % Delta I0
    deltaI0=I0topo-I0base;
    % Cálculo de I1base
    if epsonC(1)<0
        I1base=0
    elseif epsonC(1)>2
        I1base=sigmacd*(epsonC(1)^2/2-1/3);
    else
        I1base=sigmacd*epsonC(1)^3*(1/3-epsonC(1)/16);
    end
    % Cálculo de I1topo
    if epsonC(3)<0
        I1topo=0
    elseif epsonC(3)>2
        I1topo=sigmacd*(epsonC(3)^2/2-1/3);
    else
        I1topo=sigmacd*epsonC(3)^3*(1/3-epsonC(3)/16);
    end
    % Delta I1
    deltaI1=I1topo-I1base;
    % Esforço normal e momento fletor resistente do concreto
    Nc=b/k*deltaI0
    Mc=b/k^2*(deltaI1-epsonC(2)*deltaI0);
end

% Cálculo do esforço normal e momento fletor resistente da seção
Nr=Ns+Nc;
Mr=Ms+Mc



