function [PILARresult, VIGAresult]=desingMC(PORTICO, ELEMENTOS, DADOS, CORTANTE, MOMENTO, NORMAL, VIGA, PILAR, PAR, ESTRUTURAL, TRANSX)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIÊNCIAS
% PROGRAMA DE PÓS-GRADUAÇÃO EM ENGENHARIA CIVIL        - ÁREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELEÇÃO DE  MÉDIA FIDELIDADE  PARA  ANÁLISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO.
% ALUNA       Sérgio José Priori Jovino Marques Filho
% ORIENTADOR  Prof. Ézio da Rocha Araújo
% -------------------------------------------------------------------------
% DESCRIÇÃO
% Rotina para cálculo do esforço normal nos elementos estruturais
% -------------------------------------------------------------------------
% MODIFICAÇÕES:         Modificada em 16/05/2015
%--------------------------------------------------------------------------
% VARIÁVEIS DE ENTRADA: PORTICO, ELEMENTOS, DADOS
% VARIÁVEIS DE SAÍDA:   esf: esforços nodais obtidos à partir do método dos
%                       deslocamentos
%                       CORTANTE, MOMENTO: esforços internos nos elementos
%                       do pórtico.
%--------------------------------------------------------------------------
% CRIADA EM 13-Janeiro-2015
% -------------------------------------------------------------------------

global m

% GERA COMBINAÇÕES DE CARGA
    [COMBColumn, COMBPile, SOLO]=combinacao(PORTICO, DADOS, MOMENTO, NORMAL, PILAR, ESTRUTURAL, TRANSX);

    % 2.0.6.1 - Vigas - A rotina beam.m gerencia as demais rotinas
    %disp('3.1 - VIGAS')
    
    % NESSE CASO PARTICULAR - OTIMIZAÇÃO SOB INCERTEZA - A VIGA NÃO SERÁ
    % DIMENSIONADA UMA VEZ QUE ELA NÃO TERÁ SUAS DIMENSÕES OTIMIZADAS. POR
    % ISSO A SUBROTINA PARA DIMENSIONAMENTO DE VIGAS ESTÁ COMENTADA.
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
    % Os elementos estruturais serão dimensionados para a combinação de
    % carga mais desfavorável, no caso a combinação 10. Assim, as variáveis
    % MOMENTO.total, NORMAL.total e CORTANTE.total serão referentes a
    % combinação 10.
    
    % COMBColumn(Normal, Momento)
    NORMAL.dim=COMBColumn(:,1,10);
    MOMENTO.dim=COMBColumn(:,2,10);
    s=size(PILAR.TABELALONG);
    qntbitolas=s(2);
    PILARresult.lixo=0;
    [PILARresult]=columnMC(PILARresult, PORTICO, ELEMENTOS, DADOS, CORTANTE, MOMENTO, NORMAL, PILAR, PAR, qntbitolas, ESTRUTURAL);