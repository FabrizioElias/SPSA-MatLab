function [PORTICO]=angular(PORTICO)
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
% Fun��o calcular o �ngulo entre os elementos e o eixo horizotal, X GLOBAL
% e escrever na structure PORTICO
% -------------------------------------------------------------------------
% Criada      25-abril-2016                 S�RGIO MARQUES
% -------------------------------------------------------------------------
for i=1:PORTICO.nelem
    PORTICO.teta(i)=atan((PORTICO.coord(PORTICO.conec(i,2),2)-PORTICO.coord(PORTICO.conec(i,1),2))/(PORTICO.coord(PORTICO.conec(i,2),1)-PORTICO.coord(PORTICO.conec(i,1),1)));
end