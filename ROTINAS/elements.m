function [PORTICO]=elements(C,PORTICO)
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
% Função irá escrever na structure PORTICO as propriedades dos elementos do
% pórtico - material, nó inicial e nó final.
% -------------------------------------------------------------------------
% Criada      25-abril-2016                 SÉRGIO MARQUES
% -------------------------------------------------------------------------

% Criação vetores nulos
PORTICO.material=zeros(1,PORTICO.nelem);
PORTICO.noinicial=zeros(1,PORTICO.nelem);
PORTICO.nofinal=zeros(1,PORTICO.nelem);
PORTICO.elemestrutural=zeros(1,PORTICO.nelem);

for i=1:PORTICO.nelem
    PORTICO.material(C(1+(i-1)*6))=C(3+(i-1)*6);    %Vetor com o tipo de "MATERIAL" por elemento
    PORTICO.noinicial(C(1+(i-1)*6))=C(4+(i-1)*6);   %Vetor com o nó inicial de cada elemento                                                   
    PORTICO.nofinal(C(1+(i-1)*6))=C(5+(i-1)*6);     %Vetor com o nó final de cada elemento 
    PORTICO.elemestrutural(C(1+(i-1)*6))=C(6+(i-1)*6);     %Vetor com os elementos de cada elemento estrutural
end

 % Criação da matriz de conectividade dos elementos
PORTICO.conec=[PORTICO.noinicial',PORTICO.nofinal'];