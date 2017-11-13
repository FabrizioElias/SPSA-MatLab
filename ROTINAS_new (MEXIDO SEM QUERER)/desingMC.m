function [PILARresult, VIGAresult]=desingMC(PORTICO, ELEMENTOS, DADOS, CORTANTE, MOMENTO, NORMAL, VIGA, PILAR, PAR, ESTRUTURAL)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCI�NCIAS
% PROGRAMA DE P�S-GRADUA��O EM ENGENHARIA CIVIL        - �REA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELE��O DE  M�DIA FIDELIDADE  PARA  AN�LISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO.
% ALUNA       S�rgio Jos� Priori Jovino Marques Filho
% ORIENTADOR  Prof. �zio da Rocha Ara�jo
% -------------------------------------------------------------------------
% DESCRI��O
% Rotina para c�lculo do esfor�o normal nos elementos estruturais
% -------------------------------------------------------------------------
% MODIFICA��ES:         Modificada em 16/05/2015
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: PORTICO, ELEMENTOS, DADOS
% VARI�VEIS DE SA�DA:   esf: esfor�os nodais obtidos � partir do m�todo dos
%                       deslocamentos
%                       CORTANTE, MOMENTO: esfor�os internos nos elementos
%                       do p�rtico.
%--------------------------------------------------------------------------
% CRIADA EM 13-Janeiro-2015
% -------------------------------------------------------------------------

    % 2.0.6.1 - Vigas - A rotina beam.m gerencia as demais rotinas
    %disp('3.1 - VIGAS')
    
    VIGAresult.lixo=0;
    VIGAresult=beamMC(PORTICO, ELEMENTOS, DADOS, CORTANTE, MOMENTO, NORMAL, VIGA, PAR, VIGAresult, ESTRUTURAL);
    % 2.0.6.2 - Pilares - A rotina column.m gerencia as demais rotinas
    %disp('3.2 - PILARES')
    s=size(PILAR.TABELALONG);
    qntbitolas=s(2);
    PILARresult.lixo=0;
    [PILARresult]=columnMC(PILARresult, PORTICO, ELEMENTOS, DADOS, CORTANTE, MOMENTO, NORMAL, PILAR, PAR, qntbitolas, ESTRUTURAL);