function [ELEMENTOS]=Mod_Elast(PORTICO, ELEMENTOS, PAR, DADOS)
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
% Preenche o módulo de elasticidade em função do tipo de material em cada
% elemento de barra.
% -------------------------------------------------------------------------
% Criada      12-fevereiro-2017                 SÉRGIO MARQUES
% -------------------------------------------------------------------------

global m

for i=1:PORTICO.nelem
    if ELEMENTOS.material(i)==1
        ELEMENTOS.E(i)=PAR.CONC.EcsV(m);
    elseif ELEMENTOS.material(i)==2
        ELEMENTOS.E(i)=PAR.STEEL.EsV(m);
    end
end