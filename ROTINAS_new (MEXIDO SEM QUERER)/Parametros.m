function [PARECON, PROP]=Parametros(PARECON, PROP, DADOS, RANDON)
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
% Calcula os par�metros econ�imcos a serem utilizados na otimiza��o.
% Assume-se uma distribui��o Gaussiana
% -------------------------------------------------------------------------
% Criada      15-abril-2016                 S�RGIO MARQUES
% -------------------------------------------------------------------------

global m
    
% PAR�METROS ECON�MICOS
PARECON.Custo_acoV(m)=DADOS.CustoM_aco+(DADOS.sigma_aco*RANDON.normal(m));   %R$/kg
PARECON.Custo_conV(m)=DADOS.CustoM_con+(DADOS.sigma_con*RANDON.normal(m));   %R$/m3
PARECON.Custo_forV(m)=DADOS.CustoM_for+(DADOS.sigma_for*RANDON.normal(m));   %R$/m2

%PROPRIEDADES DO A�O - Vari�veis aleat�rias

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

PROP.ACO.fyV(m) = B(1);       % Tens�o de escoamento do a�o da armardua longitudinal, kN/m2
PROP.ACO.fywV(m)= B(1);       % Tens�o de escoamento do a�o da armardua transversal,kN/m2
PROP.ACO.rsV(m) = B(2);       % Peso espec�fico do a�o, kgcm3
PROP.ACO.EsV(m) = B(3);       % M�dulo de elasticidade longitudinal do a�o, kN/m2
% Calcular atrav�s da matriz de covari�ncia
%PROP.ACO.eyV(m) = (DADOS.eym + (DADOS.sigma_ey*z(m)))*1000; % Def. espec�fica de escoamento do a�o, admensional

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

PROP.CONC.fccV(m)=B(1);   % Resist�ncia � compress�o do concreto, kN/m2
% Calcular atrav�s da matriz de covari�ncia
% PROP.CONC.fctV(m) = DADOS.fctm + (DADOS.sigma_fct*z(m));   % Resist�ncia � tra��o do concreto, kN/m2
% PROP.CONC.finfV(m) = 0.7*PROP.CONC.fctV(m);                % Seria a resist�ncia � tra��o inferior? mudar o nnome da varri�vel para fctinfV, kN/m2
% PROP.CONC.fbV(m)  = DADOS.fbm + (DADOS.sigma_fb*z(m));     % Tens�o de ader�ncia entre o concreto e o a�o, kN/m2
PROP.CONC.rocV(m)=B(2);  %kN/m3
PROP.CONC.EciV(m)=B(3);  %kN/m2
PROP.CONC.EcsV(m)=B(4);  %kN/m2
PROP.CONC.ni(m)=B(5);
PROP.CONC.phi(m)=B(6);