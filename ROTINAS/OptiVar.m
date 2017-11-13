%FAB - Otimiza��o da assinatura do m�todo.
%function [OTIM, VIGA, PILAR, DADOS]=OptiVar(DADOS, PORTICO, ELEMENTOS, VIGA, PILAR, ESTRUTURAL)
function [OTIM, DADOS]=OptiVar(DADOS, ELEMENTOS, ESTRUTURAL)
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
%[VIGA, PILAR, DADOS]=Classifica_elem(DADOS, PORTICO, ELEMENTOS, VIGA, PILAR);

% Cria��o do vetor com os valores m�dios (iniciais) das vari�veis de
% projeto a serem otimizadas. Esses valores correspondem aos valores m�dios
% fornecidos na entrada de dados.
s=size(ESTRUTURAL.D);
s=s(1);
for i=1:s
    OTIM.X0(2*(i-1)+1)=ELEMENTOS.secao(ESTRUTURAL.D(i,1),1);
    OTIM.X0(2*(i-1)+2)=ELEMENTOS.secao(ESTRUTURAL.D(i,1),2);
    
end
% OTIM.X0=[VIGA.bvm VIGA.hvm PILAR.hpxm PILAR.hpym];

% % Cria��o do vetor com o valores m�nimos das vari�veis de projeto - 12
% % corresponde � largura m�nima da viga presquita em norma enquanto 30
% % refere-se � atura m�nima da viga.
% XminV=[DADOS.bvmin DADOS.hvmin];
% XminP=[DADOS.bpmin DADOS.hpmin];
% OTIM.Xmin=[XminV XminP];
% 
% % Cria��o do vetor com o valores m�ximos das vari�veis de projeto 
% XmaxV=[DADOS.bvmax DADOS.hvmax];
% XmaxP=[DADOS.bpmax DADOS.hpmax];
% OTIM.Xmax=[XmaxV XmaxP];
% OTIM.Xinf=OTIM.Xmin';
% OTIM.Xsup=OTIM.Xmax';

%------------GAMBIARRONA - O VETOR OTIM.Xinf e OTIM.xmax FOI FORNECIDO
%ESPECIFICAMENTE PARA ESSE PROBLEMA - P�RTICO DE TR�S BARRAS.
OTIM.Xmin=[DADOS.bpmin DADOS.hpmin DADOS.bvmin DADOS.hvmin];
OTIM.Xmax=[DADOS.bpmax DADOS.hpmax DADOS.bvmax DADOS.hvmax];
OTIM.Xinf=[DADOS.bpmin DADOS.hpmin DADOS.bvmin DADOS.hvmin DADOS.bpmin DADOS.hpmin];
OTIM.Xsup=[DADOS.bpmax DADOS.hpmax DADOS.bvmax DADOS.hvmax DADOS.bpmax DADOS.hpmax];


