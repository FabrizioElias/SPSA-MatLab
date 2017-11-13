function f_AVF=custo_AVF
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
% Cálculo do custo do peso de aço, volume de concreto e área de forma das
% vigas e lajes.
% % -----------------------------------------------------------------------
% Criada      30-Novembro-2011              NILMA ANDRADE
% Modificada 
% -------------------------------------------------------------------------

global Custo_acoV Custo_conV Custo_forV;
global SPA_V SVC_V SForma_V;
global SPA_L SVC_L SForma_L;
global SPA_P SVC_P SForma_P;
global m;
global alfa_fo beta_fo gama_fo;

f_AVF=alfa_fo*Custo_acoV(m)*(SPA_V(m)   +SPA_L(m)   +SPA_P(m))+...  %Peso do aço
      beta_fo*Custo_conV(m)*(SVC_V(m)   +SVC_L(m)   +SVC_P(m))+...  %Volume de concreto
      gama_fo*Custo_forV(m)*(SForma_V(m)+SForma_L(m)+SForma_P(m));  %Área de forma

%Peso de aço
%SPA_V:     kg   VIGA
%SPA_L:     kg   LAJE
%SPA_P:     kg   PILAR
%Custo_aco: R$/Kg
%f_AVF:     R$

%Volume de concreto
%SVC_V:          m3      VIGA
%SVC_L:          m3      LAJE
%SVC_P:          m3      PILAR
%Custo_concreto: R$/m3
%f_AVF:          R$

%Área de forma
%SForma_V:    m2      VIGA
%SForma_L:    m2      LAJE
%SForma_P:    m2      PILAR
%Custo_forma: R$/m2
%f_AVF:       R$

% alfa_fo      Coef. para ativar o custo do aço na função objetivo
% beta_fo      Coef. para ativar o custo do concreto na função objetivo
% gama_fo      Coef. para ativar o custo das formas na função objetivo
      

