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
[STEEL, nelemsteel]=sectionsteel(HH);

% Cria��o das matrizes nulas contidas na "structure" ELEMENTO
ELEMENTOS.secao=zeros(PORTICO.nelem,4);     % <-- Se��o transversal
ELEMENTOS.cov=zeros(PORTICO.nelem,4);        % <-- Desvio Padr�o
ELEMENTOS.elem=zeros(PORTICO.nelem,1);      % <-- Discretiza��o
ELEMENTOS.material=zeros(PORTICO.nelem,1);  % <-- Material
ELEMENTOS.E=zeros(PORTICO.nelem,1);         % <-- M�dulo de elasticidade
ELEMENTOS.ro=zeros(PORTICO.nelem,1);        % <-- Peso espec�fico
ELEMENTOS.A=zeros(PORTICO.nelem,1);         % <-- �rea da se��o
ELEMENTOS.I=zeros(PORTICO.nelem,1);         % <-- Momento de in�rcia
ELEMENTOS.u=zeros(PORTICO.nelem,1);         % <-- Per�metro real
ELEMENTOS.h=zeros(PORTICO.nelem,1);         % <-- Per�metro efetivo (c�lculo retra��o e flu�ncia)

% Preenchimento dos elementos constitu�dos de concreto armado
for i=1:nelemconc
    ELEMENTOS.secao(CONC(i,1),1)=CONC(i,2);
    ELEMENTOS.secao(CONC(i,1),2)=CONC(i,3);
    ELEMENTOS.cov(CONC(i,1),1)=CONC(i,4);
    ELEMENTOS.cov(CONC(i,1),2)=CONC(i,5);
    ELEMENTOS.elem(CONC(i,1),1)=CONC(i,6);
    ELEMENTOS.material(CONC(i,1),1)=1;
end

% Preenchimento dos elementos constitu�dos de a�o
% Caso o n�o haja elemento de a�o, deve-se, no arquivo de etrada de dados
% informar que o elemento "0" � constitu�do de a�o. Assim a etapa seguinte
% n�o ser� processada.
if STEEL(1)~=0
    for i=1:nelemsteel
        ELEMENTOS.secao(STEEL(i,1),1)=STEEL(i,2);
        ELEMENTOS.secao(STEEL(i,1),2)=STEEL(i,3);
        ELEMENTOS.secao(STEEL(i,1),3)=STEEL(i,4);
        ELEMENTOS.secao(STEEL(i,1),4)=STEEL(i,5);
        ELEMENTOS.cov(STEEL(i,1),1)=STEEL(i,6);
        ELEMENTOS.cov(STEEL(i,1),2)=STEEL(i,6);
        ELEMENTOS.cov(STEEL(i,1),3)=STEEL(i,6);
        ELEMENTOS.cov(STEEL(i,1),4)=STEEL(i,6);
        ELEMENTOS.elem(STEEL(i,1))=STEEL(i,7);
        ELEMENTOS.material(STEEL(i,1))=2;
    end    
end

ELEMENTOS.dp=ELEMENTOS.cov.*ELEMENTOS.secao;

% C�LCULO DAS PROPRIEDADES GEOM�TRICAS DA SE��O.
% Cada elemento estrutural ter� suas propriedades geom�tricas calculadas de
% forma "personalizada".
% Elementos 1 e 3 - Estacas met�licas, eixo de menor inercia perpendicular
% � via
% Elementos 2 e 4 - Encontro, se��o retangular
% Elementos 5, 6 e 7 - Viga, se��o retangular fict�cia. As dimens�es da
% se��o retangular foram calculadas de forma a reproduzir o mesmo valor da
% �rea e momento de in�rcia de uma viga pr�-fabricada padr�o AASHTO VI
% Elementos 8 e 9 - Pilar, se��o retangular de concreto

for i=1:(nelemconc+nelemsteel)
    if PORTICO.elemestrutural(i)==1 || PORTICO.elemestrutural(i)==3
        ELEMENTOS.A(i)=2*(ELEMENTOS.secao(i,3)*ELEMENTOS.secao(i,4))+ELEMENTOS.secao(i,1)*(ELEMENTOS.secao(i,2)-2*ELEMENTOS.secao(i,4));
        ELEMENTOS.I(i)=2*(ELEMENTOS.secao(i,4)*ELEMENTOS.secao(i,3)^3/12)+(ELEMENTOS.secao(i,2)-2*ELEMENTOS.secao(i,4))*ELEMENTOS.secao(i,1)^3/12;
        % N�o calcula per�metro efetivo, n�o usa para nada
    elseif PORTICO.elemestrutural(i)==2 || PORTICO.elemestrutural(i)==4
        ELEMENTOS.A(i)=ELEMENTOS.secao(i,1)*ELEMENTOS.secao(i,2);
        ELEMENTOS.I(i)=ELEMENTOS.secao(i,1)*ELEMENTOS.secao(i,2)^3/12;
        % N�o calcula per�metro  efetivo, n�o usa para nada
    elseif PORTICO.elemestrutural(i)==5 || PORTICO.elemestrutural(i)==6 || PORTICO.elemestrutural(i)==7
        ELEMENTOS.A(i)=ELEMENTOS.secao(i,1)*ELEMENTOS.secao(i,2);
        ELEMENTOS.I(i)=ELEMENTOS.secao(i,1)*ELEMENTOS.secao(i,2)^3/12;
        ELEMENTOS.u(i)=9.37; % Dimens�o em mil�metro
    elseif PORTICO.elemestrutural(i)==8 || PORTICO.elemestrutural(i)==9
        ELEMENTOS.A(i)=ELEMENTOS.secao(i,1)*ELEMENTOS.secao(i,2);
        ELEMENTOS.I(i)=ELEMENTOS.secao(i,1)*ELEMENTOS.secao(i,2)^3/12;
        % N�o calcula per�metro  efetivo, n�o usa para nada
    end
end