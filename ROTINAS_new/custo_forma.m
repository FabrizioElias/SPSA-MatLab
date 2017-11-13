function f_forma=custo_forma
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
%global SForma_V Custo_forma FormaL;
global SForma_V Custo_forma;
global Forma_L

%f=SForma_V*Custo_forma+Forma_L*Custo_forma;
f_forma=SForma_V*Custo_forma+Forma_L*Custo_forma;
%Forma_L:     m2
%SForma_V:    m2
%Custo_forma: R$/m2
%f:           R$
      

