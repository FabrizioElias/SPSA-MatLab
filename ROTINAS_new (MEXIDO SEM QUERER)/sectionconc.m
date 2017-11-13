function [CONC, nelemconc]=sectionconc(H)
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
% Criada      23-maio-2016                 SÉRGIO MARQUES
% -------------------------------------------------------------------------

s=size(H);
s=s(1);
nelemconc=s/7;

% Descrição das colunas da matriz CONC
% Elemento  Área  Inércia  Perímetro  DesvPdArea  DesvPadInercia  DesvPadPerímetro
% 
CONC=zeros(nelemconc,7);
for i=1:nelemconc
    CONC(i,1)=H(7*(i-1)+1);
    CONC(i,2)=H(7*(i-1)+2);
    CONC(i,3)=H(7*(i-1)+3);
    CONC(i,4)=H(7*(i-1)+4);
    CONC(i,5)=H(7*(i-1)+5);
    CONC(i,6)=H(7*(i-1)+6);
    CONC(i,7)=H(7*(i-1)+7);
end

%CONC.secaoINICIAL=CONC.secao; % <-- Variável criada para armazenar os valores iniciais da seção transversal uma vez que ELEMENTOS.secao irá sofrer alterações