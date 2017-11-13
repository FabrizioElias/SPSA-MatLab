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

global m

% 2.1.3 - INÍCIO DO PROCESSO DE MONTE CARLO
disp('2. INÍCIO DO PROCESSO DE MONTE CARLO')
for m=1:DADOS.NMC
    
    if DADOS.op_exec==1 || DADOS.op_exec==2
        disp(['Análise ',num2str(m),' de ',num2str(DADOS.NMC)])
    end
% 2.1.3.1 - ANÁLISE ESTRUTURAL
    if DADOS.op_simulador==1  
        [MOMENTO, CORTANTE, NORMAL, VIGA, PILAR, DADOS, PAR, ELEMENTOS, TRANSX, TRANSZ, ROTACAO]=PorticoPlano(CORTANTE,...
            MOMENTO, NORMAL, TRANSX, TRANSZ, ROTACAO, DADOS, PORTICO, ELEMENTOS, VIGA, PILAR,PAR, ESTRUTURAL, CARGASOLO);
    else
        [esf, CORTANTE, MOMENTO, NORMAL]=SimulaFEAP(PORTICO, ELEMENTOS, DADOS);
    end
% 2.1.3.2 - DIMENSIONAMENTO DOS ELEMENTOS ESTRUTURAIS   
    if DADOS.op_concdesing==1
        [PILARresult, VIGAresult]=desingMC(PORTICO, ELEMENTOS, DADOS, CORTANTE, MOMENTO, NORMAL, VIGA, PILAR, PAR, ESTRUTURAL);
    end
% 2.1.3.3 - ANÁLISE ECONÔMICA
    if DADOS.op_ecoanalise==1
        % 2.1.3.3.1 - Custo
        % Cada vetor, abaixo descritos, terão NMC elementos contento o resultado
        % de cada iteração de Monte Carlo.
        % VIGAS
        [COST]=CostBeam(VIGAresult, PAR, COST);
        % PILARES
        [COST]=CostColumn(PILARresult, PAR, COST);
        % CUSTO TOTAL DA ESTRUTURA
        COST.total(m)=COST.CVA(m)+COST.CVC(m)+COST.CVF(m)+COST.CPA(m)+COST.CPC(m)+COST.CPF(m);
        % 2.1.3.4 - Cálculo do VPL
        VPL=vpl(COST, FLUXOCAIXA, DADOS, VPL);    
    end
% 2.1.3.4 - ANÁLISE ESTATÍSTICA DOS DESLOCAMENTOS E ESFORÇOS INTERNOS
end