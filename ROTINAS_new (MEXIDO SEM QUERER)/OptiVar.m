function [OTIM, VIGA, PILAR, DADOS]=OptiVar(DADOS, PORTICO, ELEMENTOS, VIGA, PILAR)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIENCIAS
% PROGRAMA DE POS-GRADUACAO EM ENGENHARIA CIVIL        - AREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELECAO DE  MEDIA FIDELIDADE  PARA  ANALISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO
% ALUNO       S�rgio Jos� Priori Jovino Marques Filho
% ORIENTADOR  Prof. Ezio da Rocha Araujo
% -------------------------------------------------------------------------
% DESCRICAO
% Nessa rotina ser�o geradas as vari�veis a serem utilizadas no otimizador
% -------------------------------------------------------------------------
% Criada      27-julho-2016                 S�RGIO MARQUES
% -------------------------------------------------------------------------

% Classifica��o dos elementos do p�rtico - classifica os elementos em vigas
% e pilares.
[VIGA, PILAR, DADOS]=Classifica_elem(DADOS, PORTICO, ELEMENTOS, VIGA, PILAR);

% Cria��o do vetor com os valores m�dios (iniciais) das vari�veis de
% projeto a serem otimizadas. Esses valores correspondem aos valores m�dios
% fornecidos na entrada de dados.
OTIM.X0=[VIGA.bvm VIGA.hvm PILAR.hpxm PILAR.hpym];

% Cria��o do vetor com o valores m�nimos das vari�veis de projeto - 12
% corresponde � largura m�nima da viga presquita em norma enquanto 30
% refere-se � atura m�nima da viga.
XminV=[DADOS.bvmin*ones(1,DADOS.Nvigas) DADOS.hvmin*ones(1,DADOS.Nvigas)];
XminP=[DADOS.bpmin*ones(1,DADOS.Npilares) DADOS.hpmin*ones(1,DADOS.Npilares)];
OTIM.Xmin=[XminV XminP];

% Cria��o do vetor com o valores m�ximos das vari�veis de projeto 
XmaxV=[30*ones(1,DADOS.Nvigas) 90*ones(1,DADOS.Nvigas)];
XmaxP=[100*ones(1,DADOS.Npilares) 100*ones(1,DADOS.Npilares)];
OTIM.Xmax=[XmaxV XmaxP];

OTIM.Xinf=OTIM.Xmin';
OTIM.Xsup=OTIM.Xmax';


