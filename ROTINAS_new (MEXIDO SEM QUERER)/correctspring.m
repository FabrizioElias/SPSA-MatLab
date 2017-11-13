function [CS]=correctspring(PORTICO, D)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCI�NCIAS
% PROGRAMA DE P�S-GRADUA��O EM ENGENHARIA CIVIL        - �REA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELE��O DE  M�DIA FIDELIDADE  PARA  AN�LISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO.
% ALUNA       S�rgio Jos� Priori Jovino Marques Filho
% ORIENTADOR  Prof. �zio da Rocha Ara�jo
% -------------------------------------------------------------------------
% DESCRI��O
% Esta rotina serve para fazer um ajuste no coeficiente de mola do solo. Na 
% regi�o do encontro, as molas atuam apenas quando a ponte sofre
% alongamento, nesse caso nenhuma considera��o deve ser feita. No caso das
% cargas de protens�o, efeitos diferidos e varia��o negativa de temperatura
% a ponte deve sofrer contra��o, de modo que as molas n�o devem funcionar.
% -------------------------------------------------------------------------
% MODIFICA��ES:         Modificada em
%--------------------------------------------------------------------------
% CRIADA EM 10-Julho-2017
% -------------------------------------------------------------------------
CS=ones(PORTICO.nelem,1);
b1=linspace(D(2,1),D(2,2),(D(2,2)-D(2,1)+1));
b2=linspace(D(7,1),D(7,2),(D(7,2)-D(7,1)+1));
B=[b1,b2];
s=size(B);
s=s(2);
for i=1:s
    CS(B(i))=0;
end

