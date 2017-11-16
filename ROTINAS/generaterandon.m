function [RANDOM]=generaterandon(DADOS)
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
%FAB - troca de randn por RNG, mais recomend�vel.
%randn('state',100);
%FAB - A fun��o abaixo reproduz EXATAMENTE o comportamento do gerador
%legacy v5 (que ser� removido no futuro), mas n�o � recomendado.
%rng(100, 'v5normal');
%FAB - Utiliza��o da fun��o rng com seed 100, para gera��es de n�meros rand�micos.
%rng(100);
%FAB - Ao remover o rng(100) acima, � garantido que a valida��o do c�digo
%funcione, pois o �nico controle de gera��o dos n�meros aleat�rios est�
%agora na fun��o principal.
RANDOM.normal=randn(1,DADOS.NMC);

%FAB - ATEN��O! Todas as vari�veis a, b, mi e sigma abaixo foram
%substitu�das por 1 e 10, pois n�o existe no DADOS.in os par�metros
%mencionados ParEstl e ParEst.

%FAB - Remo��o tempor�ria da gera��o desses n�meros a fim de execu��o mais
%r�pida.

% Distribui��o gama - identificador==2
% As vari�veis a e b s�o especificadas em ParEst1 e ParEst do cart�o de
% entrada
%RANDOM.gamma=gamrnd(a,b,1,DADOS.NMC);
%RANDOM.gamma=gamrnd(1,10,1,DADOS.NMC);

% Distribui��o exponencial - identificador==3
% mi - m�dia da ditribui��o exponencial - ParEst1
% NMC - n�mero de Monte Carlos, informa quantos valores ser�o gerados
%RANDOM.exp=exprnd(mu,1,DADOS.NMC);
%RANDOM.exp=exprnd(1,1,DADOS.NMC);

% Distribui��o de Weibull - identificador==4
% As vari�veis a e b s�o especificadas em ParEst1 e ParEst do cart�o de
% entrada
%RANDOM.weibull=wblrnd(a,b,1,DADOS.NMC);
%RANDOM.weibull=wblrnd(1,10,1,DADOS.NMC);

% Distribui��o de Gumbel - identificador==5
% As vari�veis mi e sigma s�o especificadas em ParEst1 e ParEst do cart�o de
% entrada
%RANDOM.gumbel=evrnd(mi,sigma,1,DADOS.NMC);
%RANDOM.gumbel=evrnd(1,10,1,DADOS.NMC);

% Distribui��o lognormal - identificador==6
% As vari�veis mi e sigma s�o especificadas em ParEst1 e ParEst do cart�o de
% entrada
%RANDOM.lonormal=lgnrnd(mi,sigma,1,DADOS.NMC);
%RANDOM.lonormal=lognrnd(1,2,1,DADOS.NMC);



