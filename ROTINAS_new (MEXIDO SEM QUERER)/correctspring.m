function [CS]=correctspring(PORTICO, D)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIÊNCIAS
% PROGRAMA DE PÓS-GRADUAÇÃO EM ENGENHARIA CIVIL        - ÁREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELEÇÃO DE  MÉDIA FIDELIDADE  PARA  ANÁLISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO.
% ALUNA       Sérgio José Priori Jovino Marques Filho
% ORIENTADOR  Prof. Ézio da Rocha Araújo
% -------------------------------------------------------------------------
% DESCRIÇÃO
% Esta rotina serve para fazer um ajuste no coeficiente de mola do solo. Na 
% região do encontro, as molas atuam apenas quando a ponte sofre
% alongamento, nesse caso nenhuma consideração deve ser feita. No caso das
% cargas de protensão, efeitos diferidos e variação negativa de temperatura
% a ponte deve sofrer contração, de modo que as molas não devem funcionar.
% -------------------------------------------------------------------------
% MODIFICAÇÕES:         Modificada em
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

