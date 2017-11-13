function [cost]=CostBeam(VIGAresult, PAR, cost)
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
% global SPA_V SVC_V SForma_V
% global CVA  CVC  CVF

% C�LCULO DOS INSUMOS DO P�RTICO NA ITERA��O m
% Peso de a�o
cost.SPA_V(m)=VIGAresult.PESOnegTOTAL+VIGAresult.PESOmontagemTOTAL+...
     VIGAresult.PESOposTOTAL+VIGAresult.PESOpeleTOTAL+VIGAresult.PESOestribosTOTAL;
 % Volume de concreto
 cost.SVC_V(m)=VIGAresult.volconcTOTAL;
 % �rea de forma
 cost.SForma_V(m)=VIGAresult.aformaTOTAL;
 
 % C�LCULO DOS CUSTOS DOS INSUMOS NA ITERA��O m
 % Custo do a�o
cost.CVA(m)=cost.SPA_V(m)*PAR.ECO.Custo_acoV(m);
cost.CVC(m)=cost.SVC_V(m)*PAR.ECO.Custo_concV(m);
cost.CVF(m)=cost.SForma_V(m)*PAR.ECO.Custo_forV(m);