function f_vol=custo_vol
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
% Cálculo do custo do volume de concreto.
% % -----------------------------------------------------------------------
% Criada      30-Novembro-2011              NILMA ANDRADE
% Modificada 
% -------------------------------------------------------------------------

%FAB - Remoção de variáveis globais sem uso.
%global op_est;
global SVC_V Custo_concreto;
%global VolconL;
global VC_L;

%f=SVC_V*Custo_concreto+VC_L*Custo_concreto;
f_vol=SVC_V*Custo_concreto+VC_L*Custo_concreto;
%VC_L:           m3
%SVC_V:          m3
%Custo_concreto: R$/m3
%f:              R$
      

