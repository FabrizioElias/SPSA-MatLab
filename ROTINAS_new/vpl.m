function VPL = vpl(COST, FLUXOCAIXA, DADOS, VPL)
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
% Calcula o VPL do empreendimento. Essa função deve ser ajustada caso à
% caso pois o fluxo de caixa depnde fortemente do problema a ser estudado.
% -------------------------------------------------------------------------
% Criada      05-setembro-2016                 SÉRGIO MARQUES
% -------------------------------------------------------------------------

global m

% Nesse problema iremos considerar que o empreendedor terá como uníca
% despesa o custo total da estrutura, realizado todo no primeiro mês da
% série histórica. Em seguinda, à partir do segundo mês, terá recebimento
% constente durante a vida útil da edificação.

FLUXOCAIXA.despesas(1)=COST.total(m);
n=size(FLUXOCAIXA.despesas);
n=n(1);
FC=-FLUXOCAIXA.despesas+FLUXOCAIXA.receitas;
for i=1:n
    FC(i)=FC(i)/((1+DADOS.tx)^i);
end
VPL(m)=sum(FC);