function [PAR]=parconc(DADOS)
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
% Função irá ler os parâmetros do concreto considerados independentes do
% tempo
% -------------------------------------------------------------------------
% Criada      20-abril-2017                 SÉRGIO MARQUES
% -------------------------------------------------------------------------

fidparconc=fopen(DADOS.fileparconc,'r');
while ~feof (fidparconc)
    for k=1:2
        lixo=fgets(fidparconc);
    end
    % Armazena em uma matriz coluna todos os dados referentes às
    % propriedades do concreto
    var=fscanf(fidparconc,'%f');
end
% Fecha o arquivo de dados  referente aos parâmetros do concreto
fclose(fidparconc);
% Escreve na estrutura PAR as propriedades e parâmetros de distribuição do
% conCreto.
% Resistência à compressão
PAR.CONC.RESCOMP.type=var(1);
PAR.CONC.RESCOMP.parest1=var(2);
PAR.CONC.RESCOMP.parest2=var(3);
% Delta Resistência à compressão
PAR.CONC.DELTARESCOMP.type=var(4);
PAR.CONC.DELTARESCOMP.parest1=var(5);
PAR.CONC.DELTARESCOMP.parest2=var(6);
% Parâmetro alfaE, incide no cálculo do módulo de elasticidade modelo FIB.
PAR.CONC.alfaE.type=var(7);
PAR.CONC.alfaE.parest1=var(8);
PAR.CONC.alfaE.parest2=var(9);
% Parâmetro Ec0, incide no cálculo do módulo de elasticidade modelo FIB.
PAR.CONC.Ec0.type=var(10);
PAR.CONC.Ec0.parest1=var(11);
PAR.CONC.Ec0.parest2=var(12);
% Peso específico do concreto
PAR.CONC.PESOESP.type=var(13);
PAR.CONC.PESOESP.parest1=var(14);
PAR.CONC.PESOESP.parest2=var(15);
% Módulo de Elasticidade tangente
PAR.CONC.Eci.type=var(16);
PAR.CONC.Eci.parest1=var(17);
PAR.CONC.Eci.parest2=var(18);
% Módulo de Elasticidade secante
PAR.CONC.Ecs.type=var(19);
PAR.CONC.Ecs.parest1=var(20);
PAR.CONC.Ecs.parest2=var(21);
% Coeficiente de Poisson
PAR.CONC.POISSON.type=var(22);
PAR.CONC.POISSON.parest1=var(23);
PAR.CONC.POISSON.parest2=var(24);
% Coeficiente de Fluência
PAR.CONC.PHI.type=var(25);
PAR.CONC.PHI.parest1=var(26);
PAR.CONC.PHI.parest2=var(27);
% Deformação específica de retração
PAR.CONC.EPSONcs.type=var(28);
PAR.CONC.EPSONcs.parest1=var(29);
PAR.CONC.EPSONcs.parest2=var(30);
% Coeficiente de térmico
PAR.CONC.ALFATEMP.type=var(31);
PAR.CONC.ALFATEMP.parest1=var(32);
PAR.CONC.ALFATEMP.parest2=var(33);