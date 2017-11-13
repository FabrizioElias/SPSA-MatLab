function [Eci, Ecs]=modulusFIBMC2010(PAR, fcm)
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
% Criada      15-dezembro-2016                 SÉRGIO MARQUES
% -------------------------------------------------------------------------

%Módulo de elasticidade tangente aos 28 dias 
Eci=(PAR.CONC.Ec0.parest1*PAR.CONC.alfaE.parest1).*((PAR.CONC.fccV./1000)./10).^(1/3);  % <-- Divisão por mil para transformar de kN/m2 para MPa

% Módulo de elasticidade secante aos 28 dias
alfai=0.8+0.2.*(PAR.CONC.fccV./1000)./88;    % <-- Divisão por mil para transformar de kN/m2 para MPa
Ecs=alfai.*Eci;