%FAB - Otimiza��o da assinatura do m�todo.
%function [ELEMENTOS]=Calc_geom(PORTICO, ELEMENTOS, PAR, DADOS)
function [ELEMENTOS]=Calc_geom(PORTICO, ELEMENTOS)
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
% Altera a geometria das se��es transversais � partir dos valores da
% vari�vel z(m).
% Calcula novas propriedades geom�tricas (�rea da se��o transversal, momen-
% to in�rcia e peso pr�prio) de vigas e pilares ap�s a modifica��o da 
% geometria inicial dos elementos.
% -------------------------------------------------------------------------
% Criada      12-junho-2015                 S�RGIO MARQUES
% -------------------------------------------------------------------------

global m

% �REA, MOMENTO DE IN�RCIA E "TAMANHO NOCIONAL" DA SE��O TRANSVERSAL
% O "tamanho nocional", na falta de um termo em portgu�s, � utiliado par ao
% c�lulo do coeficente de flu�ncia. Ser� representado pela vari�vel "h" e �
% dado em mm.
for i=1:PORTICO.nelem
    % Divis�o por 100 para passar de cm para m
    tw=ELEMENTOS.secaoV(i,1,m);
    h=ELEMENTOS.secaoV(i,2,m);
    bf=ELEMENTOS.secaoV(i,3,m);
    tf=ELEMENTOS.secaoV(i,4,m);
    % C�lculo da �rea
    A=tw*h+2*bf*tf;
    % C�lculo do momento de in�rcia - Teorema dos eixos paralelos
    I=tw*h^3/12+2*(bf*tf^3/12+bf*tf*(h/2+tf/2)^2);
    % C�lculo do per�etro efetivo - validade apenas para elementos de
    % concreto
    hef=2*A*10^-6/((2*tw+2*h)*10^-3);
    % Armazenamento dos valores calculados na "structure" ELEMENTOS
    ELEMENTOS.A(i)=A;
    ELEMENTOS.I(i)=I;
    ELEMENTOS.h(i)=hef;
end