function [PILAR]=column3(PILAR, j)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCI�NCIAS
% PROGRAMA DE P�S-GRADUA��O EM ENGENHARIA CIVIL        - �REA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELE��O DE  M�DIA FIDELIDADE  PARA  AN�LISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO.
% ALUNO       S�rgio Jos� Priori Jovino Marques Filho
% ORIENTADOR  Prof. �zio da Rocha Ara�jo
% -------------------------------------------------------------------------
% DESCRI��O
% Rotina para c�lculo da ordenada do CG das barras.
% -------------------------------------------------------------------------
% MODIFICA��ES:         
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: --
% VARI�VEIS DE SA�DA:   PILARin: "structure" contendo as vari�veis necess�-
% rias ao algoritmo de detalhamento do pilar - column.m 
%--------------------------------------------------------------------------
% CRIADA EM 21-fevereiro-2016
% -------------------------------------------------------------------------

% C�LCULO DAS ORDENADAS DO CENTRO DE GRAVIDADE DAS BARRAS - centro de
% gravidade da se��o transversal � tomado como sendo a origem do sistema
% Cria��o do vetor nulo "ys'
ys=zeros(1,PILAR.ncam);
% Dist�ncia entre CG das camadas extremas
PILAR.hutil(j)=PILAR.hv(j)-2*(PILAR.cob+PILAR.diamestribo+PILAR.diambarra/2);
% Quantidade de espa�o entre barras
numespacos=PILAR.ncam-1;
% Espa�amento entre camadas de barras
espaco=PILAR.hutil(j)/numespacos;
% Coordenada da primeira camada de barras
ys(1)=-PILAR.hutil(j)/2;
% Coordenada das camadas adjacentes
for jj=2:PILAR.ncam
    ys(jj)=ys(jj-1)+espaco;
end
PILAR.ys=ys ;

% C�LCULO DA �REA DE A�O EM CADA CAMADA DE BARRA
% N�mero de barras por camada
nbcam=2*ones(1,PILAR.ncam);
nbcam(1)=PILAR.ncol;
nbcam(PILAR.ncam)=PILAR.ncol;
% �rea de a�o por camada
Asbarra=pi*(PILAR.diambarra)^2/4;
PILAR.As=Asbarra*nbcam;

PILAR.Astotal=sum(PILAR.As);


