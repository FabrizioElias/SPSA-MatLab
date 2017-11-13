function [PAR]=phisicalparFIBMC2010(PAR, VIGA, ELEMENTOS, DADOS)
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
% Criada      20-dezembro-2016                 SÉRGIO MARQUES
% -------------------------------------------------------------------------

% Resistência à compressão média do concreto
fcm=PAR.CONC.RESCOMP.parest1+PAR.CONC.DELTARESCOMP.parest1; 

% Módulo de elasticidade tangente do concreto
[Eci, Ecs]=modulusFIBMC2010(PAR, fcm);

% Determinação do coeficiente de fluência segundo o modelo do FIB
[phi]=creepcoefFIBMC2010(PAR, fcm, VIGA, ELEMENTOS, DADOS);

% Determinação da deformação específica de retração segundo o modelo do FIB
[epsoncs]=shrinkageFIBMC2010(PAR, fcm, VIGA, ELEMENTOS, DADOS);

% Alteração dos valores fornecidos no cartão de entrada
PAR.CONC.EciV=Eci;
PAR.CONC.EcsV=Ecs;
PAR.CONC.phiV=phi;
PAR.CONC.epsoncsV=epsoncs;

