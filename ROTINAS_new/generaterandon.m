function [RANDON]=generaterandon(DADOS)
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
% Rotina criada para gerar vetores de n�metos rand�micos segundo cada
% ditribui��o de probabilidade especifiada no manual do JCSS
% -------------------------------------------------------------------------
% Criada      24-maio-2016                 S�RGIO MARQUES
% -------------------------------------------------------------------------

% Distribui��o normal - identificador==1
randn('state',100);
RANDON.normal=randn(1,DADOS.NMC);

% Distribui��o gama - identificador==2
% As vari�veis a e b s�o especificadas em ParEst1 e ParEst do cart�o de
% entrada
RANDON.gamma=gamrnd(a,b,1,DADOS.NMC);

% Distribui��o exponencial - identificador==3
% mi - m�dia da ditribui��o exponencial - ParEst1
% NMC - n�mero de Monte Carlos, informa quantos valores ser�o gerados
RANDON.exp=exprnd(mu,1,DADOS.NMC);

% Distribui��o de Weibull - identificador==4
% As vari�veis a e b s�o especificadas em ParEst1 e ParEst do cart�o de
% entrada
RANDON.weibull=wblrnd(a,b,1,DADOS.NMC);

% Distribui��o de Gumbel - identificador==5
% As vari�veis mi e sigma s�o especificadas em ParEst1 e ParEst do cart�o de
% entrada
RANDON.gumbel=evrnd(mi,sigma,1,DADOS.NMC);

% Distribui��o lognormal - identificador==6
% As vari�veis mi e sigma s�o especificadas em ParEst1 e ParEst do cart�o de
% entrada
RANDON.lonormal=lgnrnd((mi,sigma,1,DADOS.NMC);



