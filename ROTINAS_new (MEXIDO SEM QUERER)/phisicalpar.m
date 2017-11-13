function [PAR]=phisicalpar(PAR, DADOS)
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
% Calcula os par�metros f�sicos dos materiais a serem utilizados na 
% otimiza��o.
% -------------------------------------------------------------------------
% Criada      26-abril-2016                 S�RGIO MARQUES
% -------------------------------------------------------------------------

%PROPRIEDADES DO A�O CA-50 - Vari�veis aleat�rias - SER�O AMOSTRADAS APENAS
%SE A OP��O PARA DIMENSIONAMENTO DOS ELEMENTOS ESTRUTURAIS ESTIVER ATIVADA.
%ISSO SERVE PARA ECONOMIZAR MEM�RIA
%if DADOS.op_concdesing==1
    % Limite de elasticidade
    A=zeros(1,3);
    A(1,1)=PAR.ACO.RESTRAC.type;
    A(1,2)=PAR.ACO.RESTRAC.parest1;
    A(1,3)=PAR.ACO.RESTRAC.parest2;
    [B]=pdf(A, DADOS);
    PAR.ACO.fyV=B;       % Tens�o de escoamento do a�o da armardua longitudinal, kN/m2
    PAR.ACO.fywV=B;      % Tens�o de escoamento do a�o da armardua transversal,kN/m2
    % Peso espec�fico do a�o
    A(1,1)=PAR.ACO.PESOESP.type;
    A(1,2)=PAR.ACO.PESOESP.parest1;
    A(1,3)=PAR.ACO.PESOESP.parest2;
    [B]=pdf(A, DADOS);
    PAR.ACO.rosV=B;       % Peso espec�fico do a�o, kN/m3
    % M�dulo de elasticidade
    A(1,1)=PAR.ACO.Es.type;
    A(1,2)=PAR.ACO.Es.parest1;
    A(1,3)=PAR.ACO.Es.parest2;
    [B]=pdf(A, DADOS);
    PAR.ACO.EsV=B;       % M�dulo de elasticidade longitudinal do a�o, kN/m2
    % Correlacionado
    PAR.ACO.eyV=PAR.ACO.fyV./PAR.ACO.EsV; % Def. espec�fica de escoamento do a�o, admensional
%end

% PROPRIEDADES DO CONCRETO
% Resist�ncia � compress�o
A(1,1)=PAR.CONC.RESCOMP.type;
A(1,2)=PAR.CONC.RESCOMP.parest1+PAR.CONC.DELTARESCOMP.parest1;
A(1,3)=PAR.CONC.RESCOMP.parest2;
[B]=pdf(A, DADOS);
PAR.CONC.fccV=B;   % Resist�ncia � compress�o do concreto, kN/m2
% % Par�metros do concreto correlacionados com a resit�ncia � compress�o
% PAR.CONC.fctV=0.21.*(PAR.CONC.fccV./1000).^(2/3)*1000;    % Resist�ncia � tra��o do concreto kN/m2
% PAR.CONC.fbdV=(DADOS.neta1*DADOS.neta2*DADOS.neta3).*PAR.CONC.fctV;    % Tens�o de ader�ncia entre o concreto e o a�o, kN/m2

% Peso espec�fico
A(1,1)=PAR.CONC.PESOESP.type;
A(1,2)=PAR.CONC.PESOESP.parest1;
A(1,3)=PAR.CONC.PESOESP.parest2;
[B]=pdf(A, DADOS);
PAR.CONC.rocV=B;  %kN/m3

% Peso espec�fico
A(1,1)=PAR.CONC.ALFATEMP.type;
A(1,2)=PAR.CONC.ALFATEMP.parest1;
A(1,3)=PAR.CONC.ALFATEMP.parest2;
[B]=pdf(A, DADOS);
PAR.CONC.alfaV=B;  %kN/m3


% % M�dulo de elasticidade tangente
% A(1,1)=PAR.CONC.Eci.type;
% A(1,2)=PAR.CONC.Eci.parest1;
% A(1,3)=PAR.CONC.Eci.parest2;
% [B]=pdf(A, DADOS);
% PAR.CONC.EciV=B;  %kN/m2
% % M�dulo de elasticidade secante
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

% % Coeficiente de flu�ncia
% A(1,1)=PAR.CONC.PHI.type;
% A(1,2)=PAR.CONC.PHI.parest1;
% A(1,3)=PAR.CONC.PHI.parest2;
% [B]=pdf(A, DADOS);
% PAR.CONC.phiV=B;
% % Deforma��o espec�fica de retra��o
% A(1,1)=PAR.CONC.EPSONcs.type;
% A(1,2)=PAR.CONC.EPSONcs.parest1;
% A(1,3)=PAR.CONC.EPSONcs.parest2;
% [B]=pdf(A, DADOS);
% PAR.CONC.epsonscV=B;

%PROPRIEDADES DO A�O LAMINADO - Vari�veis aleat�rias
% Limite de elasticidade
A=zeros(1,3);
A(1,1)=PAR.STEEL.RESTRAC.type;
A(1,2)=PAR.STEEL.RESTRAC.parest1;
A(1,3)=PAR.STEEL.RESTRAC.parest2;
[B]=pdf(A, DADOS);
PAR.STEEL.fyV=B;       % Tens�o de escoamento do a�o da armardua longitudinal, kN/m2

% Peso espec�fico
A(1,1)=PAR.STEEL.PESOESP.type;
A(1,2)=PAR.STEEL.PESOESP.parest1;
A(1,3)=PAR.STEEL.PESOESP.parest2;
[B]=pdf(A, DADOS);
PAR.STEEL.rosV=B;       % Peso espec�fico do a�o, kgf/cm3

% M�dulo de elasticidade
A(1,1)=PAR.STEEL.Es.type;
A(1,2)=PAR.STEEL.Es.parest1;
A(1,3)=PAR.STEEL.Es.parest2;
[B]=pdf(A, DADOS);
PAR.STEEL.EsV=B;       % M�dulo de elasticidade longitudinal do a�o, kN/m2
