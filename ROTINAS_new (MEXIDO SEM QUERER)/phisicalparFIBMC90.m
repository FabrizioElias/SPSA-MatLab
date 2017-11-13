function [PAR]=phisicalparFIBMC90(PAR, VIGA,DADOS)
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
% Criada      02-janeiro-2017                 S�RGIO MARQUES
% -------------------------------------------------------------------------

% Resist�ncia � compress�o m�dia do concreto
fcm=PAR.CONC.RESCOMP.parest1+PAR.CONC.DELTARESCOMP.parest1; 

% M�dulo de elasticidade tangente do concreto
[Eci, Ecs]=modulusFIBMC90(PAR, fcm);

% Determina��o do coeficiente de flu�ncia segundo o modelo do FIB
[phi]=creepcoefFIBMC90(PAR, fcm, VIGA, DADOS);

% Altera��o dos valores fornecidos no cart�o de entrada
PAR.CONC.Eci.parest1=Eci;
PAR.CONC.Ecs.parest1=Ecs;
PAR.CONC.PHI.parest1=phi;

