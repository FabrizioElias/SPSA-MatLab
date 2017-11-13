function f_aco=custo_aco
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
% Calculo do custo de aço.
% % -----------------------------------------------------------------------
% Criada      30-Novembro-2011              NILMA ANDRADE
% Modificada 
% -------------------------------------------------------------------------

global Custo_aco;
global SPA_V PA_L PesoacoL;
global m;

f_aco=SPA_V(m)*Custo_aco+PA_L(m)*Custo_aco;
%f_aco:     custo do aço da estrutura
%PA_L:      kg
%SPA_V:     kg
%Custo_aco: R$/Kg
%f_aco:     R$
      

