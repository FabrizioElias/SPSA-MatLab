function [ELEMENTOS, COST, VPL, PAR, TRANSX, TRANSZ, ROTACAO, MOMENTO, CORTANTE, NORMAL] = MONTECARLO(DADOS, COST, VPL, ...
        PAR, ELEMENTOS, PORTICO, VIGA, PILAR, FLUXOCAIXA, ESTRUTURAL, CORTANTE, MOMENTO, NORMAL, TRANSX, TRANSZ, ROTACAO, CARGASOLO)
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
% Cria um vetor para cada variável aleatória com NMC elementos.

% O processamento da estrutura poderá ser feito através do FEAP (op_sim=0)
% ou através da rotina em MATLAB PorticoPlano.m (op_sim=1).

% Modelagem utilizando o FEAP:
    % Monta o arquivo de simulação através de MontafileS.m.
    % Chama o Feap e informa o arquivo de entrada (arquivo de simulacao)
    % preparado em MontafileS.m. Lê os esforços(normal,cortante e momento)
    % do arquivo de saída do Feap através de Le_SaidaFEAP.m. Chama os 
    % modelos de otimização e calcula o valor da função objetivo
    
% Modelagem utilizando o PorticoPlano.m
    % Através do arquivo de entreda PortINPUT.txt o pórtico plano é
    % modelado as esforços internos obtidos à partir da sub-rotina
    % solver.m. Três outras sub-rotinas, chamadas na sequência, calculam o
    % momento fletor (bend.m), esforço cortante (shear.m) e esforço normal
    % (axial.). A partir dos esforços internos as rotinas beam.m e clumn.m
    % dimensionam e estimam os consumo de material das vigas e pilares
    % respectivamente.
% -------------------------------------------------------------------------
% Criada      29-Novembro-2011              NILMA ANDRADE
% Modificada  12-junho-2015                 SÉRGIO MARQUES
% -------------------------------------------------------------------------
% 1-DEFINIÇÃO DAS VARIÁVEIS GLOBAIS
global m

ELEMENTOS.dp=ELEMENTOS.cov.*ELEMENTOS.secao;

[ESTRUTURAL]=reorder(PORTICO, VIGA, ELEMENTOS);

% AMOSTRAGEM DAS VARIÁVEIS ALEATÓRIAS
if DADOS.op_exec==1
    disp('2. AMOSTRAGEM DAS VARIÁVEIS ALEATÓRIAS')
    disp(' ')
end
% Parâmetros econômicos
[PAR]=economicpar(PAR, DADOS);
% Parâmetros físicos
[PAR]=phisicalpar(PAR, DADOS);
% Parâmetros geométricos
[ELEMENTOS]=geometricalprop(DADOS, ELEMENTOS, PORTICO);
% Carregamentos atuantes
[PORTICO]=loads(DADOS, PORTICO);
% Criação da "structure" cost, onde irá armazenar o custo de cada insumo da
% estrutura a ser otimizada.
% SPA_V - Somatório do peso de aço de todas as vigas do pórtico.
% SVC_V - Somatório do volume de concreto de todas as vigas do pórtico
% SForma_V - Somatório da área de forma de toas as vigas do pórtico
% CVA - Custo do aço utilizado em todas as vigas
% CVC - Custo do concreto utilizado em todas as vigas
% CVF - Custo da forma utilizado em todas as vigas
% SPA_P - Somatório do peso de aço de todos os pilares
% SVC_P - Somatório do volume de concreto de todos os pilares
% SForma_P - Somatório da área de forma de todos os pilares
% CPA - Custo de aço dos pilares
% CPC - Custo de concreto dos pilares
% CPF - Custo de forma dos pilares
COST.SPA_V=zeros(1,DADOS.NMC);
COST.SVC_V=zeros(1,DADOS.NMC);
COST.SForma_V=zeros(1,DADOS.NMC);
COST.CVA=zeros(1,DADOS.NMC);
COST.CVC=zeros(1,DADOS.NMC);
COST.CVF=zeros(1,DADOS.NMC);
COST.SPA_P=zeros(1,DADOS.NMC);
COST.SVC_P=zeros(1,DADOS.NMC);
COST.SForma_P=zeros(1,DADOS.NMC);
COST.CPA=zeros(1,DADOS.NMC);
COST.CPC=zeros(1,DADOS.NMC);
COST.CPF=zeros(1,DADOS.NMC);

% % CLASSIFICAÇÃO DOS ELEMENTOS
% [VIGA, PILAR, DADOS]=Classifica_elem(DADOS, PORTICO, ELEMENTOS, VIGA, PILAR);

% 2 - INÍCIO DO PROCESSO DE MONTE CARLO
if DADOS.op_exec==1
    disp('3. INÍCIO DO PROCESSO DE MONTE CARLO')
    disp(' ')
end
for m=1:DADOS.NMC
    % Só será mostrado na tela o número da iteração na opção de simulação
    % simples. 
    if DADOS.op_exec==1
        disp(['Análise ',num2str(m),' de ',num2str(DADOS.NMC)])
    end
%     %GEOMETRIA
%     [ELEMENTOS]=Calc_geom(PORTICO, ELEMENTOS, PAR, DADOS);
%     % CLASSIFICAÇÃO DOS ELEMENTOS
%     [VIGA, PILAR, DADOS]=Classifica_elem(DADOS, PORTICO, ELEMENTOS, VIGA, PILAR);
% 2.1 - SIMULAÇÃO DA ESTRUTURA
    if DADOS.op_simulador==1  
        [MOMENTO, CORTANTE, NORMAL, VIGA, PILAR, DADOS, PAR, ELEMENTOS, TRANSX, TRANSZ, ROTACAO]=PorticoPlano(CORTANTE, MOMENTO, NORMAL, TRANSX, TRANSZ, ROTACAO, DADOS, PORTICO, ELEMENTOS, VIGA, PILAR, PAR, ESTRUTURAL, CARGASOLO);
    else
        [CORTANTE, MOMENTO, NORMAL]=SimulaFEAP(PORTICO, ELEMENTOS, DADOS);
    end
% 2.2 - DIMENSIONAMENTO DOS ELEMENTOS ESTRUTURAIS   
%--------------------------------- VIGAS ---------------------------------%
    [PILARresult, VIGAresult]=desingMC(PORTICO, ELEMENTOS, DADOS, CORTANTE, MOMENTO, NORMAL, VIGA, PILAR, PAR, ESTRUTURAL, TRANSX);

% 2.3 - CÁLCULO DO CUSTO DE CADA INSUMO
% Cada vetor, abaixo descritos, terão NMC elementos contento o resultado
% de cada iteração de Monte Carlo.
%--------------------------------- VIGAS ---------------------------------%
    [COST]=CostBeam(VIGAresult, PAR, COST);
%-------------------------------- PILARES---------------------------------%
    [COST]=CostColumn(PILARresult, PAR, COST);
%----------------------- CUSTO TOTAL DA ESTRUTURA ------------------------%
    COST.total(m)=COST.CVA(m)+COST.CVC(m)+COST.CVF(m)+COST.CPA(m)+COST.CPC(m)+COST.CPF(m);
    
% 2.4 - CÁLCULO DO VPL DO EMPREENDIMENTO
   
    if m==1    
        VPL=zeros(1,DADOS.NMC);
        VPL=vpl(COST, FLUXOCAIXA, DADOS, VPL);
    else
        VPL=vpl(COST, FLUXOCAIXA, DADOS, VPL);
    end 
end