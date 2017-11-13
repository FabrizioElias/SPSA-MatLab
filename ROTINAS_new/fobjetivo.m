function ESTATISTICA = fobjetivo(VIGA, PILAR, DADOS, PAR, ELEMENTOS, PORTICO, FLUXOCAIXA)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIENCIAS
% PROGRAMA DE POS-GRADUACAO EM ENGENHARIA CIVIL        - AREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELECAO DE  M�DIA FIDELIDADE  PARA  AN�LISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO.
% ALUNA       Nilma Andrade
% ORIENTADOR  Prof. Ezio da Rocha Araujo
% -------------------------------------------------------------------------
% DESCRI��O
% Define os valores m�dios das vari�veis de projeto.
% Chama MONTECARLO.m
% Calcula m�dia, desvio padr�o e coef. de varia��o da fun��o objetivo
% -------------------------------------------------------------------------
% ADAPTACAO DA ROTINA DE DIEGO OLIVEIRA 30-Janeiro-2006
% Criada      04-Agosto-2011              NILMA ANDRADE
% Modificada  30-Novembro-2011
% -------------------------------------------------------------------------

%Dentro de MONTECARLO.m,o simulador (Portico Plano.m ou Feap) e os
%algoritmos de dimensionamento s�o chamados NMC vezes.
%FAB - Remo��o de vari�vel de retorno sem utilidade.
%[ELEMENTOS, COST, VPL] = MONTECARLO(DADOS, PAR, ELEMENTOS, PORTICO, VIGA, PILAR, FLUXOCAIXA);
[~, COST, VPL] = MONTECARLO(DADOS, PAR, ELEMENTOS, PORTICO, VIGA, PILAR, FLUXOCAIXA);

%Ap�s executar-se MONTECARLO.m, disp�e-se de um vetor com os custos para
%cada conjunto de vari�veis aleat�rias: f_mc.    
%N�mero de elementos de f_mc: NMC
    
%4 - TRATAMENTO EST�TISCO DO CUSTO 
if DADOS.op_minimax==0
    f_mc=COST.total;
elseif DADOS.op_minimax==1
    f_mc=VPL;
end
varf=var(f_mc);  %Vari�ncia da fun��o objetivo
stdf=std(f_mc);  %Desvio padr�o da fun��o objetivo
medf=mean(f_mc); %M�dia da fun��o objetivo
covf=stdf/medf;  %Coeficiente de varia��o da fun��o objetivo

%disp('    Valor da avalia��o da fun��o objetivo para cada experimento de Monte Carlo')
%disp(['    ',num2str(f_mc)])
% Armazenamento das vari�veis estat�sticas dentro de uma structure
ESTATISTICA.var(1)=(varf);
ESTATISTICA.std(1)=(stdf);
ESTATISTICA.med(1)=(medf);
ESTATISTICA.cov(1)=(covf);
% Valor m�dio da fun��o = m�dia das realiza��es
%FAB - Remo��o de vari�vel sem utilidade.
%func0=medf;