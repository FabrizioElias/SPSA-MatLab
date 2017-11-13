function [PILARout]=column3(PILARin, PILARout, diamestribo)
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
% Rotina para resolu��o do sistema e determina��o dos valores de epson0 e k
% no "passo"seguinte.
% -------------------------------------------------------------------------
% MODIFICA��ES:         
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: --
% VARI�VEIS DE SA�DA:   PILARin: "structure" contendo as vari�veis necess�-
% rias ao algoritmo de detalhamento do pilar - column.m 
%--------------------------------------------------------------------------
% CRIADA EM 21-fevereiro-2016
% -------------------------------------------------------------------------

% Cria��o do vetor nulo "ys'
ys=zeros(1,PILARin.ncam);

% Dist�ncia entre CG das camadas extremas
hutil=PILARin.h-2*(PILARin.cob+diamestribo+PILARin.diambarra/2);

% Quantidade de espa�o entre barras
numespacos=PILARin.ncam-1;

% Espa�amento entre camadas de barras
espaco=hutil/numespacos;

% Coordenada da primeira camada de barras
ys(1)=-hutil/2;

% Coordenada das camadas adjacentes
for jj=2:PILARin.ncam
    ys(jj)=ys(jj-1)+espaco;
end
PILARout.ys=ys ;
