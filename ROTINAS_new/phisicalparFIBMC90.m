function [PAR]=phisicalparFIBMC90(PAR, VIGA,DADOS)
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
% Alteraos valores do módulo de elasticidade tangente e secante, lidos no
% cartão de entrada, por àqueles calculados à partir do modelo do FIB.
% -------------------------------------------------------------------------
% Criada      02-janeiro-2017                 SÉRGIO MARQUES
% -------------------------------------------------------------------------

% Resistência à compressão média do concreto
fcm=PAR.CONC.RESCOMP.parest1+PAR.CONC.DELTARESCOMP.parest1; 

% Módulo de elasticidade tangente do concreto
[Eci, Ecs]=modulusFIBMC90(PAR, fcm);

% Determinação do coeficiente de fluência segundo o modelo do FIB
[phi]=creepcoefFIBMC90(PAR, fcm, VIGA, DADOS);

% Alteração dos valores fornecidos no cartão de entrada
PAR.CONC.Eci.parest1=Eci;
PAR.CONC.Ecs.parest1=Ecs;
PAR.CONC.PHI.parest1=phi;

