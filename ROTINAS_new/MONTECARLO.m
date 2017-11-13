function [ELEMENTOS, COST, VPL, PAR, TRANSX, TRANSZ, ROTACAO, MOMENTO, CORTANTE, NORMAL] = MONTECARLO(DADOS, COST, VPL, ...
        PAR, ELEMENTOS, PORTICO, VIGA, PILAR, FLUXOCAIXA, ESTRUTURAL, CORTANTE, MOMENTO, NORMAL, TRANSX, TRANSZ, ROTACAO, CARGASOLO)
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
% Cria um vetor para cada vari�vel aleat�ria com NMC elementos.

% O processamento da estrutura poder� ser feito atrav�s do FEAP (op_sim=0)
% ou atrav�s da rotina em MATLAB PorticoPlano.m (op_sim=1).

% Modelagem utilizando o FEAP:
    % Monta o arquivo de simula��o atrav�s de MontafileS.m.
    % Chama o Feap e informa o arquivo de entrada (arquivo de simulacao)
    % preparado em MontafileS.m. L� os esfor�os(normal,cortante e momento)
    % do arquivo de sa�da do Feap atrav�s de Le_SaidaFEAP.m. Chama os 
    % modelos de otimiza��o e calcula o valor da fun��o objetivo
    
% Modelagem utilizando o PorticoPlano.m
    % Atrav�s do arquivo de entreda PortINPUT.txt o p�rtico plano �
    % modelado as esfor�os internos obtidos � partir da sub-rotina
    % solver.m. Tr�s outras sub-rotinas, chamadas na sequ�ncia, calculam o
    % momento fletor (bend.m), esfor�o cortante (shear.m) e esfor�o normal
    % (axial.). A partir dos esfor�os internos as rotinas beam.m e clumn.m
    % dimensionam e estimam os consumo de material das vigas e pilares
    % respectivamente.
% -------------------------------------------------------------------------
% Criada      29-Novembro-2011              NILMA ANDRADE
% Modificada  12-junho-2015                 S�RGIO MARQUES
% -------------------------------------------------------------------------
% 1-DEFINI��O DAS VARI�VEIS GLOBAIS
global m

ELEMENTOS.dp=ELEMENTOS.cov.*ELEMENTOS.secao;

[ESTRUTURAL]=reorder(PORTICO, VIGA, ELEMENTOS);

% AMOSTRAGEM DAS VARI�VEIS ALEAT�RIAS
if DADOS.op_exec==1
    disp('2. AMOSTRAGEM DAS VARI�VEIS ALEAT�RIAS')
    disp(' ')
end
% Par�metros econ�micos
[PAR]=economicpar(PAR, DADOS);
% Par�metros f�sicos
[PAR]=phisicalpar(PAR, DADOS);
% Par�metros geom�tricos
[ELEMENTOS]=geometricalprop(DADOS, ELEMENTOS, PORTICO);
% Carregamentos atuantes
[PORTICO]=loads(DADOS, PORTICO);
% Cria��o da "structure" cost, onde ir� armazenar o custo de cada insumo da
% estrutura a ser otimizada.
% SPA_V - Somat�rio do peso de a�o de todas as vigas do p�rtico.
% SVC_V - Somat�rio do volume de concreto de todas as vigas do p�rtico
% SForma_V - Somat�rio da �rea de forma de toas as vigas do p�rtico
% CVA - Custo do a�o utilizado em todas as vigas
% CVC - Custo do concreto utilizado em todas as vigas
% CVF - Custo da forma utilizado em todas as vigas
% SPA_P - Somat�rio do peso de a�o de todos os pilares
% SVC_P - Somat�rio do volume de concreto de todos os pilares
% SForma_P - Somat�rio da �rea de forma de todos os pilares
% CPA - Custo de a�o dos pilares
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

% % CLASSIFICA��O DOS ELEMENTOS
% [VIGA, PILAR, DADOS]=Classifica_elem(DADOS, PORTICO, ELEMENTOS, VIGA, PILAR);

% 2 - IN�CIO DO PROCESSO DE MONTE CARLO
if DADOS.op_exec==1
    disp('3. IN�CIO DO PROCESSO DE MONTE CARLO')
    disp(' ')
end
for m=1:DADOS.NMC
    % S� ser� mostrado na tela o n�mero da itera��o na op��o de simula��o
    % simples. 
    if DADOS.op_exec==1
        disp(['An�lise ',num2str(m),' de ',num2str(DADOS.NMC)])
    end
%     %GEOMETRIA
%     [ELEMENTOS]=Calc_geom(PORTICO, ELEMENTOS, PAR, DADOS);
%     % CLASSIFICA��O DOS ELEMENTOS
%     [VIGA, PILAR, DADOS]=Classifica_elem(DADOS, PORTICO, ELEMENTOS, VIGA, PILAR);
% 2.1 - SIMULA��O DA ESTRUTURA
    if DADOS.op_simulador==1  
        [MOMENTO, CORTANTE, NORMAL, VIGA, PILAR, DADOS, PAR, ELEMENTOS, TRANSX, TRANSZ, ROTACAO]=PorticoPlano(CORTANTE, MOMENTO, NORMAL, TRANSX, TRANSZ, ROTACAO, DADOS, PORTICO, ELEMENTOS, VIGA, PILAR, PAR, ESTRUTURAL, CARGASOLO);
    else
        [CORTANTE, MOMENTO, NORMAL]=SimulaFEAP(PORTICO, ELEMENTOS, DADOS);
    end
% 2.2 - DIMENSIONAMENTO DOS ELEMENTOS ESTRUTURAIS   
%--------------------------------- VIGAS ---------------------------------%
    [PILARresult, VIGAresult]=desingMC(PORTICO, ELEMENTOS, DADOS, CORTANTE, MOMENTO, NORMAL, VIGA, PILAR, PAR, ESTRUTURAL, TRANSX);

% 2.3 - C�LCULO DO CUSTO DE CADA INSUMO
% Cada vetor, abaixo descritos, ter�o NMC elementos contento o resultado
% de cada itera��o de Monte Carlo.
%--------------------------------- VIGAS ---------------------------------%
    [COST]=CostBeam(VIGAresult, PAR, COST);
%-------------------------------- PILARES---------------------------------%
    [COST]=CostColumn(PILARresult, PAR, COST);
%----------------------- CUSTO TOTAL DA ESTRUTURA ------------------------%
    COST.total(m)=COST.CVA(m)+COST.CVC(m)+COST.CVF(m)+COST.CPA(m)+COST.CPC(m)+COST.CPF(m);
    
% 2.4 - C�LCULO DO VPL DO EMPREENDIMENTO
   
    if m==1    
        VPL=zeros(1,DADOS.NMC);
        VPL=vpl(COST, FLUXOCAIXA, DADOS, VPL);
    else
        VPL=vpl(COST, FLUXOCAIXA, DADOS, VPL);
    end 
end