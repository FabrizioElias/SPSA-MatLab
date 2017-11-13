%FAB - Otimização da assinatura do método.
%function [ELEMENTOS]=Calc_geom(PORTICO, ELEMENTOS, PAR, DADOS)
function [ELEMENTOS]=Calc_geom(PORTICO, ELEMENTOS)
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
% Altera a geometria das seções transversais à partir dos valores da
% variável z(m).
% Calcula novas propriedades geométricas (área da seção transversal, momen-
% to inércia e peso próprio) de vigas e pilares após a modificação da 
% geometria inicial dos elementos.
% -------------------------------------------------------------------------
% Criada      12-junho-2015                 SÉRGIO MARQUES
% -------------------------------------------------------------------------

global m

% ÁREA, MOMENTO DE INÉRCIA E "TAMANHO NOCIONAL" DA SEÇÃO TRANSVERSAL
% O "tamanho nocional", na falta de um termo em portguês, é utiliado par ao
% cálulo do coeficente de fluência. Será representado pela variável "h" e é
% dado em mm.
for i=1:PORTICO.nelem
    % Divisão por 100 para passar de cm para m
    tw=ELEMENTOS.secaoV(i,1,m);
    h=ELEMENTOS.secaoV(i,2,m);
    bf=ELEMENTOS.secaoV(i,3,m);
    tf=ELEMENTOS.secaoV(i,4,m);
    % Cálculo da área
    A=tw*h+2*bf*tf;
    % Cálculo do momento de inércia - Teorema dos eixos paralelos
    I=tw*h^3/12+2*(bf*tf^3/12+bf*tf*(h/2+tf/2)^2);
    % Cálculo do períetro efetivo - validade apenas para elementos de
    % concreto
    hef=2*A*10^-6/((2*tw+2*h)*10^-3);
    % Armazenamento dos valores calculados na "structure" ELEMENTOS
    ELEMENTOS.A(i)=A;
    ELEMENTOS.I(i)=I;
    ELEMENTOS.h(i)=hef;
end