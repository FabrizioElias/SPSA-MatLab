function [Fcc, Fcs, fecc, fecs]=timedependet(PAR, PORTICO, ELEMENTOS, VIGA, N, DADOS, ngl, gdle,ROT)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIENCIAS
% PROGRAMA DE POS-GRADUACAO EM ENGENHARIA CIVIL        - AREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELECAO DE  MEDIA FIDELIDADE  PARA  ANALISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO
% ALUNA       S�rgio Jos� Priori Jovino Marques Filho
% ORIENTADOR  Prof. Ezio da Rocha Araujo
% -------------------------------------------------------------------------
% DESCRICAO
% Calcula os par�metros f�sicos do concreto que s�o dependentes do tempo.
% M�dulo de elasticidada e coeficientes de retra��o e flu�ncia
% -------------------------------------------------------------------------
% Criada      15-dezembro-2016                 S�RGIO MARQUES
% -------------------------------------------------------------------------

% TODOS OS VALORES SER�O CALCULADOS EM MPa, CONFORME FORMUL��O DO FIB E
% POSTERIORMETE SER� FEITA A TRANSFORMA��O DE UNIDADE NECESS�RIA

% DEERMINA��O DA DEFORMA��O ESPEC�FICA/ABSOLUTA DE FLU�NCIA
[deltacc]=creep(PAR, PORTICO, ELEMENTOS, VIGA, N);

% DEERMINA��O DA DEFORMA��O ESPEC�FICA/ABSOLUTA DE RETRA��O
[deltacs]=shrinkage(PORTICO, VIGA, PAR);

% DETARMINA��O DA FOR�A EQUIVALENTE DE RETRA��O E FLU�NCIA
[Fcc, Fcs, fecc, fecs]=TDload(PAR, PORTICO, ELEMENTOS, VIGA, deltacc, deltacs, ngl, gdle, ROT);