% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIENCIAS
% PROGRAMA DE POS-GRADUACAO EM ENGENHARIA CIVIL        - AREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELECAO DE  MEDIA FIDELIDADE  PARA  ANALISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO
% ALUNO       S�rgio J. Priori J. Marques Filho
% ORIENTADOR  Prof. �zio da Rocha Ara�jo
% -------------------------------------------------------------------------
% DESCRICAO
% Fun��o principal. Chama as outras fun��es.
% % -----------------------------------------------------------------------
% MODIFICA��ES - S�rgio Marques
% 1. As rotinas n�o trabalham com vari�veis globais. Estas foram
% substituidas por "STRUCTURES" de forma a diminuir o tempo de
% processamento.
% -------------------------------------------------------------------------
% ADAPTA��O DA ROTINA DE DIEGO OLIVEIRA 30-Janeiro-2006
% Modificada      04-Agosto-2011              NILMA ANDRADE
% Modificada      13-Janeiro-2015             S�RGIO MARQUES   
% -------------------------------------------------------------------------
%
tic
clc
clear variables global
%text=(['EST-PORT3_ROD6b_NMC ',num2str(v(I))]);
% diary(text)
% O controle de geradores de n�meros rand�micos deve ser retirado ap�s a
% valida��o do c�digo
%rng('default')
fprintf('\n----------------------------------------------------------------\n');
fprintf('TESE DE DOUTORADO\n');
fprintf('MODELOS  DE SELECAO DE  MEDIA FIDELIDADE  PARA  ANALISE \n');
fprintf('DE  INCERTEZAS EM ESTRUTURAS DE CONCRETO ARMADO');
fprintf('\nALUNO      S�rgio J. Priori J. Marques Filho'); 
fprintf('\nORIENTADOR �zio da Rocha Araujo\n');
fprintf('------------------------------------------------------------------\n');
disp(' ')

global m

% 1 - ENTRADA DE DADOS
disp('1. LEITURA DOS ARQUIVOS DE ENTRADA')
disp(' ')
% 1.1- Leitura dos dados do Arquivo de entrada:
DADOS=InputDados;
% 1.2 - LEITURA DOS DADOS NECESS�RIOS � CRIA��O DO MODELO NUM�RICO
[PORTICO, ELEMENTOS, PAR, VIGA, PILAR, FLUXOCAIXA]=Le_Dados(DADOS);
% Plota o portico para visualiza��o
% for i=1:PORTICO.nnos
%     plot(PORTICO.coord(i,1),PORTICO.coord(i,2),'o')
%     hold on
% end
% 1.3 - C�LCULO DO COMPRIMENTO DE CADA ELEMENTOS
[PORTICO]=comp(PORTICO);
% 1.4 - C�CULO DO �NGULO QUE CADA ELEMENTO FAZ COM O EIXO X GLOBAL
[PORTICO]=angular(PORTICO);

% Caso a rotina autorun.m esteja sendo usada, aqui altera-se o NMC
%DADOS.NMC=v(I);

% 1.3 - CLASSIFICA��O DOS ELEMENTOS
[VIGA, PILAR, DADOS]=Classifica_elem(DADOS, PORTICO, ELEMENTOS, VIGA, PILAR);
% 1.4 - ALTERA��O DOS PAR�METROS F�SICOS DO CONCRETO
if DADOS.op_phisicalpar==0      % <-- FIB MC2010
    [PAR]=phisicalparFIBMC2010(PAR, VIGA);
elseif DADOS.op_phisicalpar==1  % <-- FIB NBR6118/2014
    [PAR]=phisicalparNBR(PAR, DADOS);
elseif DADOS.op_phisicalpar==2  % <-- FIB MC90
    [PAR]=phisicalparFIBMC90(PAR, VIGA, DADOS);
end 
%1.4 - "PSEUDO'AMOSTRAGEM DOS VALORES DAS VARI�VEIS ALEAT�RIAS - serve
% apenas para preencher as vari�veis com final "V" que s�o utilizadas nas
% demais rotinas desse c�digo. Esse artif�cio serve para que a mesma
% vari�vel possa ser utilizada em todas as rotinas sem que haja a
% necessidade de alter�-la.
if DADOS.op_exec==0
    DADOS.NMC=1;
    [PAR, ELEMENTOS]=desvpadzero(PAR, PORTICO, ELEMENTOS);
end 
% Par�metros econ�micos
[PAR]=economicpar(PAR, DADOS);
% Par�metros f�sicos
[PAR]=phisicalpar(PAR, DADOS);
% Par�metros geom�tricos
[ELEMENTOS]=geometricalprop(DADOS, ELEMENTOS, PORTICO);
% Carregamentos atuantes
[PORTICO]=loads(DADOS, PORTICO);
    
% 2 - EXECUCAO
% Opcao de Execucao do codigo
% 0 - Processamento do p�rtico plano
% 1 - Simulacao Simples
% 2 - Otimizacao 
% 3 - Analise de Sensibilidade

% 2.1 - MODELAGEM E PROCESSAMENTO DO P�RTICO PLANO
%--------------------------------------------------------------------------
if DADOS.op_exec==0
    disp('=================================================================')
    disp('                    PROCESSAMENTO DO P�RTICO PLANO')
    disp('=================================================================')
    % � vari�vel global "m" ser� atribu�do o valor m=1, uma vez que n�o haver� itera��es de Monte Carlo
    m=1;    
    
    [ESTRUTURAL]=reorder(PORTICO, VIGA, ELEMENTOS);
    
% 2.0 - PROCESSA O P�RTICO PLANO - PorticoPlano.m
    disp('2. OBTEN��O DOS ESFOR�OS INTERNOS VIA PorticoPlano.m')
    disp(' ')
    [MOMENTO, CORTANTE, NORMAL, VIGA, PILAR, DADOS, PAR, ELEMENTOS, TRANSX, TRANSZ, ROTACAO]=PorticoPlano(DADOS, PORTICO, ELEMENTOS, VIGA, PILAR,PAR, ESTRUTURAL);   
       
% 2.1 - DIMENSIONAMENTO DOS ELEMENTOS ESTRUTURAIS   
    if DADOS.op_concdesing==1
        disp('3. DIMENSIONAMENTO DOS ELEMENTOS ESTRUTURAIS')
        [PILARresult, VIGAresult]=desing(PORTICO, ELEMENTOS, DADOS, CORTANTE, MOMENTO, NORMAL, VIGA, PILAR, PAR, ESTRUTURAL);

% 2.2 - C�LCULO DO CUSTO DA ESTRUTURA
        disp(' ')
        disp('4 .C�LCULO DO CUSTO FINAL DA ESTRUTURA')
        COST.lixo=0;
        % 2.0.7.1 - Custo dos insumos utilizados nas vigas
        [COST]=CostBeam(VIGAresult, PAR, COST);
        % 2.0.7.2 - Custo dos insumos utilizados nos pilares
        [COST]=CostColumn(PILARresult, PAR, COST);
        % Custo total da estrutura
        COST.total(m)=COST.CVA(m)+COST.CVC(m)+COST.CVF(m)+COST.CPA(m)+COST.CPC(m)+COST.CPF(m);
        % 2.0.7.3 - IMPRIMI E SALVA RESULTADOS
        plotandsave(COST)
        % 2.0.7.4 - SAVA VARI�VEIS DO WORKSPACE
        save ('PORT-ROD2.mat')
    end
end
% FIM DO LOOP PARA OP��O DE EXECU��O IGUAL � ZERO -> PROCESSAMENTO P�RTICO
%--------------------------------------------------------------------------

%2.1 - SIMULACAO SIMPLES - MONTE CARLO
if DADOS.op_exec==1
%     DADOS.NMC=v(I);
    disp('=================================================================')
    disp('                            SIMULA��O SIMPLES')
    disp('=================================================================')
    % 2.1.1 - IN�CIO DO PROCESSO DE MONTE CARLO
    [ELEMENTOS, COST, VPL, PAR] = MONTECARLO(DADOS, PAR, ELEMENTOS, PORTICO, VIGA, PILAR, FLUXOCAIXA);
    %2.1.2 - TRATAMENTO EST�TISCO DO DAS VARI�VEIS DE SA�DA - CUSTO E VPL
    % Armazena as vari�veis estat�sticas referentes ao custo do
    % empreendimento
    ESTATISTICA.CUSTO.var=var(COST.total);
    ESTATISTICA.CUSTO.std=std(COST.total);
    ESTATISTICA.CUSTO.med=mean(COST.total);
    ESTATISTICA.CUSTO.cov=cov(COST.total);
    % Armazena as vari�veis estat�sticas referentes ao VPL do
    % empreendimento
    ESTATISTICA.VPL.var=var(VPL);
    ESTATISTICA.VPL.std=std(VPL);
    ESTATISTICA.VPL.med=mean(VPL);
    ESTATISTICA.VPL.cov=cov(VPL);
    % 2.1.3 - IMPRIMI E SALVA RESULTADOS
    % Imprimi os resultados referentes ao custo do empreendimento
    disp('----------------------------------------------------------------')
    disp('CUSTO')
    disp(['Valor m�dio do custo do empreendimento ',num2str(ESTATISTICA.CUSTO.med)])
    disp(['Des. Pad do custo do empreendimento    ',num2str(ESTATISTICA.CUSTO.std)])
    % Imprimi os resultados referentes ao VPL do empreendimento
    disp('----------------------------------------------------------------')
    disp('VPL')
    disp(['Valor m�dio do VPL do empreendimento ',num2str(ESTATISTICA.VPL.med)])
    disp(['Des. Pad do VPL do empreendimento    ',num2str(ESTATISTICA.VPL.std)])
    disp('----------------------------------------------------------------')
    % Salva as vari�veis contidas na structure ESTATISTICA
%    save(text,'COST','VPL','ELEMENTOS','PAR')
end %--------------------------------------------Fim do if para op_exec = 1

%2.2 - OTIMIZA��O
if DADOS.op_exec==2
    [ESTRUTURAL]=reorder(PORTICO, VIGA, ELEMENTOS);
    disp('=================================================================')
    disp('                            OTIMIZA��O')
    disp('=================================================================')
    % 2.2.1 - Rotina para gerar as vari�veis utilizadas no processo de otimiza��o
    disp('1. Gerando vari�veis de entrada do modelo de otimiza��o')
    if DADOS.op_minimax==0
        disp('   Minimiza��o do custo da estrutura')
    else
        disp('   Maximiza��o do VPL do empreendimento')
    end
    [OTIM, VIGA, PILAR, DADOS]=OptiVar(DADOS, PORTICO, ELEMENTOS, VIGA, PILAR, ESTRUTURAL);
    disp('-----------------------------------------------------------------')
    % 2.2.2 - Rotina para c�lculo dos par�metros do gain
    disp('2. Op��o de utiliza��o dos par�metros do gain')
    if DADOS.op_gain==1
        disp('   Obeten��o autom�tica dos par�metros  gain sequence')
        [DADOS] = gains_model1D(OTIM,DADOS, ELEMENTOS, PILAR, VIGA, PAR, PORTICO, FLUXOCAIXA);
        disp('-----------------------------------------------------------------')
    else
        disp('    Utiliza��o dos valores contidos no arquivo DADOS.in')
    end
    %---------------------------------------------------------------------%
    % Cria��o de um monte de vetores nulos dentro da "structure"
    % ESTATISTICA a fim de armazenar coisas interessantes. N�o tinha um
    % nome melhor para a "struture", vou dexar esse mesmo.
    
    % CRIAR AQUI!!!!!!!!!!!!!
    
    %---------------------------------------------------------------------%
    % 2.2.3 - Fun��o objetivo � avaliada uma vez com os valores m�dios das
    % vari�veis de projeto
    disp('3. Primeira avalia��o da fun��o objetivo antes de entrar no algoritomo de otimiza��o')
    ESTATISTICA=fobjetivo(VIGA, PILAR, DADOS, PAR, ELEMENTOS, PORTICO, FLUXOCAIXA);
    disp(['   Valor m�dio da fun��o objetivo   = ',num2str(ESTATISTICA.med)])
    disp(['   Desvio padr�o da fun��o objetivo = ',num2str(ESTATISTICA.std)])
    disp('-----------------------------------------------------------------')
    % 2.2.4 - Algoritmo do otimiza��o Simultaneous Pertubation Stochastic
    % Approximation - SPSA
    disp('4. In�cio do algoritomo de otimiza��o - SPSA')
    % Armazena o valor do custo inicial da estrutura na "structure" OTIM.
    rodarSPSANormal=1;
    if rodarSPSANormal==0
        OTIM.custoinicial=ESTATISTICA.med;
        stepAlphaGamma = 0.1;
        DADOS.alphaSPSA=0.001;
        DADOS.gamma=0.001;
        kkTotal=1;
        startAlpha=DADOS.alphaSPSA;
        runs=10;
        rodadasSPSA=zeros(4,runs*runs);
        for kkParam=1:runs
            for kkInterno=1:runs
                disp(['   Rodada ',num2str(kkTotal), ' de ', num2str(runs*runs)])

                rng('default')
                [X, ys, vak, vck, vsknorm,k] = spsab(OTIM, DADOS, VIGA, PILAR, PAR, ELEMENTOS, PORTICO, FLUXOCAIXA, ESTRUTURAL);
                rodadasSPSA(1, kkTotal) = k;
                rodadasSPSA(2, kkTotal) = DADOS.alphaSPSA;
                rodadasSPSA(3, kkTotal) = DADOS.gamma;
                rodadasSPSA(4, kkTotal) = ys(k);
                kkTotal=kkTotal+1;

                DADOS.alphaSPSA=DADOS.alphaSPSA + stepAlphaGamma;      % Par�metro "alpha" da fun��o de ganho
                %2.2.5 - Imprimi e sava resultados
                disp(['   Valor m�dio da fun��o objetivo   = ',num2str(ESTATISTICA.med)])
                disp(['   Desvio padr�o da fun��o objetivo = ',num2str(ESTATISTICA.std)])
                disp('-----------------------------------------------------------------')
                disp(['   Valor m�dio da fun��o objetivo ap�s otimiza��o: ',num2str(ys(k))])
                disp(['   N�mero de itera��es do algoritomo SPSA: ', num2str(k)])
            end
            DADOS.alphaSPSA=startAlpha;
            DADOS.gamma=DADOS.gamma + stepAlphaGamma;      % Par�metro "alpha" da fun��o de ganho
        end
        xlswrite('rodadasSPSA.xlsx',rodadasSPSA);
    else
        rodadasSPSA=zeros(4,50);
        for kkk=1:50
            %rng('default')
            DADOS.alphaSPSA=0.451;
            DADOS.gamma=0.821;
            OTIM.custoinicial=ESTATISTICA.med;
            [X, ys, vak, vck, vsknorm,k] = spsab(OTIM, DADOS, VIGA, PILAR, PAR, ELEMENTOS, PORTICO, FLUXOCAIXA, ESTRUTURAL);
            rodadasSPSA(1, kkk) = k;
            rodadasSPSA(2, kkk) = DADOS.alphaSPSA;
            rodadasSPSA(3, kkk) = DADOS.gamma;
            rodadasSPSA(4, kkk) = ys(k);
            disp(['   Valor m�dio da fun��o objetivo   = ',num2str(ESTATISTICA.med)])
            disp(['   Desvio padr�o da fun��o objetivo = ',num2str(ESTATISTICA.std)])
            disp('-----------------------------------------------------------------')
            disp(['   Valor m�dio da fun��o objetivo ap�s otimiza��o: ',num2str(ys(k))])
            disp(['   N�mero de itera��es do algoritomo SPSA: ', num2str(k)])
        end
    end
%     save('RODADA1.mat')
    
end %Multiplas Otimiza�oes
toc
%diary(text)

% Plota os gr�ficos e dados referentes �s diferente an�lises
%plothist(text, v, I)

