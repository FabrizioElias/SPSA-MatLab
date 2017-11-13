function [PILARresult, VIGAresult]=desingMC(PORTICO, ELEMENTOS, DADOS, CORTANTE, MOMENTO, NORMAL, VIGA, PILAR, PAR, ESTRUTURAL, TRANSX)
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

global m

% GERA COMBINA��ES DE CARGA
    [COMBColumn, COMBPile, SOLO]=combinacao(PORTICO, DADOS, MOMENTO, NORMAL, PILAR, ESTRUTURAL, TRANSX);

    % 2.0.6.1 - Vigas - A rotina beam.m gerencia as demais rotinas
    %disp('3.1 - VIGAS')
    
    % NESSE CASO PARTICULAR - OTIMIZA��O SOB INCERTEZA - A VIGA N�O SER�
    % DIMENSIONADA UMA VEZ QUE ELA N�O TER� SUAS DIMENS�ES OTIMIZADAS. POR
    % ISSO A SUBROTINA PARA DIMENSIONAMENTO DE VIGAS EST� COMENTADA.
%-------------------------------------------------------------------------%
%     VIGAresult.lixo=0;
%     VIGAresult=beamMC(PORTICO, ELEMENTOS, DADOS, CORTANTE, MOMENTO, NORMAL, VIGA, PAR, VIGAresult, ESTRUTURAL);
VIGAresult.aformaTOTAL=0;
VIGAresult.volconcTOTAL=0;
VIGAresult.PESOestribosTOTAL=0;
VIGAresult.PESOpeleTOTAL=0;
VIGAresult.PESOmontagemTOTAL=0;
VIGAresult.PESOcompTOTAL=0;
VIGAresult.PESOposTOTAL=0;
VIGAresult.PESOnegTOTAL=0;
%-------------------------------------------------------------------------%

    % 2.0.6.2 - Pilares - A rotina column.m gerencia as demais rotinas
    %disp('3.2 - PILARES')
    % Os elementos estruturais ser�o dimensionados para a combina��o de
    % carga mais desfavor�vel, no caso a combina��o 10. Assim, as vari�veis
    % MOMENTO.total, NORMAL.total e CORTANTE.total ser�o referentes a
    % combina��o 10.
    
    % COMBColumn(Normal, Momento)
    NORMAL.dim=COMBColumn(:,1,10);
    MOMENTO.dim=COMBColumn(:,2,10);
    s=size(PILAR.TABELALONG);
    qntbitolas=s(2);
    PILARresult.lixo=0;
    [PILARresult]=columnMC(PILARresult, PORTICO, ELEMENTOS, DADOS, CORTANTE, MOMENTO, NORMAL, PILAR, PAR, qntbitolas, ESTRUTURAL);