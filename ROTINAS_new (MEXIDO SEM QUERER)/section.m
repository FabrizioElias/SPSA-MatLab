function [ELEMENTOS]=section(H, HH, PORTICO, PAR)
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
% Fun��o ir� escrever na structure PORTICO as dimens�es da se��o
% transversal dos elementos
% -------------------------------------------------------------------------
% Criada      12-fevreiro-2017                 S�RGIO MARQUES
% -------------------------------------------------------------------------

% Armazenamento das propriedades dos elementos de concreto
[CONC, nelemconc]=sectionconc(H);

% Armazenamento das propriedades dos elementos de a�o
[STEEL, nelemsteel]=sectionsteel(HH, PAR);

% Cria��o das matrizes nulas contidas na "structure" ELEMENTO
% ELEMENTOS.Area=zeros(PORTICO.nelem,4);      % <-- �rea da se��o transversal
% ELEMENTOS.Inercia=zeros(PORTICO.nelem,4);   % <-- Momento de in�rcia da se��o transversal
ELEMENTOS.dp=zeros(PORTICO.nelem,3);        % <-- Desvio padr�o da �rea (col. 1), in�rcia (col.2), per�metro (col. 3)
ELEMENTOS.material=zeros(PORTICO.nelem,1);  % <-- Material
ELEMENTOS.E=zeros(PORTICO.nelem,1);         % <-- M�dulo de elasticidade
ELEMENTOS.ro=zeros(PORTICO.nelem,1);        % <-- Peso espec�fico
ELEMENTOS.A=zeros(PORTICO.nelem,1);         % <-- �rea da se��o
ELEMENTOS.I=zeros(PORTICO.nelem,1);         % <-- Momento de in�rcia
ELEMENTOS.u=zeros(PORTICO.nelem,1);         % <-- Per�metro
ELEMENTOS.h=zeros(PORTICO.nelem,1);         % <-- Per�metro efetivo (c�lculo retra��o e flu�ncia)

% Preenchimento dos elementos constitu�dos de concreto armado
for i=1:nelemconc
    ELEMENTOS.A(CONC(i,1),1)=CONC(i,2);
    ELEMENTOS.I(CONC(i,1),1)=CONC(i,3);
    ELEMENTOS.u(CONC(i,1),1)=CONC(i,4);
    ELEMENTOS.dp(CONC(i,1),1)=CONC(i,5);
    ELEMENTOS.dp(CONC(i,1),2)=CONC(i,6);
    ELEMENTOS.dp(CONC(i,1),3)=CONC(i,7);
    ELEMENTOS.material(CONC(i,1),1)=1;
end

% Preenchimento dos elementos constitu�dos de a�o
% Caso o n�o haja elemento de a�o, deve-se, no arquivo de etrada de dados
% informar que o elemento "0" � constitu�do de a�o. Assim a etapa seguinte
% n�o ser� processada.
if STEEL(1)~=0
    for i=1:nelemsteel
        ELEMENTOS.A(STEEL(i,1),1)=STEEL(i,2);
        ELEMENTOS.I(STEEL(i,1),1)=STEEL(i,3);
        ELEMENTOS.dp(STEEL(i,1),1)=STEEL(i,4);
        ELEMENTOS.dp(STEEL(i,1),2)=STEEL(i,5);
        ELEMENTOS.material(STEEL(i,1))=2;
    end    
end

% Armazena a se��o inicial dos elementos estruturais
%ELEMENTOS.secaoINICIAL=ELEMENTOS.secao;
