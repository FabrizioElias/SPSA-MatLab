function [OTIM, VIGA, PILAR, DADOS]=OptiVar(DADOS, PORTICO, ELEMENTOS, VIGA, PILAR, ESTRUTURAL)
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
%[VIGA, PILAR, DADOS]=Classifica_elem(DADOS, PORTICO, ELEMENTOS, VIGA, PILAR);

% Criação do vetor com os valores médios (iniciais) das variáveis de
% projeto a serem otimizadas. Esses valores correspondem aos valores médios
% fornecidos na entrada de dados. Nesse caso particular serão otimizados
% apenas a seção transversal dos pilares e do encontro, ou seja, os
% elementos 2, 4, 8 e 9. O vetor "v" corresponde a localização desses
% elementos estrurturais dentro da matriz ESTRUTURAL.D. Essa matriz está
% mal feita (fui eu quem fiz a merda) pois o número do elemento estrutural
% deveria ser correspondente a linha da matriz. Arrume isso depois!!!!!
v=[2 7 8 9];
s=size(v);
s=s(2);
for i=1:s
    OTIM.X0(2*(i-1)+1)=ELEMENTOS.secao(ESTRUTURAL.D(v(i)),1);
    OTIM.X0(2*(i-1)+2)=ELEMENTOS.secao(ESTRUTURAL.D(v(i)),2);
    
end
% OTIM.X0=[VIGA.bvm VIGA.hvm PILAR.hpxm PILAR.hpym];

% % Criação do vetor com o valores mínimos das variáveis de projeto - 12
% % corresponde à largura mínima da viga presquita em norma enquanto 30
% % refere-se à atura mínima da viga.
% XminV=[DADOS.bvmin DADOS.hvmin];
% XminP=[DADOS.bpmin DADOS.hpmin];
% OTIM.Xmin=[XminV XminP];
% 
% % Criação do vetor com o valores máximos das variáveis de projeto 
% XmaxV=[DADOS.bvmax DADOS.hvmax];
% XmaxP=[DADOS.bpmax DADOS.hpmax];
% OTIM.Xmax=[XmaxV XmaxP];
% OTIM.Xinf=OTIM.Xmin';
% OTIM.Xsup=OTIM.Xmax';

%------------GAMBIARRONA - O VETOR OTIM.Xinf e OTIM.xmax FOI FORNECIDO
%ESPECIFICAMENTE PARA ESSE PROBLEMA - PONTE 1 - AASHTO VI.
OTIM.Xmin=[2.40 0.25 2.40 0.25 1.20 0.35 1.20 0.35];
OTIM.Xmax=[2.40 1.00 2.40 1.00 2.40 1.00 2.40 1.00];
OTIM.Xinf=[2.40 0.25 2.40 0.25 1.20 0.35 1.20 0.35];
OTIM.Xsup=[2.40 1.00 2.40 1.00 2.40 1.00 2.40 1.00];


% OTIM.Xmin=[DADOS.bpmin DADOS.hpmin DADOS.bpmin DADOS.hpmin DADOS.bpmin DADOS.hpmin DADOS.bpmin DADOS.hpmin];
% OTIM.Xmax=[DADOS.bpmax DADOS.hpmax DADOS.bpmax DADOS.hpmax DADOS.bpmax DADOS.hpmax DADOS.bpmax DADOS.hpmax];
% OTIM.Xinf=[DADOS.bpmin DADOS.hpmin DADOS.bpmin DADOS.hpmin DADOS.bpmin DADOS.hpmin DADOS.bpmin DADOS.hpmin];
% OTIM.Xsup=[DADOS.bpmax DADOS.hpmax DADOS.bpmax DADOS.hpmax DADOS.bpmax DADOS.hpmax DADOS.bpmax DADOS.hpmax];


