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
%[epsoncc, deltacc]=creep(PAR, PORTICO, ELEMENTOS, VIGA, N);
%FAB - epsoncc não é utilizado na função, podendo ser ignorado. Mesma coisa
%abaixo com epsoncs.
[~, deltacc]=creep(PAR, PORTICO, ELEMENTOS, VIGA, N);

% DETERMINAÇÃO DA DEFORMAÇÃO ESPECÍFICA/ABSOLUTA DE RETRAÇÃO
% Três modelos foram implementados para o cálculo da deformação específica
% de retração: FIB MC2010, NBR6118/2014 e FIB MC90. A seleção da opção deve
% ser feita no cartão de entrada.
if DADOS.op_phisicalpar==0      % <-- FIB MC2010
    [~, deltacs]=shrinkageFIBMC2010(PAR, VIGA, PORTICO);
elseif DADOS.op_phisicalpar==1  % <-- NBR 6118/20114
    [~, deltacs]=shrinkageNBR(PAR, VIGA, PORTICO);
elseif DADOS.op_phisicalpar==2  % <-- FIB MC90
    [~, deltacs]=shrinkageFIBMC90(PAR, VIGA, PORTICO);
end

% DETERMINAÇÃO DA FORÇA EQUIVALENTE DE RETRAÇÃO E FLUÊNCIA
[Fcc, Fcs, fecc, fecs]=TDload(PAR, PORTICO, ELEMENTOS, VIGA, deltacc, deltacs, ngl, gdle, ROT);