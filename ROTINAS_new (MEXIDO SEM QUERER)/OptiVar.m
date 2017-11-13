function [OTIM, VIGA, PILAR, DADOS]=OptiVar(DADOS, PORTICO, ELEMENTOS, VIGA, PILAR)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIENCIAS
% PROGRAMA DE POS-GRADUACAO EM ENGENHARIA CIVIL        - AREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELECAO DE  MEDIA FIDELIDADE  PARA  ANALISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO
% ALUNO       Sérgio José Priori Jovino Marques Filho
% ORIENTADOR  Prof. Ezio da Rocha Araujo
% -------------------------------------------------------------------------
% DESCRICAO
% Nessa rotina serão geradas as variáveis a serem utilizadas no otimizador
% -------------------------------------------------------------------------
% Criada      27-julho-2016                 SÉRGIO MARQUES
% -------------------------------------------------------------------------

% Classificação dos elementos do pórtico - classifica os elementos em vigas
% e pilares.
[VIGA, PILAR, DADOS]=Classifica_elem(DADOS, PORTICO, ELEMENTOS, VIGA, PILAR);

% Criação do vetor com os valores médios (iniciais) das variáveis de
% projeto a serem otimizadas. Esses valores correspondem aos valores médios
% fornecidos na entrada de dados.
OTIM.X0=[VIGA.bvm VIGA.hvm PILAR.hpxm PILAR.hpym];

% Criação do vetor com o valores mínimos das variáveis de projeto - 12
% corresponde à largura mínima da viga presquita em norma enquanto 30
% refere-se à atura mínima da viga.
XminV=[DADOS.bvmin*ones(1,DADOS.Nvigas) DADOS.hvmin*ones(1,DADOS.Nvigas)];
XminP=[DADOS.bpmin*ones(1,DADOS.Npilares) DADOS.hpmin*ones(1,DADOS.Npilares)];
OTIM.Xmin=[XminV XminP];

% Criação do vetor com o valores máximos das variáveis de projeto 
XmaxV=[30*ones(1,DADOS.Nvigas) 90*ones(1,DADOS.Nvigas)];
XmaxP=[100*ones(1,DADOS.Npilares) 100*ones(1,DADOS.Npilares)];
OTIM.Xmax=[XmaxV XmaxP];

OTIM.Xinf=OTIM.Xmin';
OTIM.Xsup=OTIM.Xmax';


