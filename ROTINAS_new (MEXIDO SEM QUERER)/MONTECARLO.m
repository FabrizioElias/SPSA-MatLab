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

global m

% 2.1.3 - IN�CIO DO PROCESSO DE MONTE CARLO
disp('2. IN�CIO DO PROCESSO DE MONTE CARLO')
for m=1:DADOS.NMC
    
    if DADOS.op_exec==1 || DADOS.op_exec==2
        disp(['An�lise ',num2str(m),' de ',num2str(DADOS.NMC)])
    end
% 2.1.3.1 - AN�LISE ESTRUTURAL
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
% 2.1.3.3 - AN�LISE ECON�MICA
    if DADOS.op_ecoanalise==1
        % 2.1.3.3.1 - Custo
        % Cada vetor, abaixo descritos, ter�o NMC elementos contento o resultado
        % de cada itera��o de Monte Carlo.
        % VIGAS
        [COST]=CostBeam(VIGAresult, PAR, COST);
        % PILARES
        [COST]=CostColumn(PILARresult, PAR, COST);
        % CUSTO TOTAL DA ESTRUTURA
        COST.total(m)=COST.CVA(m)+COST.CVC(m)+COST.CVF(m)+COST.CPA(m)+COST.CPC(m)+COST.CPF(m);
        % 2.1.3.4 - C�lculo do VPL
        VPL=vpl(COST, FLUXOCAIXA, DADOS, VPL);    
    end
% 2.1.3.4 - AN�LISE ESTAT�STICA DOS DESLOCAMENTOS E ESFOR�OS INTERNOS
end