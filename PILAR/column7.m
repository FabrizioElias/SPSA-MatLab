function [PILARresults]=column7(PILARin, PILARout, PILARresults, i, pilar, PORTICO)
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
% Rotina para dc�lculo dos esfor�os resitentes da se��o de concreto armado
% -------------------------------------------------------------------------
% MODIFICA��ES:         
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: --
% VARI�VEIS DE SA�DA:   PILARin: "structure" contendo as vari�veis necess�-
% rias ao algoritmo de detalhamento do pilar - column.m 
%--------------------------------------------------------------------------
% CRIADA EM 21-fevereiro-2016
% -------------------------------------------------------------------------
global m

% % Encontra o menor peso de a�o dentro os diversos calculados
% menorpeso=min(PILARout.As);          
% % Encontra a posi��o da bitola que fornece o menor peso de a�o
% posbitola=find(PILARout.As==menorpeso,1);   

% INDICADORES A�O
% C�lculo da �rea de a�o, peso da armadura longitudinal, distribui��o de
% barras na se��o e di�metro da barra que forneceu o menor peso de a�o.
PILARresults.As(m,i)=PILARout.As(posbitola);
PILARresults.PesoArmLong(m,i)=PILARresults.As(m,i)*PORTICO.comp(pilar)*PILARin.roaco*100;
% PILARresults.distbarras(i,:,m)=PILARout.distbarras(posbitola,:);
% PILARresults.diambarra(i,:,m)=PILARout.diambarra(posbitola);

% INDICADORES CONCRETO
% C�lculo do volume de concreto e �rea de forma
PILARresults.Volconc(m,i)=PILARin.b*PILARin.h*PORTICO.comp(pilar);
PILARresults.Aforma(m,i)=(2*PILARin.b+2*PILARin.h)*PORTICO.comp(pilar);
