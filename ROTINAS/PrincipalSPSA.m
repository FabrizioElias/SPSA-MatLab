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

%FAB - Remoção de variável global sem uso.
%global m

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
    DADOS.op_gain=1; %FAB - Controle rápido de DADOS.op_gain.
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
        stepAlphaGamma = 0.001;
        DADOS.alphaSPSA=0.001; %valor original: 0.602
        DADOS.gamma=0.001; %valor original: 0.101
        kkTotal=1;
        kk=1;
        maxRuns_IndividualSPSA = 90;
        startAlpha=DADOS.alphaSPSA;
        runs=1000;
        rodadasSPSA=zeros(10,runs*runs);
        yks_rodadas = zeros(runs, maxRuns_IndividualSPSA+2);
        for kkParam=1:runs
            for kkInterno=1:runs
                if (DADOS.alphaSPSA / DADOS.gamma >= 5.8 && DADOS.alphaSPSA / DADOS.gamma <= 6.1)
                    disp(['   Rodada ',num2str(kkTotal), ' de ', num2str(runs*runs)])

                    rng('default')
                    [X, ys, vak, vck, vsknorm,k] = spsab(maxRuns_IndividualSPSA, OTIM, DADOS, VIGA, PILAR, PAR, ELEMENTOS, PORTICO, FLUXOCAIXA, ESTRUTURAL);
                    rodadasSPSA(1, kk) = k;
                    rodadasSPSA(2, kk) = DADOS.alphaSPSA;
                    rodadasSPSA(3, kk) = DADOS.gamma;
                    rodadasSPSA(4, kk) = ys(k);
                    rodadasSPSA(5:end, kk) = X(k+1, 1:end);
                    yks_rodadas(kk, 1:k)=ys(1:k);
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
    
end %Multiplas Otimizaçoes
toc

