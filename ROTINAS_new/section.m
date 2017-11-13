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
[STEEL, nelemsteel]=sectionsteel(HH);

% Criação das matrizes nulas contidas na "structure" ELEMENTO
ELEMENTOS.secao=zeros(PORTICO.nelem,4);     % <-- Seção transversal
ELEMENTOS.cov=zeros(PORTICO.nelem,4);        % <-- Desvio Padrão
ELEMENTOS.elem=zeros(PORTICO.nelem,1);      % <-- Discretização
ELEMENTOS.material=zeros(PORTICO.nelem,1);  % <-- Material
ELEMENTOS.E=zeros(PORTICO.nelem,1);         % <-- Módulo de elasticidade
ELEMENTOS.ro=zeros(PORTICO.nelem,1);        % <-- Peso específico
ELEMENTOS.A=zeros(PORTICO.nelem,1);         % <-- Área da seção
ELEMENTOS.I=zeros(PORTICO.nelem,1);         % <-- Momento de inércia
ELEMENTOS.u=zeros(PORTICO.nelem,1);         % <-- Perímetro real
ELEMENTOS.h=zeros(PORTICO.nelem,1);         % <-- Perímetro efetivo (cálculo retração e fluência)

% Preenchimento dos elementos constituídos de concreto armado
for i=1:nelemconc
    ELEMENTOS.secao(CONC(i,1),1)=CONC(i,2);
    ELEMENTOS.secao(CONC(i,1),2)=CONC(i,3);
    ELEMENTOS.cov(CONC(i,1),1)=CONC(i,4);
    ELEMENTOS.cov(CONC(i,1),2)=CONC(i,5);
    ELEMENTOS.elem(CONC(i,1),1)=CONC(i,6);
    ELEMENTOS.material(CONC(i,1),1)=1;
end

% Preenchimento dos elementos constituídos de aço
% Caso o não haja elemento de aço, deve-se, no arquivo de etrada de dados
% informar que o elemento "0" é constituído de aço. Assim a etapa seguinte
% não será processada.
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

% CÁLCULO DAS PROPRIEDADES GEOMÉTRICAS DA SEÇÃO.
% Cada elemento estrutural terá suas propriedades geométricas calculadas de
% forma "personalizada".
% Elementos 1 e 3 - Estacas metálicas, eixo de menor inercia perpendicular
% à via
% Elementos 2 e 4 - Encontro, seção retangular
% Elementos 5, 6 e 7 - Viga, seção retangular fictícia. As dimensões da
% seção retangular foram calculadas de forma a reproduzir o mesmo valor da
% área e momento de inércia de uma viga pré-fabricada padrão AASHTO VI
% Elementos 8 e 9 - Pilar, seção retangular de concreto

for i=1:(nelemconc+nelemsteel)
    if PORTICO.elemestrutural(i)==1 || PORTICO.elemestrutural(i)==3
        ELEMENTOS.A(i)=2*(ELEMENTOS.secao(i,3)*ELEMENTOS.secao(i,4))+ELEMENTOS.secao(i,1)*(ELEMENTOS.secao(i,2)-2*ELEMENTOS.secao(i,4));
        ELEMENTOS.I(i)=2*(ELEMENTOS.secao(i,4)*ELEMENTOS.secao(i,3)^3/12)+(ELEMENTOS.secao(i,2)-2*ELEMENTOS.secao(i,4))*ELEMENTOS.secao(i,1)^3/12;
        % Não calcula perímetro efetivo, não usa para nada
    elseif PORTICO.elemestrutural(i)==2 || PORTICO.elemestrutural(i)==4
        ELEMENTOS.A(i)=ELEMENTOS.secao(i,1)*ELEMENTOS.secao(i,2);
        ELEMENTOS.I(i)=ELEMENTOS.secao(i,1)*ELEMENTOS.secao(i,2)^3/12;
        % Não calcula perímetro  efetivo, não usa para nada
    elseif PORTICO.elemestrutural(i)==5 || PORTICO.elemestrutural(i)==6 || PORTICO.elemestrutural(i)==7
        ELEMENTOS.A(i)=ELEMENTOS.secao(i,1)*ELEMENTOS.secao(i,2);
        ELEMENTOS.I(i)=ELEMENTOS.secao(i,1)*ELEMENTOS.secao(i,2)^3/12;
        ELEMENTOS.u(i)=9.37; % Dimensão em milímetro
    elseif PORTICO.elemestrutural(i)==8 || PORTICO.elemestrutural(i)==9
        ELEMENTOS.A(i)=ELEMENTOS.secao(i,1)*ELEMENTOS.secao(i,2);
        ELEMENTOS.I(i)=ELEMENTOS.secao(i,1)*ELEMENTOS.secao(i,2)^3/12;
        % Não calcula perímetro  efetivo, não usa para nada
    end
end