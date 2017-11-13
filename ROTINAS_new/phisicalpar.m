function [PAR]=phisicalpar(PAR, DADOS)
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
% Calcula os parâmetros físicos dos materiais a serem utilizados na 
% otimização.
% -------------------------------------------------------------------------
% Criada      26-abril-2016                 SÉRGIO MARQUES
% -------------------------------------------------------------------------

%PROPRIEDADES DO AÇO CA-50 - Variáveis aleatórias - SERÃO AMOSTRADAS APENAS
%SE A OPÇÃO PARA DIMENSIONAMENTO DOS ELEMENTOS ESTRUTURAIS ESTIVER ATIVADA.
%ISSO SERVE PARA ECONOMIZAR MEMÓRIA
%if DADOS.op_concdesing==1
    % Limite de elasticidade
    A=zeros(1,3);
    A(1,1)=PAR.ACO.RESTRAC.type;
    A(1,2)=PAR.ACO.RESTRAC.parest1;
    A(1,3)=PAR.ACO.RESTRAC.parest2;
    [B]=pdf(A, DADOS);
    PAR.ACO.fyV=B;       % Tensão de escoamento do aço da armardua longitudinal, kN/m2
    PAR.ACO.fywV=B;      % Tensão de escoamento do aço da armardua transversal,kN/m2
    % Peso específico do aço
    A(1,1)=PAR.ACO.PESOESP.type;
    A(1,2)=PAR.ACO.PESOESP.parest1;
    A(1,3)=PAR.ACO.PESOESP.parest2;
    [B]=pdf(A, DADOS);
    PAR.ACO.rosV=B;       % Peso específico do aço, kN/m3
    % Módulo de elasticidade
    A(1,1)=PAR.ACO.Es.type;
    A(1,2)=PAR.ACO.Es.parest1;
    A(1,3)=PAR.ACO.Es.parest2;
    [B]=pdf(A, DADOS);
    PAR.ACO.EsV=B;       % Módulo de elasticidade longitudinal do aço, kN/m2
    % Correlacionado
    PAR.ACO.eyV=PAR.ACO.fyV./PAR.ACO.EsV; % Def. específica de escoamento do aço, admensional
%end

% PROPRIEDADES DO CONCRETO
% Resistência à compressão
A(1,1)=PAR.CONC.RESCOMP.type;
A(1,2)=PAR.CONC.RESCOMP.parest1+PAR.CONC.DELTARESCOMP.parest1;
A(1,3)=PAR.CONC.RESCOMP.parest2;
[B]=pdf(A, DADOS);
PAR.CONC.fccV=B;   % Resistência à compressão do concreto, kN/m2
% % Parâmetros do concreto correlacionados com a resitência à compressão
% PAR.CONC.fctV=0.21.*(PAR.CONC.fccV./1000).^(2/3)*1000;    % Resistência à tração do concreto kN/m2
% PAR.CONC.fbdV=(DADOS.neta1*DADOS.neta2*DADOS.neta3).*PAR.CONC.fctV;    % Tensão de aderância entre o concreto e o aço, kN/m2

% Peso específico
A(1,1)=PAR.CONC.PESOESP.type;
A(1,2)=PAR.CONC.PESOESP.parest1;
A(1,3)=PAR.CONC.PESOESP.parest2;
[B]=pdf(A, DADOS);
PAR.CONC.rocV=B;  %kN/m3

% Peso específico
A(1,1)=PAR.CONC.ALFATEMP.type;
A(1,2)=PAR.CONC.ALFATEMP.parest1;
A(1,3)=PAR.CONC.ALFATEMP.parest2;
[B]=pdf(A, DADOS);
PAR.CONC.alfaV=B;  %kN/m3


% % Módulo de elasticidade tangente
% A(1,1)=PAR.CONC.Eci.type;
% A(1,2)=PAR.CONC.Eci.parest1;
% A(1,3)=PAR.CONC.Eci.parest2;
% [B]=pdf(A, DADOS);
% PAR.CONC.EciV=B;  %kN/m2
% % Módulo de elasticidade secante
% A(1,1)=PAR.CONC.Ecs.type;
% A(1,2)=PAR.CONC.Ecs.parest1;
% A(1,3)=PAR.CONC.Ecs.parest2;
% [B]=pdf(A, DADOS);
% PAR.CONC.EcsV=B;  %kN/m2

% % Coeficiente de Poisson
% A(1,1)=PAR.CONC.POISSON.type;
% A(1,2)=PAR.CONC.POISSON.parest1;
% A(1,3)=PAR.CONC.POISSON.parest2;
% [B]=pdf(A, DADOS);
% PAR.CONC.niV=B;

% % Coeficiente de fluência
% A(1,1)=PAR.CONC.PHI.type;
% A(1,2)=PAR.CONC.PHI.parest1;
% A(1,3)=PAR.CONC.PHI.parest2;
% [B]=pdf(A, DADOS);
% PAR.CONC.phiV=B;
% % Deformação específica de retração
% A(1,1)=PAR.CONC.EPSONcs.type;
% A(1,2)=PAR.CONC.EPSONcs.parest1;
% A(1,3)=PAR.CONC.EPSONcs.parest2;
% [B]=pdf(A, DADOS);
% PAR.CONC.epsonscV=B;

%PROPRIEDADES DO AÇO LAMINADO - Variáveis aleatórias
% Limite de elasticidade
A=zeros(1,3);
A(1,1)=PAR.STEEL.RESTRAC.type;
A(1,2)=PAR.STEEL.RESTRAC.parest1;
A(1,3)=PAR.STEEL.RESTRAC.parest2;
[B]=pdf(A, DADOS);
PAR.STEEL.fyV=B;       % Tensão de escoamento do aço da armardua longitudinal, kN/m2

% Peso específico
A(1,1)=PAR.STEEL.PESOESP.type;
A(1,2)=PAR.STEEL.PESOESP.parest1;
A(1,3)=PAR.STEEL.PESOESP.parest2;
[B]=pdf(A, DADOS);
PAR.STEEL.rosV=B;       % Peso específico do aço, kgf/cm3

% Módulo de elasticidade
A(1,1)=PAR.STEEL.Es.type;
A(1,2)=PAR.STEEL.Es.parest1;
A(1,3)=PAR.STEEL.Es.parest2;
[B]=pdf(A, DADOS);
PAR.STEEL.EsV=B;       % Módulo de elasticidade longitudinal do aço, kN/m2
