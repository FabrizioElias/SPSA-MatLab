function [RANDON]=generaterandon(DADOS)
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
% Rotina criada para gerar vetores de númetos randômicos segundo cada
% ditribuição de probabilidade especifiada no manual do JCSS
% -------------------------------------------------------------------------
% Criada      24-maio-2016                 SÉRGIO MARQUES
% -------------------------------------------------------------------------

% Distribuição normal - identificador==1
randn('state',100);
RANDON.normal=randn(1,DADOS.NMC);

% Distribuição gama - identificador==2
% As variáveis a e b são especificadas em ParEst1 e ParEst do cartão de
% entrada
RANDON.gamma=gamrnd(a,b,1,DADOS.NMC);

% Distribuição exponencial - identificador==3
% mi - média da ditribuição exponencial - ParEst1
% NMC - número de Monte Carlos, informa quantos valores serão gerados
RANDON.exp=exprnd(mu,1,DADOS.NMC);

% Distribuição de Weibull - identificador==4
% As variáveis a e b são especificadas em ParEst1 e ParEst do cartão de
% entrada
RANDON.weibull=wblrnd(a,b,1,DADOS.NMC);

% Distribuição de Gumbel - identificador==5
% As variáveis mi e sigma são especificadas em ParEst1 e ParEst do cartão de
% entrada
RANDON.gumbel=evrnd(mi,sigma,1,DADOS.NMC);

% Distribuição lognormal - identificador==6
% As variáveis mi e sigma são especificadas em ParEst1 e ParEst do cartão de
% entrada
RANDON.lonormal=lgnrnd((mi,sigma,1,DADOS.NMC);



