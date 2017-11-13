function PesoVigas
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIENCIAS
% PROGRAMA DE POS-GRADUACAO EM ENGENHARIA CIVIL        - AREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELECAO DE  MEDIA FIDELIDADE  PARA  ANALISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO
% ALUNA       Nilma Andrade
% ORIENTADOR  Prof. Ezio da Rocha Araujo
% -------------------------------------------------------------------------
% DESCRICAO
% Soma dos pesos de aço de todas as vigas
% % -----------------------------------------------------------------------
% Criada      30-Novembro-2011              NILMA ANDRADE
% Modificada 
% -------------------------------------------------------------------------

global PA_V SPA_V;
global m;

%VIGAS
%SPA_V(m): Soma dos pesos de aço de todas as vigas para fck(m)
SPA_V(m)=sum(PA_V);



    


