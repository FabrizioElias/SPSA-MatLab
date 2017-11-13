function [ELEMENTOS]=section(H, HH, PORTICO, PAR)
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
% Função irá escrever na structure PORTICO as dimensões da seção
% transversal dos elementos
% -------------------------------------------------------------------------
% Criada      12-fevreiro-2017                 SÉRGIO MARQUES
% -------------------------------------------------------------------------

% Armazenamento das propriedades dos elementos de concreto
[CONC, nelemconc]=sectionconc(H);

% Armazenamento das propriedades dos elementos de aço
[STEEL, nelemsteel]=sectionsteel(HH, PAR);

% Criação das matrizes nulas contidas na "structure" ELEMENTO
% ELEMENTOS.Area=zeros(PORTICO.nelem,4);      % <-- Área da seção transversal
% ELEMENTOS.Inercia=zeros(PORTICO.nelem,4);   % <-- Momento de inércia da seção transversal
ELEMENTOS.dp=zeros(PORTICO.nelem,3);        % <-- Desvio padrão da área (col. 1), inércia (col.2), perímetro (col. 3)
ELEMENTOS.material=zeros(PORTICO.nelem,1);  % <-- Material
ELEMENTOS.E=zeros(PORTICO.nelem,1);         % <-- Módulo de elasticidade
ELEMENTOS.ro=zeros(PORTICO.nelem,1);        % <-- Peso específico
ELEMENTOS.A=zeros(PORTICO.nelem,1);         % <-- Área da seção
ELEMENTOS.I=zeros(PORTICO.nelem,1);         % <-- Momento de inércia
ELEMENTOS.u=zeros(PORTICO.nelem,1);         % <-- Perímetro
ELEMENTOS.h=zeros(PORTICO.nelem,1);         % <-- Perímetro efetivo (cálculo retração e fluência)

% Preenchimento dos elementos constituídos de concreto armado
for i=1:nelemconc
    ELEMENTOS.A(CONC(i,1),1)=CONC(i,2);
    ELEMENTOS.I(CONC(i,1),1)=CONC(i,3);
    ELEMENTOS.u(CONC(i,1),1)=CONC(i,4);
    ELEMENTOS.dp(CONC(i,1),1)=CONC(i,5);
    ELEMENTOS.dp(CONC(i,1),2)=CONC(i,6);
    ELEMENTOS.dp(CONC(i,1),3)=CONC(i,7);
    ELEMENTOS.material(CONC(i,1),1)=1;
end

% Preenchimento dos elementos constituídos de aço
% Caso o não haja elemento de aço, deve-se, no arquivo de etrada de dados
% informar que o elemento "0" é constituído de aço. Assim a etapa seguinte
% não será processada.
if STEEL(1)~=0
    for i=1:nelemsteel
        ELEMENTOS.A(STEEL(i,1),1)=STEEL(i,2);
        ELEMENTOS.I(STEEL(i,1),1)=STEEL(i,3);
        ELEMENTOS.dp(STEEL(i,1),1)=STEEL(i,4);
        ELEMENTOS.dp(STEEL(i,1),2)=STEEL(i,5);
        ELEMENTOS.material(STEEL(i,1))=2;
    end    
end

% Armazena a seção inicial dos elementos estruturais
%ELEMENTOS.secaoINICIAL=ELEMENTOS.secao;
