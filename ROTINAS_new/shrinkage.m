function [deltacs]=shrinkage(PORTICO, VIGA, PAR)
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
% Cálculo da deformação específica de fluência.
% -------------------------------------------------------------------------
% Criada      21-dezembro-2016                 SÉRGIO MARQUES
% -------------------------------------------------------------------------

global m

s=size(VIGA.elemento);
deltacs=zeros(1,s(2));
% A variável "i" irá variar de 1 até o número total de vigas
for i=1:s(2)
    % Cálculo da deformação absoluta dde fluência
    L=PORTICO.comp(VIGA.elemento(i));
    %L=25;
    deltacs(i)=PAR.CONC.epsoncsV(i,m)*L;
end