function VPL = vpl(COST, FLUXOCAIXA, DADOS, VPL)
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
% Calcula o VPL do empreendimento. Essa fun��o deve ser ajustada caso �
% caso pois o fluxo de caixa depnde fortemente do problema a ser estudado.
% -------------------------------------------------------------------------
% Criada      05-setembro-2016                 S�RGIO MARQUES
% -------------------------------------------------------------------------

global m

% Nesse problema iremos considerar que o empreendedor ter� como un�ca
% despesa o custo total da estrutura, realizado todo no primeiro m�s da
% s�rie hist�rica. Em seguinda, � partir do segundo m�s, ter� recebimento
% constente durante a vida �til da edifica��o.

FLUXOCAIXA.despesas(1)=COST.total(m);
n=size(FLUXOCAIXA.despesas);
n=n(1);
FC=-FLUXOCAIXA.despesas+FLUXOCAIXA.receitas;
for i=1:n
    FC(i)=FC(i)/((1+DADOS.tx)^i);
end
VPL(m)=sum(FC);