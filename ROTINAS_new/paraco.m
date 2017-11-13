function [PAR]=paraco(DADOS, PAR)
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
% Função irá ler os parâmetros do aço para concreto armado
% -------------------------------------------------------------------------
% Criada      20-abril-2017                 SÉRGIO MARQUES
% -------------------------------------------------------------------------

fidparaco=fopen(DADOS.fileparaco,'r');
while ~feof (fidparaco)
    for k=1:2
        lixo=fgets(fidparaco);
    end
    % Armazena em uma matriz coluna todos os dados referentes às
    % coordenadas dos nós.
    var=fscanf(fidparaco,'%f');
end
% Resistência à tração armaduras longitudinais
PAR.ACO.RESTRAC.type=var(1);
PAR.ACO.RESTRAC.parest1=var(2);
PAR.ACO.RESTRAC.parest2=var(3);
% Peso Específico do aço
PAR.ACO.PESOESP.type=var(4);
PAR.ACO.PESOESP.parest1=var(5);
PAR.ACO.PESOESP.parest2=var(6);
% Módulo de Elasticidade
PAR.ACO.Es.type=var(7);
PAR.ACO.Es.parest1=var(8);
PAR.ACO.Es.parest2=var(9);