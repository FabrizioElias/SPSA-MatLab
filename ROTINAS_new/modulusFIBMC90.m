function [Eci, Ecs]=modulusFIBMC90(PAR, fcm)
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
% Fun��o criada para calcular o m�dulo de elasticidade tangente e secante
% do concreto segundo o MODEL CODE - FIB.
% -------------------------------------------------------------------------
% Criada      02-janiro-2017                 S�RGIO MARQUES
% -------------------------------------------------------------------------

%M�dulo de elasticidade tangente aos 28 dias 
Eci=PAR.CONC.alfaE.type*10000*(fcm/1000)^(1/3)*1000;  % <-- Divis�o por mil do valor de fcm para transformar de kN/m2 para MPa
                                                      % <-- Multiplica��o por mil do resultado para transforma de MPA (n/mm2) para kN/m2  
% M�dulo de elasticidade secante aos 28 dias
alfai=0.85;
Ecs=alfai*Eci;