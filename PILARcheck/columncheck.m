function [PILAR]=columncheck(PORTICO, DADOS, PILAR, PAR, ESTRUTURAL, COMBColumn)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIÊNCIAS
% PROGRAMA DE PÓS-GRADUAÇÃO EM ENGENHARIA CIVIL        - ÁREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELEÇÃO DE  MÉDIA FIDELIDADE  PARA  ANÁLISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO.
% ALUNO       Sérgio José Priori Jovino Marques Filho
% ORIENTADOR  Prof. Ézio da Rocha Araújo
% -------------------------------------------------------------------------
% DESCRIÇÃO
% Rotina para gerenciar o dimensionamento e detalhamento de pilares
% submetidos à flexocompressão normal.
% -------------------------------------------------------------------------
% MODIFICAÇÕES:         
%--------------------------------------------------------------------------
% VARIÁVEIS DE ENTRADA: --
% VARIÁVEIS DE SAÍDA:   PILARin: "structure" contendo as variáveis necessá-
% rias ao algoritmo de detalhamento do pilar - column.m 
%--------------------------------------------------------------------------
% CRIADA EM 21-fevereiro-2016
% -------------------------------------------------------------------------

% ENTRADA DE DADOS
% ESFORÇOS SOLICITANTES - virão da análise estocástica
%[PILAR]=columnIntEff(MOMENTO, NORMAL, DADOS, ESTRUTURAL, PILAR);

% Propriedades físicas dos materiais
PILAR.Es=PAR.ACO.EsV;        % Módulo de elasticidade do aço CA-50
PILAR.fyd=PAR.ACO.fyV;         % Tensão última do aço CA-50
PILAR.Ec=PAR.CONC.EcsV;         % Módulo de elasticidade secante do concreto
PILAR.fcd=PAR.CONC.fccV;          % Resistência à compressão média do concreto
PILAR.sigmacd=0.85*PILAR.fcd;
PILAR.epsonyd=1000*PILAR.fyd/PILAR.Es; % <-- Multiplicação por 1000 para que a unidade fique em termos de "por mil"
PILAR.cob=DADOS.cobp;
% Propriedades geométricas do encontro
PILAR.L= PORTICO.coord(ESTRUTURAL.D(2,2),2)-PORTICO.coord(ESTRUTURAL.D(2,1),2);                  % Altura do encontro
PILAR.b=PILAR.arranjo(1);                  % Largura da seção transversal
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
% Altura da seção transversal
PILAR.k=PILAR.arranjo(9);                  % Cte. comprimento de flambagem
PILAR.yT=PILAR.hv./2;         % ordenada do topo da seção transversal
PILAR.yB=-PILAR.hv./2;        % ordenada da base da seção transversal
PILAR.A=PILAR.b*PILAR.h;          % Área
PILAR.I=PILAR.b*PILAR.h^3/12;     % Momento de inércia
PILAR.Lef=PILAR.k*PILAR.L;        % Comprimento efetivo de flambagem
PILAR.i=(PILAR.I/PILAR.A)^(1/2);  % Raio de giração
PILAR.lambda=PILAR.Lef/PILAR.i;   % Índice de esbeltez do pilar   
% Distribuição das armaduras na seção
PILAR.ncol=PILAR.arranjo(5);     % Quantidade de barras distribuidas ao longo da base da seção
PILAR.ncam=PILAR.arranjo(6);      % Quantidade de barras distribuídas ao longo da altura da seção
PILAR.diambarra=PILAR.arranjo(7);                     % Diâmetro da armadura longitudinal
PILAR.diamestribo=PILAR.arranjo(8);     % Diâmetro da armadura transversal


%Verificação da seção transversal à ruptura - 12 é a quantidade de
%combinações que foram feitas
PILAR.tagELU=zeros(12,DADOS.NMC);
PILAR.DELTAM=zeros(12,DADOS.NMC);
PILAR.hutil=zeros(1,DADOS.NMC);
PILAR.d=zeros(12,DADOS.NMC);
% figure
for j=1:DADOS.NMC
    % Cálculo do CG das barras e áreas de aço.
    [PILAR]=column3(PILAR, j);
    % Cálculo do diagrama de iteração   
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

% Cálculo da probabilidade de falha
p=sum(PILAR.tagELU);
k=0;
for i=1:DADOS.NMC
    if p(i)==0
        k=k+1;
    end
end
PILAR.Pf=(DADOS.NMC-k)/DADOS.NMC;


