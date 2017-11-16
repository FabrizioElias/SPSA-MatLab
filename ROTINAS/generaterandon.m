function [RANDOM]=generaterandon(DADOS)
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
%FAB - troca de randn por RNG, mais recomendável.
%randn('state',100);
%FAB - A função abaixo reproduz EXATAMENTE o comportamento do gerador
%legacy v5 (que será removido no futuro), mas não é recomendado.
%rng(100, 'v5normal');
%FAB - Utilização da função rng com seed 100, para gerações de números randômicos.
%rng(100);
%FAB - Ao remover o rng(100) acima, é garantido que a validação do código
%funcione, pois o único controle de geração dos números aleatórios está
%agora na função principal.
RANDOM.normal=randn(1,DADOS.NMC);

%FAB - ATENÇÃO! Todas as variáveis a, b, mi e sigma abaixo foram
%substituídas por 1 e 10, pois não existe no DADOS.in os parâmetros
%mencionados ParEstl e ParEst.

%FAB - Remoção temporária da geração desses números a fim de execução mais
%rápida.

% Distribuição gama - identificador==2
% As variáveis a e b são especificadas em ParEst1 e ParEst do cartão de
% entrada
%RANDOM.gamma=gamrnd(a,b,1,DADOS.NMC);
%RANDOM.gamma=gamrnd(1,10,1,DADOS.NMC);

% Distribuição exponencial - identificador==3
% mi - média da ditribuição exponencial - ParEst1
% NMC - número de Monte Carlos, informa quantos valores serão gerados
%RANDOM.exp=exprnd(mu,1,DADOS.NMC);
%RANDOM.exp=exprnd(1,1,DADOS.NMC);

% Distribuição de Weibull - identificador==4
% As variáveis a e b são especificadas em ParEst1 e ParEst do cartão de
% entrada
%RANDOM.weibull=wblrnd(a,b,1,DADOS.NMC);
%RANDOM.weibull=wblrnd(1,10,1,DADOS.NMC);

% Distribuição de Gumbel - identificador==5
% As variáveis mi e sigma são especificadas em ParEst1 e ParEst do cartão de
% entrada
%RANDOM.gumbel=evrnd(mi,sigma,1,DADOS.NMC);
%RANDOM.gumbel=evrnd(1,10,1,DADOS.NMC);

% Distribuição lognormal - identificador==6
% As variáveis mi e sigma são especificadas em ParEst1 e ParEst do cartão de
% entrada
%RANDOM.lonormal=lgnrnd(mi,sigma,1,DADOS.NMC);
%RANDOM.lonormal=lognrnd(1,2,1,DADOS.NMC);



