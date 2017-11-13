function[f_AVF,C_Viga_aco,C_Viga_conc,C_Viga_forma,...
               C_Pilar_aco,C_Pilar_conc,C_Pilar_forma,...    
               C_Laje_aco,C_Laje_conc,C_Laje_forma]=custo_AVF_2
    
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
% vigas, lajes e pilares.
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

%VIGA
C_Viga_aco   = alfa_fo*Custo_acoV(m) * SPA_V(m);       %Peso de aço
C_Viga_conc  = beta_fo*Custo_conV(m) * SVC_V(m);       %Volume de concreto
C_Viga_forma = gama_fo*Custo_forV(m) * SForma_V(m);    %Área de forma

%PILAR
C_Pilar_aco   = alfa_fo*Custo_acoV(m) * SPA_P(m);         %Peso de aço
C_Pilar_conc  = beta_fo*Custo_conV(m) * SVC_P(m);         %Volume de concreto
C_Pilar_forma = gama_fo*Custo_forV(m) * SForma_P(m);      %Área de forma

%LAJE
C_Laje_aco    = alfa_fo*Custo_acoV(m) * SPA_L(m);     %Peso de aço
C_Laje_conc   = beta_fo*Custo_conV(m) * SVC_L(m);     %Volume de concreto
C_Laje_forma  = gama_fo*Custo_forV(m) * SForma_L(m);  %Área de forma

%TOTAL (custo de toda a estrutura)
f_AVF=alfa_fo*Custo_acoV(m)*(SPA_V(m)   +SPA_L(m)   +SPA_P(m))+...  %Peso de aço
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
      

