function [STEEL, nelemsteel]=sectionsteel(HH, PAR)
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
% Função irá escrever na structure ELEMENTOS as propriedades geométricas
% dos elementos metálicos
% -------------------------------------------------------------------------
% Criada      11-fevereiro-2017                 SÉRGIO MARQUES
% -------------------------------------------------------------------------

s=size(HH);
s=s(1);
nelemsteel=s/5;

% Descrição das colunas da matriz STEEL
% Elemento  DiamExterno  EspParedeTubo  DesvPadDiam externo   DesvPadEspParedeTubo
STEEL=zeros(nelemsteel,5);

for i=1:nelemsteel
    % Cálculo da área da seção uniformizada de aço
    %[A, I]=areauniform(HH, i, PAR);
    STEEL(i,1)=HH(5*(i-1)+1);   % <-- Elemento
    STEEL(i,2)=HH(5*(i-1)+2);   % <-- Área uniformizada
    STEEL(i,3)=HH(5*(i-1)+3);   % <-- Momento de inércia uniformizado
    STEEL(i,4)=HH(5*(i-1)+4);   % <-- Desvio Padrão da área
    STEEL(i,5)=HH(5*(i-1)+5);   % <-- Desvio padrão do momento de inércia
end