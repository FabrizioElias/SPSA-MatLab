function [Eci, Ecs]=modulusFIBMC90(PAR, fcm)
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
% Função criada para calcular o módulo de elasticidade tangente e secante
% do concreto segundo o MODEL CODE - FIB.
% -------------------------------------------------------------------------
% Criada      02-janiro-2017                 SÉRGIO MARQUES
% -------------------------------------------------------------------------

%Módulo de elasticidade tangente aos 28 dias 
Eci=PAR.CONC.alfaE.type*10000*(fcm/1000)^(1/3)*1000;  % <-- Divisão por mil do valor de fcm para transformar de kN/m2 para MPa
                                                      % <-- Multiplicação por mil do resultado para transforma de MPA (n/mm2) para kN/m2  
% Módulo de elasticidade secante aos 28 dias
alfai=0.85;
Ecs=alfai*Eci;