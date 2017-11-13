function [CORTANTE, MOMENTO, NORMAL, TRANSX, TRANSZ, ROTACAO, COST, VPL]=null(D, DADOS)
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
% Rotina paracriar veores nulos que irão armazenar os esforços internos nos
% elementos do pórtico
% -------------------------------------------------------------------------
% Criada      13-janeiro-2017                 SÉRGIO MARQUES
% -------------------------------------------------------------------------

s=size(D);

% Esforço cortante
CORTANTE.PP=cell(s(1),1,DADOS.NMC);       % <-- EC TOTAL. Apenas peso próprio
CORTANTE.PROT=cell(s(1),1,DADOS.NMC);       % <-- EC TOTAL. Apenas sobrecarga atuante na estrutura
CORTANTE.VTD=cell(s(1),1,DADOS.NMC);      % <-- EC devido aos efeitos diferidos do concreto
CORTANTE.VTempPOS=cell(s(1),1,DADOS.NMC); % <-- EC devido variação positiva de temperatura
CORTANTE.VTempNEG=cell(s(1),1,DADOS.NMC); % <-- EC devido variação negativa de temperatura
CORTANTE.TREMTIPO=cell(s(1),1,DADOS.NMC); 
CORTANTE.EMPSOLO=cell(s(1),1,DADOS.NMC);
% CORTANTE.TOTAL=cell(s(1),1,DADOS.NMC);    % ESFORÇO CORTANTE FINAL (TOTAL) NA ESTRUTURA

% Momento fletor
MOMENTO.PP=cell(s(1),1,DADOS.NMC);        % <-- MF TOTAL. Apenas peso próprio
MOMENTO.PROT=cell(s(1),1,DADOS.NMC);        % <-- MF TOTAL. Apenas sobrecarga atuante na estrutura
MOMENTO.MTD=cell(s(1),1,DADOS.NMC);       % <-- MF devido aos efeitos diferidos do concreto
MOMENTO.MTempPOS=cell(s(1),1,DADOS.NMC);  % <-- MF devido variação positiva de temperatura
MOMENTO.MTempNEG=cell(s(1),1,DADOS.NMC);  % <-- MF devido variação negativa de temperatura
MOMENTO.TREMTIPO=cell(s(1),1,DADOS.NMC); 
MOMENTO.EMPSOLO=cell(s(1),1,DADOS.NMC);
% MOMENTO.TOTAL=cell(s(1),1,DADOS.NMC);     % MOMENTO FLETOR FINAL (TOTAL) NA ESTRUTURA

% Esforço normal
NORMAL.PP=cell(s(1),1,DADOS.NMC);         % <-- EN TOTAL. Apenas peso próprio
NORMAL.PROT=cell(s(1),1,DADOS.NMC);         % <-- EN TOTAL. Apenas sobrecarga atuante na estrutura
NORMAL.NTD=cell(s(1),1,DADOS.NMC);        % <-- EN devido aos efeitos diferidos do concreto
NORMAL.NTempPOS=cell(s(1),1,DADOS.NMC);   % <-- EN devido variação positiva de temperatura
NORMAL.NTempNEG=cell(s(1),1,DADOS.NMC);   % <-- EN devido variação negativa de temperatura
NORMAL.TREMTIPO=cell(s(1),1,DADOS.NMC); 
NORMAL.EMPSOLO=cell(s(1),1,DADOS.NMC);
% NORMAL.TOTAL=cell(s(1),1,DADOS.NMC);      % ESFORÇO NORMAL FINAL (TOTAL) NA ESTRUTURA

% Translação em X ( Referencial Global)
TRANSX.PP=cell(s(1),1,DADOS.NMC);         % <-- Translação em X. Apenas peso próprio
TRANSX.PROT=cell(s(1),1,DADOS.NMC);         % <-- Translação em X. Apenas sobrecarga atuante na estrutura
TRANSX.TD=cell(s(1),1,DADOS.NMC);         % <-- Translação em X devido aos efeitos diferidos do concreto
TRANSX.TempPOS=cell(s(1),1,DADOS.NMC);   % <-- Translação em X devido variação positiva de temperatura
TRANSX.TempNEG=cell(s(1),1,DADOS.NMC);   % <-- Translação em X devido variação negativa de temperatura
TRANSX.TREMTIPO=cell(s(1),1,DADOS.NMC); 
TRANSX.EMPSOLO=cell(s(1),1,DADOS.NMC);
% TRANSX.TOTAL=cell(s(1),1,DADOS.NMC);      % VALOR TOTAL DA TRANSLAÇÃO EM X DE CADA PONTO

% Translação em Z ( Referencial Global)
TRANSZ.PP=cell(s(1),1,DADOS.NMC);         % <-- Translação em Z. Apenas peso próprio
TRANSZ.PROT=cell(s(1),1,DADOS.NMC);         % <-- Translação em Z. Apenas sobrecarga atuante na estrutura
TRANSZ.TD=cell(s(1),1,DADOS.NMC);         % <-- Translação em Z devido aos efeitos diferidos do concreto
TRANSZ.TempPOS=cell(s(1),1,DADOS.NMC);   % <-- Translação em Z devido variação positiva de temperatura
TRANSZ.TempNEG=cell(s(1),1,DADOS.NMC);   % <-- Translação em Z devido variação negativa de temperatura
TRANSZ.TREMTIPO=cell(s(1),1,DADOS.NMC); 
TRANSZ.EMPSOLO=cell(s(1),1,DADOS.NMC);
% TRANSZ.TOTAL=cell(s(1),1,DADOS.NMC);      % VALOR TOTAL DA TRANSLAÇÃO EM Z DE CADA PONTO

% Translação em Z ( Referencial Global)
ROTACAO.PP=cell(s(1),1,DADOS.NMC);         % <-- Rotação. Apenas peso próprio
ROTACAO.PROT=cell(s(1),1,DADOS.NMC);         % <-- Rotação. Apenas sobrecarga atuante na estrutura
ROTACAO.TD=cell(s(1),1,DADOS.NMC);         % <-- Rotação devido aos efeitos diferidos do concreto
ROTACAO.TempPOS=cell(s(1),1,DADOS.NMC);   % <-- Rotação devido variação positiva de temperatura
ROTACAO.TempNEG=cell(s(1),1,DADOS.NMC);   % <-- Rotação devido variação negativa de temperatura
ROTACAO.TREMTIPO=cell(s(1),1,DADOS.NMC); 
ROTACAO.EMPSOLO=cell(s(1),1,DADOS.NMC);
% ROTACAO.TOTAL=cell(s(1),1,DADOS.NMC);      % VALOR TOTAL DA ROTAÇÃO EM CADA PONTO

% Parâmetros econômicos
% SPA_V - Somatório do peso de aço de todas as vigas do pórtico.
% SVC_V - Somatório do volume de concreto de todas as vigas do pórtico
% SForma_V - Somatório da área de forma de toas as vigas do pórtico
% CVA - Custo do aço utilizado em todas as vigas
% CVC - Custo do concreto utilizado em todas as vigas
% CVF - Custo da forma utilizado em todas as vigas
% SPA_P - Somatório do peso de aço de todos os pilares
% SVC_P - Somatório do volume de concreto de todos os pilares
% SForma_P - Somatório da área de forma de todos os pilares
% CPA - Custo de aço dos pilares
% CPC - Custo de concreto dos pilares
% CPF - Custo de forma dos pilares
COST.SPA_V=zeros(1,DADOS.NMC);
COST.SVC_V=zeros(1,DADOS.NMC);
COST.SForma_V=zeros(1,DADOS.NMC);
COST.CVA=zeros(1,DADOS.NMC);
COST.CVC=zeros(1,DADOS.NMC);
COST.CVF=zeros(1,DADOS.NMC);
COST.SPA_P=zeros(1,DADOS.NMC);
COST.SVC_P=zeros(1,DADOS.NMC);
COST.SForma_P=zeros(1,DADOS.NMC);
COST.CPA=zeros(1,DADOS.NMC);
COST.CPC=zeros(1,DADOS.NMC);
COST.CPF=zeros(1,DADOS.NMC);
VPL=zeros(1,DADOS.NMC);