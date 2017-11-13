function [PORTICO]=comp(PORTICO)
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
% Função calcular o comprimento dos elementos e escrever na structure 
% PORTICO
% -------------------------------------------------------------------------
% Criada      25-abril-2016                 SÉRGIO MARQUES
% -------------------------------------------------------------------------
for i=1:PORTICO.nelem
    noi=PORTICO.conec(i,1);
    nof=PORTICO.conec(i,2);
    PORTICO.comp(i)=((PORTICO.coord(noi,1)-PORTICO.coord(nof,1))^2+(PORTICO.coord(noi,2)-PORTICO.coord(nof,2))^2)^(1/2);
end