function [PAR]=phisicalparFIBMC2010(PAR, VIGA, ELEMENTOS, DADOS)
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
% Alteraos valores do m�dulo de elasticidade tangente e secante, lidos no
% cart�o de entrada, por �queles calculados � partir do modelo do FIB.
% -------------------------------------------------------------------------
% Criada      20-dezembro-2016                 S�RGIO MARQUES
% -------------------------------------------------------------------------

% Resist�ncia � compress�o m�dia do concreto
fcm=PAR.CONC.RESCOMP.parest1+PAR.CONC.DELTARESCOMP.parest1; 

% M�dulo de elasticidade tangente do concreto
[Eci, Ecs]=modulusFIBMC2010(PAR, fcm);

% Determina��o do coeficiente de flu�ncia segundo o modelo do FIB
[phi]=creepcoefFIBMC2010(PAR, fcm, VIGA, ELEMENTOS, DADOS);

% Determina��o da deforma��o espec�fica de retra��o segundo o modelo do FIB
[epsoncs]=shrinkageFIBMC2010(PAR, fcm, VIGA, ELEMENTOS, DADOS);

% Altera��o dos valores fornecidos no cart�o de entrada
PAR.CONC.EciV=Eci;
PAR.CONC.EcsV=Ecs;
PAR.CONC.phiV=phi;
PAR.CONC.epsoncsV=epsoncs;

