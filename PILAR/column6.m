function [PILARout]=column6(PILARin, PILARout, ii, AsTotal)
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
s=size(PILARin.distbarras);
for i=1:s(2)
    PILARout.distbarras(ii,i)=PILARin.distbarras(i);
end

PILARout.As(ii)=AsTotal;
PILARout.diambarra(ii)=PILARin.diambarra;
