function [Fcc, Fcs, fecc, fecs]=timedependet(PAR, PORTICO, ELEMENTOS, VIGA, N, DADOS, ngl, gdle,ROT)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIENCIAS
% PROGRAMA DE POS-GRADUACAO EM ENGENHARIA CIVIL        - AREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELECAO DE  MEDIA FIDELIDADE  PARA  ANALISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO
% ALUNA       Sérgio José Priori Jovino Marques Filho
% ORIENTADOR  Prof. Ezio da Rocha Araujo
% -------------------------------------------------------------------------
% DESCRICAO
% Calcula os parâmetros físicos do concreto que são dependentes do tempo.
% Módulo de elasticidada e coeficientes de retração e fluência
% -------------------------------------------------------------------------
% Criada      15-dezembro-2016                 SÉRGIO MARQUES
% -------------------------------------------------------------------------

% TODOS OS VALORES SERÃO CALCULADOS EM MPa, CONFORME FORMULÇÃO DO FIB E
% POSTERIORMETE SERÁ FEITA A TRANSFORMAÇÃO DE UNIDADE NECESSÁRIA

% DEERMINAÇÃO DA DEFORMAÇÃO ESPECÍFICA/ABSOLUTA DE FLUÊNCIA
[deltacc]=creep(PAR, PORTICO, ELEMENTOS, VIGA, N);

% DEERMINAÇÃO DA DEFORMAÇÃO ESPECÍFICA/ABSOLUTA DE RETRAÇÃO
[deltacs]=shrinkage(PORTICO, VIGA, PAR);

% DETARMINAÇÃO DA FORÇA EQUIVALENTE DE RETRAÇÃO E FLUÊNCIA
[Fcc, Fcs, fecc, fecs]=TDload(PAR, PORTICO, ELEMENTOS, VIGA, deltacc, deltacs, ngl, gdle, ROT);