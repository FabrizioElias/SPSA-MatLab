function [PAR]=parsteel(DADOS, PAR)
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
% Fun��o ir� ler os par�metros do concreto dependentes do tempo
% -------------------------------------------------------------------------
% Criada      20-abril-2017                 S�RGIO MARQUES
% -------------------------------------------------------------------------

fidparsteel=fopen(DADOS.fileparsteel,'r');
while ~feof (fidparsteel)
    for k=1:2
        lixo=fgets(fidparsteel);
    end
    % Armazena em uma matriz coluna todos os dados referentes �s
    % coordenadas dos n�s.
    var=fscanf(fidparsteel,'%f');
end
% Resist�ncia � tra��o armaduras longitudinais
PAR.STEEL.RESTRAC.type=var(1);
PAR.STEEL.RESTRAC.parest1=var(2);
PAR.STEEL.RESTRAC.parest2=var(3);
% Peso Espec�fico do a�o
PAR.STEEL.PESOESP.type=var(4);
PAR.STEEL.PESOESP.parest1=var(5);
PAR.STEEL.PESOESP.parest2=var(6);
% M�dulo de Elasticidade
PAR.STEEL.Es.type=var(7);
PAR.STEEL.Es.parest1=var(8);
PAR.STEEL.Es.parest2=var(9);