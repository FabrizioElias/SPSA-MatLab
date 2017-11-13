function [PORTICO]=bound(D, PORTICO)
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
% Função calcular o ângulo entre os elementos e o eixo horizotal, X GLOBAL
% e escrever na structure PORTICO
% -------------------------------------------------------------------------
% Criada      25-abril-2016                 SÉRGIO MARQUES
% -------------------------------------------------------------------------
% Quantidade de nós com restrição
s=size(D);
s=s(1);
PORTICO.qntnosrestritos=s/8;
k=1;
j=3;
l=8;
PORTICO.nosrestritos(1,1)=D(1);
a=D(j:l);
PORTICO.restricao(1,:)=a';
for i=2:PORTICO.qntnosrestritos
    k=k+8;
    j=j+8;
    l=l+8;
    PORTICO.nosrestritos(i,1)=D(k);
    a=D(j:l);
    PORTICO.restricao(i,:)=a';
end