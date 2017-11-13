function [cost]=CostColumn(Pilarresult, PAR, cost)
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
% Rotina para calcular o custo unit�rio de cada viga em uma detarinada
% itera��o "m".
% -------------------------------------------------------------------------
% Criada      30-maio-2016                 S�RGIO MARQUES
% -------------------------------------------------------------------------

global m
% global SPA_P SVC_P SForma_P
% global CPA  CPC  CPF

% C�LCULO DOS INSUMOS DO P�RTICO NA ITERA��O m
% Peso de a�o
cost.SPA_P(m)=sum(Pilarresult.PesoArmLong(m,:));
 % Volume de concreto
 cost.SVC_P(m)=sum(Pilarresult.Volconc(m,:));
 % �rea de forma
 cost.SForma_P(m)=sum(Pilarresult.Aforma(m,:));
 
 % C�LCULO DOS CUSTOS DOS INSUMOS NA ITERA��O m
 % Custo do a�o
cost.CPA(m)=cost.SPA_P(m)*PAR.ECO.Custo_acoV(m);
cost.CPC(m)=cost.SVC_P(m)*PAR.ECO.Custo_concV(m);
cost.CPF(m)=cost.SForma_P(m)*PAR.ECO.Custo_forV(m);