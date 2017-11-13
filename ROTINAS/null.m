function [CORTANTE, MOMENTO, NORMAL, TRANSX, TRANSZ, ROTACAO]=null(D)
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
CORTANTE.PP=cell(s(1),1);       % <-- EC TOTAL. Apenas peso próprio
CORTANTE.SC=cell(s(1),1);       % <-- EC TOTAL. Apenas sobrecarga atuante na estrutura
CORTANTE.VTD=cell(s(1),1);      % <-- EC devido aos efeitos diferidos do concreto
CORTANTE.VTempPOS=cell(s(1),1); % <-- EC devido variação positiva de temperatura
CORTANTE.VTempNEG=cell(s(1),1); % <-- EC devido variação negativa de temperatura
CORTANTE.TOTAL=cell(s(1),1);    % ESFORÇO CORTANTE FINAL (TOTAL) NA ESTRUTURA

% Momento fletor
MOMENTO.PP=cell(s(1),1);        % <-- MF TOTAL. Apenas peso próprio
MOMENTO.SC=cell(s(1),1);        % <-- MF TOTAL. Apenas sobrecarga atuante na estrutura
MOMENTO.MTD=cell(s(1),1);       % <-- MF devido aos efeitos diferidos do concreto
MOMENTO.MTempPOS=cell(s(1),1);  % <-- MF devido variação positiva de temperatura
MOMENTO.MTempNEG=cell(s(1),1);  % <-- MF devido variação negativa de temperatura
MOMENTO.TOTAL=cell(s(1),1);     % MOMENTO FLETOR FINAL (TOTAL) NA ESTRUTURA

% Esforço normal
NORMAL.PP=cell(s(1),1);         % <-- EN TOTAL. Apenas peso próprio
NORMAL.SC=cell(s(1),1);         % <-- EN TOTAL. Apenas sobrecarga atuante na estrutura
NORMAL.NTD=cell(s(1),1);        % <-- EN devido aos efeitos diferidos do concreto
NORMAL.NTempPOS=cell(s(1),1);   % <-- EN devido variação positiva de temperatura
NORMAL.NTempNEG=cell(s(1),1);   % <-- EN devido variação negativa de temperatura
NORMAL.TOTAL=cell(s(1),1);      % ESFORÇO NORMAL FINAL (TOTAL) NA ESTRUTURA

% Translação em X ( Referencial Global)
TRANSX.PP=cell(s(1),1);         % <-- Translação em X. Apenas peso próprio
TRANSX.SC=cell(s(1),1);         % <-- Translação em X. Apenas sobrecarga atuante na estrutura
TRANSX.TD=cell(s(1),1);         % <-- Translação em X devido aos efeitos diferidos do concreto
TRANSX.TempPOS=cell(s(1),1);   % <-- Translação em X devido variação positiva de temperatura
TRANSX.TempNEG=cell(s(1),1);   % <-- Translação em X devido variação negativa de temperatura
TRANSX.TOTAL=cell(s(1),1);      % VALOR TOTAL DA TRANSLAÇÃO EM X DE CADA PONTO

% Translação em Z ( Referencial Global)
TRANSZ.PP=cell(s(1),1);         % <-- Translação em Z. Apenas peso próprio
TRANSZ.SC=cell(s(1),1);         % <-- Translação em Z. Apenas sobrecarga atuante na estrutura
TRANSZ.TD=cell(s(1),1);         % <-- Translação em Z devido aos efeitos diferidos do concreto
TRANSZ.TempPOS=cell(s(1),1);   % <-- Translação em Z devido variação positiva de temperatura
TRANSZ.TempNEG=cell(s(1),1);   % <-- Translação em Z devido variação negativa de temperatura
TRANSZ.TOTAL=cell(s(1),1);      % VALOR TOTAL DA TRANSLAÇÃO EM Z DE CADA PONTO

% Translação em Z ( Referencial Global)
ROTACAO.PP=cell(s(1),1);         % <-- Rotação. Apenas peso próprio
ROTACAO.SC=cell(s(1),1);         % <-- Rotação. Apenas sobrecarga atuante na estrutura
ROTACAO.TD=cell(s(1),1);         % <-- Rotação devido aos efeitos diferidos do concreto
ROTACAO.TempPOS=cell(s(1),1);   % <-- Rotação devido variação positiva de temperatura
ROTACAO.TempNEG=cell(s(1),1);   % <-- Rotação devido variação negativa de temperatura
ROTACAO.TOTAL=cell(s(1),1);      % VALOR TOTAL DA ROTAÇÃO EM CADA PONTO
