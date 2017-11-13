function [cost]=CostBeam(VIGAresult, PAR, cost)
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
% global SPA_V SVC_V SForma_V
% global CVA  CVC  CVF

% CÁLCULO DOS INSUMOS DO PÓRTICO NA ITERAÇÃO m
% Peso de aço
cost.SPA_V(m)=VIGAresult.PESOnegTOTAL+VIGAresult.PESOmontagemTOTAL+...
     VIGAresult.PESOposTOTAL+VIGAresult.PESOpeleTOTAL+VIGAresult.PESOestribosTOTAL;
 % Volume de concreto
 cost.SVC_V(m)=VIGAresult.volconcTOTAL;
 % Área de forma
 cost.SForma_V(m)=VIGAresult.aformaTOTAL;
 
 % CÁLCULO DOS CUSTOS DOS INSUMOS NA ITERAÇÃO m
 % Custo do aço
cost.CVA(m)=cost.SPA_V(m)*PAR.ECO.Custo_acoV(m);
cost.CVC(m)=cost.SVC_V(m)*PAR.ECO.Custo_concV(m);
cost.CVF(m)=cost.SForma_V(m)*PAR.ECO.Custo_forV(m);