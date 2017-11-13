function [STEEL, nelemsteel]=sectionsteel(HH)
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
nelemsteel=s/7;

% Descri��o das colunas da matriz STEEL
% Elemento  tw  h  bf   tf  Desv.Pad  QntElemeDiscret
STEEL=zeros(nelemsteel,6);

for i=1:nelemsteel
    STEEL(i,1)=HH(7*(i-1)+1);   % <-- Elemento
    STEEL(i,2)=HH(7*(i-1)+2);   % <-- tw, epsessura da alma
    STEEL(i,3)=HH(7*(i-1)+3);   % <-- h, altura da alma, preenchido automaticamente
    STEEL(i,4)=HH(7*(i-1)+4);   % <-- bf, espessura da mesa
    STEEL(i,5)=HH(7*(i-1)+5);   % <-- tf, espessura da mesa
    STEEL(i,6)=HH(7*(i-1)+6);   % <-- dp, desvio padr�o das medias
    STEEL(i,7)=HH(7*(i-1)+7);   % <-- quantidade de elementos que a barra foi discretizada
end