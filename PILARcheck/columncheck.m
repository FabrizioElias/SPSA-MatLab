function [PILAR]=columncheck(PORTICO, DADOS, PILAR, PAR, ESTRUTURAL, COMBColumn)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCI�NCIAS
% PROGRAMA DE P�S-GRADUA��O EM ENGENHARIA CIVIL        - �REA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELE��O DE  M�DIA FIDELIDADE  PARA  AN�LISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO.
% ALUNO       S�rgio Jos� Priori Jovino Marques Filho
% ORIENTADOR  Prof. �zio da Rocha Ara�jo
% -------------------------------------------------------------------------
% DESCRI��O
% Rotina para gerenciar o dimensionamento e detalhamento de pilares
% submetidos � flexocompress�o normal.
% -------------------------------------------------------------------------
% MODIFICA��ES:         
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: --
% VARI�VEIS DE SA�DA:   PILARin: "structure" contendo as vari�veis necess�-
% rias ao algoritmo de detalhamento do pilar - column.m 
%--------------------------------------------------------------------------
% CRIADA EM 21-fevereiro-2016
% -------------------------------------------------------------------------

% ENTRADA DE DADOS
% ESFOR�OS SOLICITANTES - vir�o da an�lise estoc�stica
%[PILAR]=columnIntEff(MOMENTO, NORMAL, DADOS, ESTRUTURAL, PILAR);

% Propriedades f�sicas dos materiais
PILAR.Es=PAR.ACO.EsV;        % M�dulo de elasticidade do a�o CA-50
PILAR.fyd=PAR.ACO.fyV;         % Tens�o �ltima do a�o CA-50
PILAR.Ec=PAR.CONC.EcsV;         % M�dulo de elasticidade secante do concreto
PILAR.fcd=PAR.CONC.fccV;          % Resist�ncia � compress�o m�dia do concreto
PILAR.sigmacd=0.85*PILAR.fcd;
PILAR.epsonyd=1000*PILAR.fyd/PILAR.Es; % <-- Multiplica��o por 1000 para que a unidade fique em termos de "por mil"
PILAR.cob=DADOS.cobp;
% Propriedades geom�tricas do encontro
PILAR.L= PORTICO.coord(ESTRUTURAL.D(2,2),2)-PORTICO.coord(ESTRUTURAL.D(2,1),2);                  % Altura do encontro
PILAR.b=PILAR.arranjo(1);                  % Largura da se��o transversal
PILAR.sigmab=PILAR.arranjo(2);
PILAR.h=PILAR.arranjo(3);  
PILAR.sigmah=PILAR.arranjo(4);
if DADOS.op_exec==0
    PILAR.sigmab=0;
    PILAR.sigmah=0;
end
z=randn(1,DADOS.NMC);
PILAR.bv=PILAR.b+PILAR.sigmab*z;
PILAR.hv=PILAR.h+PILAR.sigmah*z;
% Altura da se��o transversal
PILAR.k=PILAR.arranjo(9);                  % Cte. comprimento de flambagem
PILAR.yT=PILAR.hv./2;         % ordenada do topo da se��o transversal
PILAR.yB=-PILAR.hv./2;        % ordenada da base da se��o transversal
PILAR.A=PILAR.b*PILAR.h;          % �rea
PILAR.I=PILAR.b*PILAR.h^3/12;     % Momento de in�rcia
PILAR.Lef=PILAR.k*PILAR.L;        % Comprimento efetivo de flambagem
PILAR.i=(PILAR.I/PILAR.A)^(1/2);  % Raio de gira��o
PILAR.lambda=PILAR.Lef/PILAR.i;   % �ndice de esbeltez do pilar   
% Distribui��o das armaduras na se��o
PILAR.ncol=PILAR.arranjo(5);     % Quantidade de barras distribuidas ao longo da base da se��o
PILAR.ncam=PILAR.arranjo(6);      % Quantidade de barras distribu�das ao longo da altura da se��o
PILAR.diambarra=PILAR.arranjo(7);                     % Di�metro da armadura longitudinal
PILAR.diamestribo=PILAR.arranjo(8);     % Di�metro da armadura transversal


%Verifica��o da se��o transversal � ruptura - 12 � a quantidade de
%combina��es que foram feitas
PILAR.tagELU=zeros(12,DADOS.NMC);
PILAR.DELTAM=zeros(12,DADOS.NMC);
PILAR.hutil=zeros(1,DADOS.NMC);
PILAR.d=zeros(12,DADOS.NMC);
% figure
for j=1:DADOS.NMC
    % C�lculo do CG das barras e �reas de a�o.
    [PILAR]=column3(PILAR, j);
    % C�lculo do diagrama de itera��o   
    [PILAR]=column4(PILAR, j);
    [PILAR]=plotdiag(PILAR, COMBColumn);
    for i=1:12
        COMB=COMBColumn(:,:,i);
        PILAR.Nd=-COMB(j,1);
        PILAR.NId=-COMB(j,1)/(PILAR.fcd(j)*PILAR.bv(j)*PILAR.hv(j));
        PILAR.Md=abs(COMB(j,2));  
        PILAR.MId=abs(COMB(j,2)/(PILAR.bv(j)*PILAR.hutil(j)^2*PILAR.fcd(j)));
%        plot(PILAR.Md,PILAR.Nd,'o')
        plot(PILAR.MId, PILAR.NId,'o','MarkerSize',10)
%         pause(0.5);
        [PILAR]=column5adim(PILAR, DADOS, i, j);     
    end 
end

% C�lculo da probabilidade de falha
p=sum(PILAR.tagELU);
k=0;
for i=1:DADOS.NMC
    if p(i)==0
        k=k+1;
    end
end
PILAR.Pf=(DADOS.NMC-k)/DADOS.NMC;


