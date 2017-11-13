function [PILARresults]=column7(PILARin, PILARout, PILARresults, i, pilar, PORTICO)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIÊNCIAS
% PROGRAMA DE PÓS-GRADUAÇÃO EM ENGENHARIA CIVIL        - ÁREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELEÇÃO DE  MÉDIA FIDELIDADE  PARA  ANÁLISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO.
% ALUNO       Sérgio José Priori Jovino Marques Filho
% ORIENTADOR  Prof. Ézio da Rocha Araújo
% -------------------------------------------------------------------------
% DESCRIÇÃO
% Rotina para dcálculo dos esforços resitentes da seção de concreto armado
% -------------------------------------------------------------------------
% MODIFICAÇÕES:         
%--------------------------------------------------------------------------
% VARIÁVEIS DE ENTRADA: --
% VARIÁVEIS DE SAÍDA:   PILARin: "structure" contendo as variáveis necessá-
% rias ao algoritmo de detalhamento do pilar - column.m 
%--------------------------------------------------------------------------
% CRIADA EM 21-fevereiro-2016
% -------------------------------------------------------------------------
global m

% % Encontra o menor peso de aço dentro os diversos calculados
% menorpeso=min(PILARout.As);          
% % Encontra a posição da bitola que fornece o menor peso de aço
% posbitola=find(PILARout.As==menorpeso,1);   

% INDICADORES AÇO
% Cálculo da área de aço, peso da armadura longitudinal, distribuição de
% barras na seção e diâmetro da barra que forneceu o menor peso de aço.
PILARresults.As(m,i)=PILARout.As(posbitola);
PILARresults.PesoArmLong(m,i)=PILARresults.As(m,i)*PORTICO.comp(pilar)*PILARin.roaco*100;
% PILARresults.distbarras(i,:,m)=PILARout.distbarras(posbitola,:);
% PILARresults.diambarra(i,:,m)=PILARout.diambarra(posbitola);

% INDICADORES CONCRETO
% Cálculo do volume de concreto e área de forma
PILARresults.Volconc(m,i)=PILARin.b*PILARin.h*PORTICO.comp(pilar);
PILARresults.Aforma(m,i)=(2*PILARin.b+2*PILARin.h)*PORTICO.comp(pilar);
