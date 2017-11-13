function [PARECON, PROP]=Parametros(PARECON, PROP, DADOS, RANDON)
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
% Calcula os parâmetros econôimcos a serem utilizados na otimização.
% Assume-se uma distribuição Gaussiana
% -------------------------------------------------------------------------
% Criada      15-abril-2016                 SÉRGIO MARQUES
% -------------------------------------------------------------------------

global m
    
% PARÂMETROS ECONÔMICOS
PARECON.Custo_acoV(m)=DADOS.CustoM_aco+(DADOS.sigma_aco*RANDON.normal(m));   %R$/kg
PARECON.Custo_conV(m)=DADOS.CustoM_con+(DADOS.sigma_con*RANDON.normal(m));   %R$/m3
PARECON.Custo_forV(m)=DADOS.CustoM_for+(DADOS.sigma_for*RANDON.normal(m));   %R$/m2

%PROPRIEDADES DO AÇO - Variáveis aleatórias

A=zeros(3,3);
A(1,1)=PROP.ACO.RESTRAC.type;
A(1,2)=PROP.ACO.RESTRAC.parest1;
A(1,3)=PROP.ACO.RESTRAC.parest2;
A(2,1)=PROP.ACO.PESOESP.type;
A(2,2)=PROP.ACO.PESOESP.parest1;
A(2,3)=PROP.ACO.PESOESP.parest2;
A(3,1)=PROP.ACO.Es.type;
A(3,2)=PROP.ACO.Es.parest1;
A(3,3)=PROP.ACO.Es.parest2;

[B]=pdf(A, RANDON);

PROP.ACO.fyV(m) = B(1);       % Tensão de escoamento do aço da armardua longitudinal, kN/m2
PROP.ACO.fywV(m)= B(1);       % Tensão de escoamento do aço da armardua transversal,kN/m2
PROP.ACO.rsV(m) = B(2);       % Peso específico do aço, kgcm3
PROP.ACO.EsV(m) = B(3);       % Módulo de elasticidade longitudinal do aço, kN/m2
% Calcular através da matriz de covariância
%PROP.ACO.eyV(m) = (DADOS.eym + (DADOS.sigma_ey*z(m)))*1000; % Def. específica de escoamento do aço, admensional

% PROPRIEDADES DO CONCRETO

A=zeros(6,3);

A(1,1)=PROP.CONC.RESCOMP.type;
A(1,2)=PROP.CONC.RESCOMP.parest1;
A(1,3)=PROP.CONC.RESCOMP.parest2;
A(2,1)=PROP.CONC.PESOESP.type;
A(2,2)=PROP.CONC.PESOESP.parest1;
A(2,3)=PROP.CONC.PESOESP.parest2;
A(3,1)=PROP.CONC.Eci.type;
A(3,2)=PROP.CONC.Eci.parest1;
A(3,3)=PROP.CONC.Eci.parest2;
A(4,1)=PROP.CONC.Ecs.type;
A(4,2)=PROP.CONC.Ecs.parest1;
A(4,3)=PROP.CONC.Ecs.parest2;
A(5,1)=PROP.CONC.POISSON.type;
A(5,2)=PROP.CONC.POISSON.parest1;
A(5,3)=PROP.CONC.POISSON.parest2;
A(6,1)=PROP.CONC.PHI.type;
A(6,2)=PROP.CONC.PHI.parest1;
A(6,3)=PROP.CONC.PHI.parest2;

[B]=pdf(A, z);

PROP.CONC.fccV(m)=B(1);   % Resistência à compressão do concreto, kN/m2
% Calcular através da matriz de covariância
% PROP.CONC.fctV(m) = DADOS.fctm + (DADOS.sigma_fct*z(m));   % Resistência à tração do concreto, kN/m2
% PROP.CONC.finfV(m) = 0.7*PROP.CONC.fctV(m);                % Seria a resistência à tração inferior? mudar o nnome da varriável para fctinfV, kN/m2
% PROP.CONC.fbV(m)  = DADOS.fbm + (DADOS.sigma_fb*z(m));     % Tensão de aderância entre o concreto e o aço, kN/m2
PROP.CONC.rocV(m)=B(2);  %kN/m3
PROP.CONC.EciV(m)=B(3);  %kN/m2
PROP.CONC.EcsV(m)=B(4);  %kN/m2
PROP.CONC.ni(m)=B(5);
PROP.CONC.phi(m)=B(6);