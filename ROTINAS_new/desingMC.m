function [PILARresult, VIGAresult]=desingMC(PORTICO, ELEMENTOS, DADOS, CORTANTE, MOMENTO, NORMAL, VIGA, PILAR, PAR, ESTRUTURAL)
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