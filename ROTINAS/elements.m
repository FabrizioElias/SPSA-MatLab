function [PORTICO]=elements(C,PORTICO)
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
% Fun��o ir� escrever na structure PORTICO as propriedades dos elementos do
% p�rtico - material, n� inicial e n� final.
% -------------------------------------------------------------------------
% Criada      25-abril-2016                 S�RGIO MARQUES
% -------------------------------------------------------------------------

% Cria��o vetores nulos
PORTICO.material=zeros(1,PORTICO.nelem);
PORTICO.noinicial=zeros(1,PORTICO.nelem);
PORTICO.nofinal=zeros(1,PORTICO.nelem);
PORTICO.elemestrutural=zeros(1,PORTICO.nelem);

for i=1:PORTICO.nelem
    PORTICO.material(C(1+(i-1)*6))=C(3+(i-1)*6);    %Vetor com o tipo de "MATERIAL" por elemento
    PORTICO.noinicial(C(1+(i-1)*6))=C(4+(i-1)*6);   %Vetor com o n� inicial de cada elemento                                                   
    PORTICO.nofinal(C(1+(i-1)*6))=C(5+(i-1)*6);     %Vetor com o n� final de cada elemento 
    PORTICO.elemestrutural(C(1+(i-1)*6))=C(6+(i-1)*6);     %Vetor com os elementos de cada elemento estrutural
end

 % Cria��o da matriz de conectividade dos elementos
PORTICO.conec=[PORTICO.noinicial',PORTICO.nofinal'];