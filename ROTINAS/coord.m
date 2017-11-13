function [PORTICO]=coord(B,PORTICO)
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
% Fun��o ir� escrever na structure PORTICO as coordenadas dos n�s do p�rtico.
% -------------------------------------------------------------------------
% Criada      75-abril-2016                 S�RGIO MARQUES
% -------------------------------------------------------------------------

% Cria��o de vetores nulos
PORTICO.x = zeros(1,PORTICO.nnos); 
PORTICO.y = zeros(1,PORTICO.nnos);
PORTICO.z = zeros(1,PORTICO.nnos);
PORTICO.coord = zeros(PORTICO.nnos,2);

% PORTICO.x(B(1))=B(3);
% PORTICO.y(B(1))=B(4);
% PORTICO.z(B(1))=B(5);

for i=1:PORTICO.nnos
    PORTICO.x(B(1+(i-1)*5))= B(3+(i-1)*5);  %coordenada x do n� i
    PORTICO.y(B(1+(i-1)*5))= B(4+(i-1)*5);  %coordenada y do n� i
    PORTICO.z(B(1+(i-1)*5))= B(5+(i-1)*5);  %coordenada z do n� i
end

% Cria uma matriz contendo o as coordenadas X na primeira coluna e as
% coordenadas Z na segunda coluna.
for i=1:PORTICO.nnos
    PORTICO.coord(i,1) = PORTICO.x(1,i);
    PORTICO.coord(i,2) = PORTICO.z(1,i);
end