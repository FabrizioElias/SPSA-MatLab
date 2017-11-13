function [CORTANTE, MOMENTO, NORMAL, TRANSX, TRANSZ, ROTACAO, COST, VPL]=null(D, DADOS)
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
CORTANTE.PP=cell(s(1),1,DADOS.NMC);       % <-- EC TOTAL. Apenas peso pr�prio
CORTANTE.PROT=cell(s(1),1,DADOS.NMC);       % <-- EC TOTAL. Apenas sobrecarga atuante na estrutura
CORTANTE.VTD=cell(s(1),1,DADOS.NMC);      % <-- EC devido aos efeitos diferidos do concreto
CORTANTE.VTempPOS=cell(s(1),1,DADOS.NMC); % <-- EC devido varia��o positiva de temperatura
CORTANTE.VTempNEG=cell(s(1),1,DADOS.NMC); % <-- EC devido varia��o negativa de temperatura
CORTANTE.TREMTIPO=cell(s(1),1,DADOS.NMC); 
CORTANTE.EMPSOLO=cell(s(1),1,DADOS.NMC);
% CORTANTE.TOTAL=cell(s(1),1,DADOS.NMC);    % ESFOR�O CORTANTE FINAL (TOTAL) NA ESTRUTURA

% Momento fletor
MOMENTO.PP=cell(s(1),1,DADOS.NMC);        % <-- MF TOTAL. Apenas peso pr�prio
MOMENTO.PROT=cell(s(1),1,DADOS.NMC);        % <-- MF TOTAL. Apenas sobrecarga atuante na estrutura
MOMENTO.MTD=cell(s(1),1,DADOS.NMC);       % <-- MF devido aos efeitos diferidos do concreto
MOMENTO.MTempPOS=cell(s(1),1,DADOS.NMC);  % <-- MF devido varia��o positiva de temperatura
MOMENTO.MTempNEG=cell(s(1),1,DADOS.NMC);  % <-- MF devido varia��o negativa de temperatura
MOMENTO.TREMTIPO=cell(s(1),1,DADOS.NMC); 
MOMENTO.EMPSOLO=cell(s(1),1,DADOS.NMC);
% MOMENTO.TOTAL=cell(s(1),1,DADOS.NMC);     % MOMENTO FLETOR FINAL (TOTAL) NA ESTRUTURA

% Esfor�o normal
NORMAL.PP=cell(s(1),1,DADOS.NMC);         % <-- EN TOTAL. Apenas peso pr�prio
NORMAL.PROT=cell(s(1),1,DADOS.NMC);         % <-- EN TOTAL. Apenas sobrecarga atuante na estrutura
NORMAL.NTD=cell(s(1),1,DADOS.NMC);        % <-- EN devido aos efeitos diferidos do concreto
NORMAL.NTempPOS=cell(s(1),1,DADOS.NMC);   % <-- EN devido varia��o positiva de temperatura
NORMAL.NTempNEG=cell(s(1),1,DADOS.NMC);   % <-- EN devido varia��o negativa de temperatura
NORMAL.TREMTIPO=cell(s(1),1,DADOS.NMC); 
NORMAL.EMPSOLO=cell(s(1),1,DADOS.NMC);
% NORMAL.TOTAL=cell(s(1),1,DADOS.NMC);      % ESFOR�O NORMAL FINAL (TOTAL) NA ESTRUTURA

% Transla��o em X ( Referencial Global)
TRANSX.PP=cell(s(1),1,DADOS.NMC);         % <-- Transla��o em X. Apenas peso pr�prio
TRANSX.PROT=cell(s(1),1,DADOS.NMC);         % <-- Transla��o em X. Apenas sobrecarga atuante na estrutura
TRANSX.TD=cell(s(1),1,DADOS.NMC);         % <-- Transla��o em X devido aos efeitos diferidos do concreto
TRANSX.TempPOS=cell(s(1),1,DADOS.NMC);   % <-- Transla��o em X devido varia��o positiva de temperatura
TRANSX.TempNEG=cell(s(1),1,DADOS.NMC);   % <-- Transla��o em X devido varia��o negativa de temperatura
TRANSX.TREMTIPO=cell(s(1),1,DADOS.NMC); 
TRANSX.EMPSOLO=cell(s(1),1,DADOS.NMC);
% TRANSX.TOTAL=cell(s(1),1,DADOS.NMC);      % VALOR TOTAL DA TRANSLA��O EM X DE CADA PONTO

% Transla��o em Z ( Referencial Global)
TRANSZ.PP=cell(s(1),1,DADOS.NMC);         % <-- Transla��o em Z. Apenas peso pr�prio
TRANSZ.PROT=cell(s(1),1,DADOS.NMC);         % <-- Transla��o em Z. Apenas sobrecarga atuante na estrutura
TRANSZ.TD=cell(s(1),1,DADOS.NMC);         % <-- Transla��o em Z devido aos efeitos diferidos do concreto
TRANSZ.TempPOS=cell(s(1),1,DADOS.NMC);   % <-- Transla��o em Z devido varia��o positiva de temperatura
TRANSZ.TempNEG=cell(s(1),1,DADOS.NMC);   % <-- Transla��o em Z devido varia��o negativa de temperatura
TRANSZ.TREMTIPO=cell(s(1),1,DADOS.NMC); 
TRANSZ.EMPSOLO=cell(s(1),1,DADOS.NMC);
% TRANSZ.TOTAL=cell(s(1),1,DADOS.NMC);      % VALOR TOTAL DA TRANSLA��O EM Z DE CADA PONTO

% Transla��o em Z ( Referencial Global)
ROTACAO.PP=cell(s(1),1,DADOS.NMC);         % <-- Rota��o. Apenas peso pr�prio
ROTACAO.PROT=cell(s(1),1,DADOS.NMC);         % <-- Rota��o. Apenas sobrecarga atuante na estrutura
ROTACAO.TD=cell(s(1),1,DADOS.NMC);         % <-- Rota��o devido aos efeitos diferidos do concreto
ROTACAO.TempPOS=cell(s(1),1,DADOS.NMC);   % <-- Rota��o devido varia��o positiva de temperatura
ROTACAO.TempNEG=cell(s(1),1,DADOS.NMC);   % <-- Rota��o devido varia��o negativa de temperatura
ROTACAO.TREMTIPO=cell(s(1),1,DADOS.NMC); 
ROTACAO.EMPSOLO=cell(s(1),1,DADOS.NMC);
% ROTACAO.TOTAL=cell(s(1),1,DADOS.NMC);      % VALOR TOTAL DA ROTA��O EM CADA PONTO

% Par�metros econ�micos
% SPA_V - Somat�rio do peso de a�o de todas as vigas do p�rtico.
% SVC_V - Somat�rio do volume de concreto de todas as vigas do p�rtico
% SForma_V - Somat�rio da �rea de forma de toas as vigas do p�rtico
% CVA - Custo do a�o utilizado em todas as vigas
% CVC - Custo do concreto utilizado em todas as vigas
% CVF - Custo da forma utilizado em todas as vigas
% SPA_P - Somat�rio do peso de a�o de todos os pilares
% SVC_P - Somat�rio do volume de concreto de todos os pilares
% SForma_P - Somat�rio da �rea de forma de todos os pilares
% CPA - Custo de a�o dos pilares
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