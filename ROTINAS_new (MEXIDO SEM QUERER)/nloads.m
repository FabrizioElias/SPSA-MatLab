function [PORTICO]=nloads(E,PORTICO)
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
% Função irá escrever na structure PORTICO sa cargas nodais aplicadas ao
% pórtico plano.
% -------------------------------------------------------------------------
% Criada      23-maio-2016                 SÉRGIO MARQUES
% -------------------------------------------------------------------------

s=size(E);
s=s(1);
PORTICO.qntdircarregadas=s/5;
for i=1:PORTICO.qntdircarregadas
    PORTICO.dircarregadas(i)=E(1+5*(i-1));
    PORTICO.carganodal(i)=E(2+5*(i-1));
    PORTICO.carganodalPDF(i)=E(3+5*(i-1));
    PORTICO.carganodalParEst1(i)=E(4+5*(i-1));
    PORTICO.carganodalParEst2(i)=E(5+5*(i-1));
end