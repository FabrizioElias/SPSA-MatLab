function [nbxmax, nbymax, diamestribo]=column2(PILARin)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIÊNCIAS
% PROGRAMA DE PÓS-GRADUAÇÃO EM ENGENHARIA CIVIL        - ÁREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELEÇÃO DE  MÉDIA FIDELIDADE  PARA  ANÁLISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO.
% ALUNO       Sérgio José Priori Jovino Marques Filho
% ORIENTADOR  Prof. Ézio da Rocha Araújo
% -------------------------------------------------------------------------
% DESCRIÇÃO
% Rotina para da determinação da matriz de rigidezes da seção transversal
% -------------------------------------------------------------------------
% MODIFICAÇÕES:         
%--------------------------------------------------------------------------
% VARIÁVEIS DE ENTRADA: --
% VARIÁVEIS DE SAÍDA:   PILARin: "structure" contendo as variáveis necessá-
% rias ao algoritmo de detalhamento do pilar - column.m 
%--------------------------------------------------------------------------
% CRIADA EM 21-fevereiro-2016
% -------------------------------------------------------------------------

% ESTIMATIVA DO DIÂMETRO DO ESTRIBO - 5.0 para barras com diâmetro iferior 
% a 20mm e 8.0 para barras com diâmetro superior a 20mm
if PILARin.diambarra~=25
    diamestribo=0.005;
else
    diamestribo=0.008;
end

% ESPAÇAMENTO MÍNIMO ENTRE BARRAS
esp=max([0.02, PILARin.diambarra, 1.2*PILARin.diamagregado]);

% DETERMINAÇÃO DO NÚMERO MÁXIMO DE BARRAS NAS DIREÇÕES X E Y
nbxmax=floor((PILARin.b-2*(PILARin.cob+diamestribo)+esp)/(PILARin.diambarra+esp)); % <-- Qnt máx de barras em x
nbymax=floor((PILARin.h-2*(PILARin.cob+diamestribo)+esp)/(PILARin.diambarra+esp)); % <-- Qnt máx de barras em y
