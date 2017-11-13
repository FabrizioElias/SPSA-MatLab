% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIENCIAS
% PROGRAMA DE POS-GRADUACAO EM ENGENHARIA CIVIL        - AREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELECAO DE  MEDIA FIDELIDADE  PARA  ANALISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO
% ALUNO       Sérgio J. Priori J. Marques Filho
% ORIENTADOR  Prof. Ézio da Rocha Araújo
% -------------------------------------------------------------------------
% DESCRICAO
% Função principal. Chama as outras funções.
% % -----------------------------------------------------------------------
% MODIFICAÇÕES - Sérgio Marques
% 1. As rotinas não trabalham com variáveis globais. Estas foram
% substituidas por "STRUCTURES" de forma a diminuir o tempo de
% processamento.
% -------------------------------------------------------------------------
% ADAPTAÇÃO DA ROTINA DE DIEGO OLIVEIRA 30-Janeiro-2006
% Modificada      04-Agosto-2011              NILMA ANDRADE
% Modificada      13-Janeiro-2015             SÉRGIO MARQUES   
% -------------------------------------------------------------------------
%
tic
clc
clear variables global
%text=(['EST-PORT3_ROD6b_NMC ',num2str(v(I))]);
% diary(text)
% O controle de geradores de números randômicos deve ser retirado após a
% validação do código
rng('default')
fprintf('\n----------------------------------------------------------------\n');
fprintf('TESE DE DOUTORADO\n');
fprintf('MODELOS  DE SELECAO DE  MEDIA FIDELIDADE  PARA  ANALISE \n');
fprintf('DE  INCERTEZAS EM ESTRUTURAS DE CONCRETO ARMADO');
fprintf('\nALUNO      Sérgio J. Priori J. Marques Filho'); 
fprintf('\nORIENTADOR Ézio da Rocha Araujo\n');
fprintf('------------------------------------------------------------------\n');
disp(' ')

global m

% 1 - ENTRADA DE DADOS
disp('1. LEITURA DOS ARQUIVOS DE ENTRADA')
disp(' ')
% 1.1- Leitura dos dados do Arquivo de entrada:
DADOS=InputDados;
% 1.2 - LEITURA DOS DADOS NECESSÁRIOS À CRIAÇÃO DO MODELO NUMÉRICO
[PORTICO, ELEMENTOS, PAR, VIGA, PILAR, FLUXOCAIXA]=Le_Dados(DADOS);
% Plota o portico para visualização
% for i=1:PORTICO.nnos
%     plot(PORTICO.coord(i,1),PORTICO.coord(i,2),'o')
%     hold on
% end
% 1.3 - CÁLCULO DO COMPRIMENTO DE CADA ELEMENTOS
[PORTICO]=comp(PORTICO);
% 1.4 - CÁCULO DO ÂNGULO QUE CADA ELEMENTO FAZ COM O EIXO X GLOBAL
[PORTICO]=angular(PORTICO);

% Caso a rotina autorun.m esteja sendo usada, aqui altera-se o NMC
%DADOS.NMC=v(I);

% 1.3 - CLASSIFICAÇÃO DOS ELEMENTOS
[VIGA, PILAR, DADOS]=Classifica_elem(DADOS, PORTICO, ELEMENTOS, VIGA, PILAR);
% 1.4 - ALTERAÇÃO DOS PARÂMETROS FÍSICOS DO CONCRETO
if DADOS.op_phisicalpar==0      % <-- FIB MC2010
    [PAR]=phisicalparFIBMC2010(PAR, VIGA);
elseif DADOS.op_phisicalpar==1  % <-- FIB NBR6118/2014
    [PAR]=phisicalparNBR(PAR, DADOS);
elseif DADOS.op_phisicalpar==2  % <-- FIB MC90
    [PAR]=phisicalparFIBMC90(PAR, VIGA, DADOS);
end 
%1.4 - "PSEUDO'AMOSTRAGEM DOS VALORES DAS VARIÁVEIS ALEATÓRIAS - serve
% apenas para preencher as variáveis com final "V" que são utilizadas nas
% demais rotinas desse código. Esse artifício serve para que a mesma
% variável possa ser utilizada em todas as rotinas sem que haja a
% necessidade de alterá-la.
if DADOS.op_exec==0
    DADOS.NMC=1;
    [PAR, ELEMENTOS]=desvpadzero(PAR, PORTICO, ELEMENTOS);
end 
% Parâmetros econômicos
[PAR]=economicpar(PAR, DADOS);
% Parâmetros físicos
[PAR]=phisicalpar(PAR, DADOS);
% Parâmetros geométricos
[ELEMENTOS]=geometricalprop(DADOS, ELEMENTOS, PORTICO);
% Carregamentos atuantes
[PORTICO]=loads(DADOS, PORTICO);
    
% 2 - EXECUCAO
% Opcao de Execucao do codigo
% 0 - Processamento do pórtico plano
% 1 - Simulacao Simples
% 2 - Otimizacao 
% 3 - Analise de Sensibilidade

% 2.1 - MODELAGEM E PROCESSAMENTO DO PÓRTICO PLANO
%--------------------------------------------------------------------------
if DADOS.op_exec==0
    disp('=================================================================')
    disp('                    PROCESSAMENTO DO PÓRTICO PLANO')
    disp('=================================================================')
    % À variável global "m" será atribuído o valor m=1, uma vez que não haverá iterações de Monte Carlo
    m=1;    
    
    [ESTRUTURAL]=reorder(PORTICO, VIGA, ELEMENTOS);
    
% 2.0 - PROCESSA O PÓRTICO PLANO - PorticoPlano.m
    disp('2. OBTENÇÃO DOS ESFORÇOS INTERNOS VIA PorticoPlano.m')
    disp(' ')
    [MOMENTO, CORTANTE, NORMAL, VIGA, PILAR, DADOS, PAR, ELEMENTOS, TRANSX, TRANSZ, ROTACAO]=PorticoPlano(DADOS, PORTICO, ELEMENTOS, VIGA, PILAR,PAR, ESTRUTURAL);   
       
% 2.1 - DIMENSIONAMENTO DOS ELEMENTOS ESTRUTURAIS   
    if DADOS.op_concdesing==1
        disp('3. DIMENSIONAMENTO DOS ELEMENTOS ESTRUTURAIS')
        [PILARresult, VIGAresult]=desing(PORTICO, ELEMENTOS, DADOS, CORTANTE, MOMENTO, NORMAL, VIGA, PILAR, PAR, ESTRUTURAL);

% 2.2 - CÁLCULO DO CUSTO DA ESTRUTURA
        disp(' ')
        disp('4 .CÁLCULO DO CUSTO FINAL DA ESTRUTURA')
        COST.lixo=0;
        % 2.0.7.1 - Custo dos insumos utilizados nas vigas
        [COST]=CostBeam(VIGAresult, PAR, COST);
        % 2.0.7.2 - Custo dos insumos utilizados nos pilares
        [COST]=CostColumn(PILARresult, PAR, COST);
        % Custo total da estrutura
        COST.total(m)=COST.CVA(m)+COST.CVC(m)+COST.CVF(m)+COST.CPA(m)+COST.CPC(m)+COST.CPF(m);
        % 2.0.7.3 - IMPRIMI E SALVA RESULTADOS
        plotandsave(COST)
        % 2.0.7.4 - SAVA VARIÁVEIS DO WORKSPACE
        save ('PORT-ROD2.mat')
    end
end
% FIM DO LOOP PARA OPÇÃO DE EXECUÇÃO IGUAL À ZERO -> PROCESSAMENTO PÓRTICO
%--------------------------------------------------------------------------

%2.1 - SIMULACAO SIMPLES - MONTE CARLO
if DADOS.op_exec==1
%     DADOS.NMC=v(I);
    disp('=================================================================')
    disp('                            SIMULAÇÃO SIMPLES')
    disp('=================================================================')
    % 2.1.1 - INÍCIO DO PROCESSO DE MONTE CARLO
    [ELEMENTOS, COST, VPL, PAR] = MONTECARLO(DADOS, PAR, ELEMENTOS, PORTICO, VIGA, PILAR, FLUXOCAIXA);
    %2.1.2 - TRATAMENTO ESTÁTISCO DO DAS VARIÁVEIS DE SAÍDA - CUSTO E VPL
    % Armazena as variáveis estatísticas referentes ao custo do
    % empreendimento
    ESTATISTICA.CUSTO.var=var(COST.total);
    ESTATISTICA.CUSTO.std=std(COST.total);
    ESTATISTICA.CUSTO.med=mean(COST.total);
    ESTATISTICA.CUSTO.cov=cov(COST.total);
    % Armazena as variáveis estatísticas referentes ao VPL do
    % empreendimento
    ESTATISTICA.VPL.var=var(VPL);
    ESTATISTICA.VPL.std=std(VPL);
    ESTATISTICA.VPL.med=mean(VPL);
    ESTATISTICA.VPL.cov=cov(VPL);
    % 2.1.3 - IMPRIMI E SALVA RESULTADOS
    % Imprimi os resultados referentes ao custo do empreendimento
    disp('----------------------------------------------------------------')
    disp('CUSTO')
    disp(['Valor médio do custo do empreendimento ',num2str(ESTATISTICA.CUSTO.med)])
    disp(['Des. Pad do custo do empreendimento    ',num2str(ESTATISTICA.CUSTO.std)])
    % Imprimi os resultados referentes ao VPL do empreendimento
    disp('----------------------------------------------------------------')
    disp('VPL')
    disp(['Valor médio do VPL do empreendimento ',num2str(ESTATISTICA.VPL.med)])
    disp(['Des. Pad do VPL do empreendimento    ',num2str(ESTATISTICA.VPL.std)])
    disp('----------------------------------------------------------------')
    % Salva as variáveis contidas na structure ESTATISTICA
%    save(text,'COST','VPL','ELEMENTOS','PAR')
end %--------------------------------------------Fim do if para op_exec = 1

%2.2 - OTIMIZAÇÃO
if DADOS.op_exec==2
    [ESTRUTURAL]=reorder(PORTICO, VIGA, ELEMENTOS);
    disp('=================================================================')
    disp('                            OTIMIZAÇÃO')
    disp('=================================================================')
    % 2.2.1 - Rotina para gerar as variáveis utilizadas no processo de otimização
    disp('1. Gerando variáveis de entrada do modelo de otimização')
    if DADOS.op_minimax==0
        disp('   Minimização do custo da estrutura')
    else
        disp('   Maximização do VPL do empreendimento')
    end
    %[OTIM, DADOS]=OptiVar(DADOS, ELEMENTOS, ESTRUTURAL)
    %FAB - Devido mudanças na assinatura de OptiVar, deve-se mudar aqui
    %também.
    %[OTIM, VIGA, PILAR, DADOS]=OptiVar(DADOS, PORTICO, ELEMENTOS, VIGA, PILAR, ESTRUTURAL);
    [OTIM, DADOS]=OptiVar(DADOS, ELEMENTOS, ESTRUTURAL);
    disp('-----------------------------------------------------------------')
    % 2.2.2 - Rotina para cálculo dos parâmetros do gain
    disp('2. Opção de utilização dos parâmetros do gain')
    if DADOS.op_gain==1
        disp('   Obtenção automática dos parâmetros  gain sequence')
        [DADOS] = gains_model1D(OTIM,DADOS, ELEMENTOS, ESTRUTURAL, PILAR, VIGA, PAR, PORTICO, FLUXOCAIXA);
        disp('-----------------------------------------------------------------')
    else
        disp('    Utilização dos valores contidos no arquivo DADOS.in')
    end
    %---------------------------------------------------------------------%
    % Criação de um monte de vetores nulos dentro da "structure"
    % ESTATISTICA a fim de armazenar coisas interessantes. Não tinha um
    % nome melhor para a "struture", vou dexar esse mesmo.
    
    % CRIAR AQUI!!!!!!!!!!!!!
    
    %---------------------------------------------------------------------%
    % 2.2.3 - Função objetivo é avaliada uma vez com os valores médios das
    % variáveis de projeto
    disp('3. Primeira avaliação da função objetivo antes de entrar no algoritomo de otimização')
    ESTATISTICA=fobjetivo(VIGA, PILAR, DADOS, PAR, ELEMENTOS, PORTICO, FLUXOCAIXA);
    disp(['   Valor médio da função objetivo   = ',num2str(ESTATISTICA.med)])
    disp(['   Desvio padrão da função objetivo = ',num2str(ESTATISTICA.std)])
    disp('-----------------------------------------------------------------')
    % 2.2.4 - Algoritmo do otimização Simultaneous Pertubation Stochastic
    % Approximation - SPSA
    disp('4. Início do algoritomo de otimização - SPSA')
    % Armazena o valor do custo inicial da estrutura na "structure" OTIM.
    rodarSPSANormal=0;
    if rodarSPSANormal==0
        OTIM.custoinicial=ESTATISTICA.med;
        stepAlphaGamma = 0.01;
        DADOS.alphaSPSA=0.402; %valor original: 0.602
        DADOS.gamma=0.001; %valor original: 0.101
        kkTotal=1;
        kk=1;
        maxRuns_IndividualSPSA = 40;
        startAlpha=DADOS.alphaSPSA;
        runs=50;
        rodadasSPSA=zeros(10,runs*runs);
        yks_rodadas = zeros(runs, maxRuns_IndividualSPSA+2);
        for kkParam=1:runs
            for kkInterno=1:runs
                if (DADOS.alphaSPSA / DADOS.gamma >= 0.8 && DADOS.alphaSPSA / DADOS.gamma <= 1.0)
                    disp(['   Rodada ',num2str(kkTotal), ' de ', num2str(runs*runs)])

                    rng('default')
                    [X, ys, vak, vck, vsknorm,k] = spsab(maxRuns_IndividualSPSA, OTIM, DADOS, VIGA, PILAR, PAR, ELEMENTOS, PORTICO, FLUXOCAIXA, ESTRUTURAL);
                    rodadasSPSA(1, kk) = k;
                    rodadasSPSA(2, kk) = DADOS.alphaSPSA;
                    rodadasSPSA(3, kk) = DADOS.gamma;
                    rodadasSPSA(4, kk) = ys(k);
                    rodadasSPSA(5:end, kk) = X(k+1, 1:end);
                    yks_rodadas(kk, 1:k+1)=ys(1:k+1);
                    kk=kk+1;

                    %2.2.5 - Imprimi e sava resultados
                    disp(['   Valor médio da função objetivo   = ',num2str(ESTATISTICA.med)])
                    disp(['   Desvio padrão da função objetivo = ',num2str(ESTATISTICA.std)])
                    disp('-----------------------------------------------------------------')
                    disp(['   Valor médio da função objetivo após otimização: ',num2str(ys(k))])
                    disp(['   Número de iterações do algoritomo SPSA: ', num2str(k)])
                else
                    disp(['   Iteração descartada pois alpha/gamma está fora do valor ideal: ', num2str(DADOS.alphaSPSA), '/', num2str(DADOS.gamma), '=', num2str(DADOS.alphaSPSA / DADOS.gamma)])
                end
                    DADOS.alphaSPSA=DADOS.alphaSPSA + stepAlphaGamma;      % Parâmetro "alpha" da função de ganho
                    kkTotal=kkTotal+1;
            end
            DADOS.alphaSPSA=startAlpha;
            DADOS.gamma=DADOS.gamma + stepAlphaGamma;      % Parâmetro "alpha" da função de ganho
        end
        xlswrite(['rodadasSPSA_',num2str(stepAlphaGamma),'.xlsx'],rodadasSPSA);
    else
        runs=10;
        rodadasSPSA=zeros(10,runs);
        yks_rodadas = zeros(runs, 10005);
        maxRuns_IndividualSPSA = 300;
        for kkk=1:runs
            %rng('default')
            DADOS.alphaSPSA=0.601;
            DADOS.gamma=0.802;
            OTIM.custoinicial=ESTATISTICA.med;
            [X, ys, vak, vck, vsknorm,k] = spsab(maxRuns_IndividualSPSA, OTIM, DADOS, VIGA, PILAR, PAR, ELEMENTOS, PORTICO, FLUXOCAIXA, ESTRUTURAL);
            rodadasSPSA(1, kkk) = k;
            rodadasSPSA(2, kkk) = DADOS.alphaSPSA;
            rodadasSPSA(3, kkk) = DADOS.gamma;
            rodadasSPSA(4, kkk) = ys(k);
            rodadasSPSA(5:end, kkk) = X(k+1, 1:end);
            yks_rodadas(kkk, 1:k+1)=ys(1:k+1);
            disp(['   Valor médio da função objetivo   = ',num2str(ESTATISTICA.med)])
            disp(['   Desvio padrão da função objetivo = ',num2str(ESTATISTICA.std)])
            disp('-----------------------------------------------------------------')
            disp(['   Valor médio da função objetivo após otimização: ',num2str(ys(k))])
            disp(['   Número de iterações do algoritomo SPSA: ', num2str(k)])
        end
        xlswrite(['rodadasSPSA_',num2str(stepAlphaGamma),'.xlsx'],rodadasSPSA);
        xlswrite(['yks_rodadas_',num2str(stepAlphaGamma),'.xlsx'],yks_rodadas);
    end
%     save('RODADA1.mat')
    
end %Multiplas Otimizaçoes
toc
%diary(text)

% Plota os gráficos e dados referentes às diferente análises
%plothist(text, v, I)

