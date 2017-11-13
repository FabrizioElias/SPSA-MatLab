function ESTATISTICA=fobjetivo(VIGA, PILAR, DADOS, PAR, ELEMENTOS, PORTICO, FLUXOCAIXA, COST, VPL, ESTRUTURAL, CORTANTE, MOMENTO, NORMAL, TRANSX, TRANSZ, ROTACAO, CARGASOLO)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIENCIAS
% PROGRAMA DE POS-GRADUACAO EM ENGENHARIA CIVIL        - AREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELECAO DE  MÉDIA FIDELIDADE  PARA  ANÁLISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO.
% ALUNA       Nilma Andrade
% ORIENTADOR  Prof. Ezio da Rocha Araujo
% -------------------------------------------------------------------------
% DESCRIÇÃO
% Define os valores médios das variáveis de projeto.
% Chama MONTECARLO.m
% Calcula média, desvio padrão e coef. de variação da função objetivo
% -------------------------------------------------------------------------
% ADAPTACAO DA ROTINA DE DIEGO OLIVEIRA 30-Janeiro-2006
% Criada      04-Agosto-2011              NILMA ANDRADE
% Modificada  30-Novembro-2011
% -------------------------------------------------------------------------

%Dentro de MONTECARLO.m,o simulador (Portico Plano.m ou Feap) e os
%algoritmos de dimensionamento são chamados NMC vezes.
[ELEMENTOS, COST, VPL, PAR, TRANSX, TRANSZ, ROTACAO, MOMENTO, CORTANTE, NORMAL] = MONTECARLO(DADOS, COST, VPL, ...
        PAR, ELEMENTOS, PORTICO, VIGA, PILAR, FLUXOCAIXA, ESTRUTURAL, CORTANTE, MOMENTO, NORMAL, TRANSX, TRANSZ, ROTACAO, CARGASOLO);

%Após executar-se MONTECARLO.m, dispõe-se de um vetor com os custos para
%cada conjunto de variáveis aleatórias: f_mc.    
%Número de elementos de f_mc: NMC
    
%4 - TRATAMENTO ESTÁTISCO DO CUSTO 
if DADOS.op_minimax==0
    f_mc=COST.total;
elseif DADOS.op_minimax==1
    f_mc=VPL;
end
varf=var(f_mc);  %Variância da função objetivo
stdf=std(f_mc);  %Desvio padrão da função objetivo
medf=mean(f_mc); %Média da função objetivo
covf=stdf/medf;  %Coeficiente de variação da função objetivo
% Armazenamento das variáveis estatísticas dentro de uma structure
ESTATISTICA.var(1)=(varf);
ESTATISTICA.std(1)=(stdf);
ESTATISTICA.med(1)=(medf);
ESTATISTICA.cov(1)=(covf);
% %Valor médio da função = média das realizações
func0=medf;