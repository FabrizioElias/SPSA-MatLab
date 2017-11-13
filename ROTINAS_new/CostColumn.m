function [cost]=CostColumn(Pilarresult, PAR, cost)
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
% Rotina para calcular o custo unitário de cada viga em uma detarinada
% iteração "m".
% -------------------------------------------------------------------------
% Criada      30-maio-2016                 SÉRGIO MARQUES
% -------------------------------------------------------------------------

global m
% global SPA_P SVC_P SForma_P
% global CPA  CPC  CPF

% CÁLCULO DOS INSUMOS DO PÓRTICO NA ITERAÇÃO m
% Peso de aço
cost.SPA_P(m)=sum(Pilarresult.PesoArmLong(m,:));
 % Volume de concreto
 cost.SVC_P(m)=sum(Pilarresult.Volconc(m,:));
 % Área de forma
 cost.SForma_P(m)=sum(Pilarresult.Aforma(m,:));
 
 % CÁLCULO DOS CUSTOS DOS INSUMOS NA ITERAÇÃO m
 % Custo do aço
cost.CPA(m)=cost.SPA_P(m)*PAR.ECO.Custo_acoV(m);
cost.CPC(m)=cost.SVC_P(m)*PAR.ECO.Custo_concV(m);
cost.CPF(m)=cost.SForma_P(m)*PAR.ECO.Custo_forV(m);