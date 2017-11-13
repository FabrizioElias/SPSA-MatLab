function [STEEL, nelemsteel]=sectionsteel(HH, PAR)
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
% Fun��o ir� escrever na structure ELEMENTOS as propriedades geom�tricas
% dos elementos met�licos
% -------------------------------------------------------------------------
% Criada      11-fevereiro-2017                 S�RGIO MARQUES
% -------------------------------------------------------------------------

s=size(HH);
s=s(1);
nelemsteel=s/5;

% Descri��o das colunas da matriz STEEL
% Elemento  DiamExterno  EspParedeTubo  DesvPadDiam externo   DesvPadEspParedeTubo
STEEL=zeros(nelemsteel,5);

for i=1:nelemsteel
    % C�lculo da �rea da se��o uniformizada de a�o
    %[A, I]=areauniform(HH, i, PAR);
    STEEL(i,1)=HH(5*(i-1)+1);   % <-- Elemento
    STEEL(i,2)=HH(5*(i-1)+2);   % <-- �rea uniformizada
    STEEL(i,3)=HH(5*(i-1)+3);   % <-- Momento de in�rcia uniformizado
    STEEL(i,4)=HH(5*(i-1)+4);   % <-- Desvio Padr�o da �rea
    STEEL(i,5)=HH(5*(i-1)+5);   % <-- Desvio padr�o do momento de in�rcia
end