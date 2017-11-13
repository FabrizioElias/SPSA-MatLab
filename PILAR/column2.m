function [nbxmax, nbymax, diamestribo]=column2(PILARin)
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
% Rotina para da determina��o da matriz de rigidezes da se��o transversal
% -------------------------------------------------------------------------
% MODIFICA��ES:         
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: --
% VARI�VEIS DE SA�DA:   PILARin: "structure" contendo as vari�veis necess�-
% rias ao algoritmo de detalhamento do pilar - column.m 
%--------------------------------------------------------------------------
% CRIADA EM 21-fevereiro-2016
% -------------------------------------------------------------------------

% ESTIMATIVA DO DI�METRO DO ESTRIBO - 5.0 para barras com di�metro iferior 
% a 20mm e 8.0 para barras com di�metro superior a 20mm
if PILARin.diambarra~=25
    diamestribo=0.005;
else
    diamestribo=0.008;
end

% ESPA�AMENTO M�NIMO ENTRE BARRAS
esp=max([0.02, PILARin.diambarra, 1.2*PILARin.diamagregado]);

% DETERMINA��O DO N�MERO M�XIMO DE BARRAS NAS DIRE��ES X E Y
nbxmax=floor((PILARin.b-2*(PILARin.cob+diamestribo)+esp)/(PILARin.diambarra+esp)); % <-- Qnt m�x de barras em x
nbymax=floor((PILARin.h-2*(PILARin.cob+diamestribo)+esp)/(PILARin.diambarra+esp)); % <-- Qnt m�x de barras em y
