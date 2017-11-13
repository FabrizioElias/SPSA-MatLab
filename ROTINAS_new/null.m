function [CORTANTE, MOMENTO, NORMAL, TRANSX, TRANSZ, ROTACAO]=null(D)
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
% Rotina paracriar veores nulos que ir�o armazenar os esfor�os internos nos
% elementos do p�rtico
% -------------------------------------------------------------------------
% Criada      13-janeiro-2017                 S�RGIO MARQUES
% -------------------------------------------------------------------------

s=size(D);

% Esfor�o cortante
CORTANTE.PP=cell(s(1),1);       % <-- EC TOTAL. Apenas peso pr�prio
CORTANTE.SC=cell(s(1),1);       % <-- EC TOTAL. Apenas sobrecarga atuante na estrutura
CORTANTE.VTD=cell(s(1),1);      % <-- EC devido aos efeitos diferidos do concreto
CORTANTE.VTempPOS=cell(s(1),1); % <-- EC devido varia��o positiva de temperatura
CORTANTE.VTempNEG=cell(s(1),1); % <-- EC devido varia��o negativa de temperatura
CORTANTE.TOTAL=cell(s(1),1);    % ESFOR�O CORTANTE FINAL (TOTAL) NA ESTRUTURA

% Momento fletor
MOMENTO.PP=cell(s(1),1);        % <-- MF TOTAL. Apenas peso pr�prio
MOMENTO.SC=cell(s(1),1);        % <-- MF TOTAL. Apenas sobrecarga atuante na estrutura
MOMENTO.MTD=cell(s(1),1);       % <-- MF devido aos efeitos diferidos do concreto
MOMENTO.MTempPOS=cell(s(1),1);  % <-- MF devido varia��o positiva de temperatura
MOMENTO.MTempNEG=cell(s(1),1);  % <-- MF devido varia��o negativa de temperatura
MOMENTO.TOTAL=cell(s(1),1);     % MOMENTO FLETOR FINAL (TOTAL) NA ESTRUTURA

% Esfor�o normal
NORMAL.PP=cell(s(1),1);         % <-- EN TOTAL. Apenas peso pr�prio
NORMAL.SC=cell(s(1),1);         % <-- EN TOTAL. Apenas sobrecarga atuante na estrutura
NORMAL.NTD=cell(s(1),1);        % <-- EN devido aos efeitos diferidos do concreto
NORMAL.NTempPOS=cell(s(1),1);   % <-- EN devido varia��o positiva de temperatura
NORMAL.NTempNEG=cell(s(1),1);   % <-- EN devido varia��o negativa de temperatura
NORMAL.TOTAL=cell(s(1),1);      % ESFOR�O NORMAL FINAL (TOTAL) NA ESTRUTURA

% Transla��o em X ( Referencial Global)
TRANSX.PP=cell(s(1),1);         % <-- Transla��o em X. Apenas peso pr�prio
TRANSX.SC=cell(s(1),1);         % <-- Transla��o em X. Apenas sobrecarga atuante na estrutura
TRANSX.TD=cell(s(1),1);         % <-- Transla��o em X devido aos efeitos diferidos do concreto
TRANSX.TempPOS=cell(s(1),1);   % <-- Transla��o em X devido varia��o positiva de temperatura
TRANSX.TempNEG=cell(s(1),1);   % <-- Transla��o em X devido varia��o negativa de temperatura
TRANSX.TOTAL=cell(s(1),1);      % VALOR TOTAL DA TRANSLA��O EM X DE CADA PONTO

% Transla��o em Z ( Referencial Global)
TRANSZ.PP=cell(s(1),1);         % <-- Transla��o em Z. Apenas peso pr�prio
TRANSZ.SC=cell(s(1),1);         % <-- Transla��o em Z. Apenas sobrecarga atuante na estrutura
TRANSZ.TD=cell(s(1),1);         % <-- Transla��o em Z devido aos efeitos diferidos do concreto
TRANSZ.TempPOS=cell(s(1),1);   % <-- Transla��o em Z devido varia��o positiva de temperatura
TRANSZ.TempNEG=cell(s(1),1);   % <-- Transla��o em Z devido varia��o negativa de temperatura
TRANSZ.TOTAL=cell(s(1),1);      % VALOR TOTAL DA TRANSLA��O EM Z DE CADA PONTO

% Transla��o em Z ( Referencial Global)
ROTACAO.PP=cell(s(1),1);         % <-- Rota��o. Apenas peso pr�prio
ROTACAO.SC=cell(s(1),1);         % <-- Rota��o. Apenas sobrecarga atuante na estrutura
ROTACAO.TD=cell(s(1),1);         % <-- Rota��o devido aos efeitos diferidos do concreto
ROTACAO.TempPOS=cell(s(1),1);   % <-- Rota��o devido varia��o positiva de temperatura
ROTACAO.TempNEG=cell(s(1),1);   % <-- Rota��o devido varia��o negativa de temperatura
ROTACAO.TOTAL=cell(s(1),1);      % VALOR TOTAL DA ROTA��O EM CADA PONTO
