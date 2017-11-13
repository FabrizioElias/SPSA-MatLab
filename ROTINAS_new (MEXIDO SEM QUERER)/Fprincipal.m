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

% global nomearquivoTremTipo nomearquivoEmpSolo
nomearquivoTremTipo=('ROD-det-TREMTIPO-PortINPUTponte2.txt');
nomearquivoEmpSolo=('ROD-det-rEMPSOLO-PortINPUTponte2.txt');


%-------------------------------------------------------------------------%
% O controle de geradores de números randômicos deve ser COMENTADO após a
% validação do código
%rng('default')
%-------------------------------------------------------------------------%


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
% 1.1- LEITURA DOS DADOS A PARTIR DO CARTÃO DE ENTRADA
DADOS=InputDados;
% DADOS.filein=nomearquivoinput;
% DADOS.fileparconc=nomearquivodadosconc;
% DADOS.fileparconcTD=nomearquivodadosconcTD;
% DADOS.fileparaco=nomearquivodadosaco;
% DADOS.fileparsteel=nomearquivodadossteel;
% DADOS.filepareco=nomearquivodadoseco;

% 1.2 - LEITURA DOS DADOS NECESSÁRIOS À CRIAÇÃO DO MODELO NUMÉRICO
[PORTICO, ELEMENTOS, PAR, VIGA, PILAR, FLUXOCAIXA]=Le_Dados(DADOS);

% % %-------------------------------------------------------------------------%
% % %--------------------- GAMBIARRA PARA AMOSTRAR O SOLO --------------------%
% arquivoinput=nomearquivoEmpSolo;
% [CARGASOLO]=amostrasolo(DADOS, arquivoinput, PORTICO);

% 
% %-------------------------------------------------------------------------%
% figure
% hold on
% for i=1:PORTICO.nnos
%     
%     plot(PORTICO.x(i),PORTICO.z(i),'o')
% end
% 1.3 - CÁLCULO DO COMPRIMENTO DE CADA ELEMENTOS
[PORTICO]=comp(PORTICO);
% 1.4 - CÁCULO DO ÂNGULO QUE CADA ELEMENTO FAZ COM O EIXO X GLOBAL
[PORTICO]=angular(PORTICO);

%-------------------------------------------------------------------------%
% Caso a rotina autorun.m esteja sendo usada, aqui altera-se o NMC
% DADOS.NMC=v(I);
%-------------------------------------------------------------------------%

%--------------------- GAMBIARRA PARA AMOSTRAR O SOLO --------------------%
arquivoinput=nomearquivoEmpSolo;
[CARGASOLO]=amostrasolo(DADOS, arquivoinput, PORTICO);

% 1.5 - CLASSIFICAÇÃO DOS ELEMENTOS
[VIGA, PILAR, DADOS]=ClassificaElem(DADOS, PORTICO, ELEMENTOS, VIGA, PILAR);

%1.6 - "PSEUDO'AMOSTRAGEM DOS VALORES DAS VARIÁVEIS ALEATÓRIAS - serve
% para preencher as variáveis com final "V" que são utilizadas nas
% demais rotinas desse código. Esse artifício serve para que a mesma
% variável possa ser utilizada em todas as rotinas sem que haja a
% necessidade de alterá-la. Caso seja feita a opção de apenas procesar o
% pórtico plano, os desvios padrão das variáveis aleatórias serão zerados,
% de forma que elas passarão a ter carater determinísticos.
if DADOS.op_exec==0
    DADOS.NMC=1;
    % Nessa rotina o desvio padrão será zerado
    [PAR]=desvpadzero(PAR, PORTICO);
end 
% Parâmetros econômicos
if DADOS.op_ecoanalise==1
    [PAR]=economicpar(PAR, DADOS);
end
% Parâmetros físicos
[PAR]=phisicalpar(PAR, DADOS);
% Carregamentos atuantes
[PORTICO]=loads(DADOS, PORTICO);
% Parâmetros geométricos
[ELEMENTOS]=geometricalprop(DADOS, ELEMENTOS, PORTICO);
% Parâmetros do solo
[PORTICO]=soilprop(DADOS, PORTICO);

% 1.7 - ALTERAÇÃO DOS PARÂMETROS FÍSICOS DO CONCRETO - Módulo de
% elasticidade, coef. de fluência e deformação específica de retração
if DADOS.op_phisicalpar==0      % <-- FIB MC2010
    [PAR]=phisicalparFIBMC2010(PAR, VIGA, ELEMENTOS, DADOS);
elseif DADOS.op_phisicalpar==1  % <-- FIB NBR6118/2014
    [PAR]=phisicalparNBR(PAR, DADOS);
elseif DADOS.op_phisicalpar==2  % <-- FIB MC90
    [PAR]=phisicalparFIBMC90(PAR, VIGA, DADOS);
end

% Rotina criada para determinar os elementos de barra contidos em um
% mesmo elemento estrutural
[ESTRUTURAL]=reorder(PORTICO, VIGA, ELEMENTOS); 
% Criação de vetores e matrizes nulas para otimizar o tempo de
%processamento
D=ESTRUTURAL.D;
[CORTANTE, MOMENTO, NORMAL, TRANSX, TRANSZ, ROTACAO, COST, VPL]=null(D, DADOS);

% 2 - EXECUCAO
% Opcao de Execucao do codigo
% 0 - Processamento do pórtico plano
% 1 - Simulacao Simples
% 2 - Otimizacao 
% 3 - Analise de Sensibilidade

% 2.0 - MODELAGEM E PROCESSAMENTO DO PÓRTICO PLANO
%--------------------------------------------------------------------------
if DADOS.op_exec==0
    disp('=================================================================')
    disp('                    PROCESSAMENTO DO PÓRTICO PLANO')
    disp('=================================================================')
    % À variável global "m" será atribuído o valor m=1, uma vez que não haverá iterações de Monte Carlo
    m=1; 
    
    % Os parâmetros referentes às constantes de mola serão reescritos em
    % PORTICO.springsV.
    PORTICO.springsAlongV=PORTICO.springs(:,1);
    PORTICO.springsEncurtV=PORTICO.springs(:,3);
    
% 2.0.1 - PROCESSA O PÓRTICO PLANO - PorticoPlano.m
    disp('2. OBTENÇÃO DOS ESFORÇOS INTERNOS VIA PorticoPlano.m')
    disp(' ')
    [MOMENTO, CORTANTE, NORMAL, VIGA, PILAR, DADOS, PAR, ELEMENTOS, TRANSX, TRANSZ, ROTACAO]=PorticoPlano(CORTANTE,...
        MOMENTO, NORMAL, TRANSX, TRANSZ, ROTACAO, DADOS, PORTICO, ELEMENTOS, VIGA, PILAR, PAR, ESTRUTURAL, CARGASOLO);    
% COMBINAÇÕES DE CARGA
    [COMBColumn, COMBPile, SOLO]=combinacao(PORTICO, DADOS, MOMENTO, NORMAL, PILAR, ESTRUTURAL, TRANSX);
    [PILAR]=columncheck(PORTICO, DADOS, PILAR, PAR, ESTRUTURAL, COMBColumn);
% 2.0.2 - DIMENSIONAMENTO DOS ELEMENTOS ESTRUTURAIS   
    if DADOS.op_concdesing==1
        disp('3. DIMENSIONAMENTO DOS ELEMENTOS ESTRUTURAIS')
        [PILARresult, VIGAresult]=desing(PORTICO, ELEMENTOS, DADOS, CORTANTE, MOMENTO, NORMAL, VIGA, PILAR, PAR,...
            ESTRUTURAL);
% 2.0.3 - CÁLCULO DO CUSTO DA ESTRUTURA
        disp(' ')
        disp('4 .CÁLCULO DO CUSTO FINAL DA ESTRUTURA')
        COST.lixo=0;
        % 2.0.3.1 - Custo dos insumos utilizados nas vigas
        [COST]=CostBeam(VIGAresult, PAR, COST);
        % 2.0.3.2 - Custo dos insumos utilizados nos pilares
        [COST]=CostColumn(PILARresult, PAR, COST);
        % Custo total da estrutura
        COST.total(m)=COST.CVA(m)+COST.CVC(m)+COST.CVF(m)+COST.CPA(m)+COST.CPC(m)+COST.CPF(m);
        % 2.0.3.3 - IMPRIMI E SALVA RESULTADOS
        plotandsave(COST)
        % 2.0.3.4 - SAVA VARIÁVEIS DO WORKSPACE
        %save ('PORT-ROD2.mat')
    end
end
% FIM DO LOOP PARA OPÇÃO DE EXECUÇÃO IGUAL À ZERO -> PROCESSAMENTO PÓRTICO
%--------------------------------------------------------------------------

%2.1 - SIMULACAO SIMPLES - MONTE CARLO
%--------------------------------------------------------------------------
if DADOS.op_exec==1 || DADOS.op_exec==2
    disp('=================================================================')
    disp('                            SIMULAÇÃO SIMPLES')
    disp('=================================================================')
    % INÍCIO DO PROCESSO DE MONTE CARLO
    [ELEMENTOS, COST, VPL, PAR, TRANSX, TRANSZ, ROTACAO, MOMENTO, CORTANTE, NORMAL] = MONTECARLO(DADOS, COST, VPL,...
        PAR, ELEMENTOS, PORTICO, VIGA, PILAR, FLUXOCAIXA, ESTRUTURAL, CORTANTE, MOMENTO, NORMAL, TRANSX, TRANSZ, ROTACAO, CARGASOLO);
    
   
end %--------------------------------------------Fim do if para op_exec = 1

% 2.2 - CONFIBILIDADE - cálculo da probilidade de faha e índice de
% confiabilidade da estrutura/elementos estruturais
%--------------------------------------------------------------------------
if DADOS.op_exec==2
    disp('=================================================================')
    disp('                     ÍNDICE DE CONFIABILIDADE')
    disp('=================================================================')
    % Combinações de carga
    [COMBColumn, COMBPile, COMBSoil, SOLO]=combinacao(PORTICO, DADOS, MOMENTO, NORMAL, PILAR, ESTRUTURAL, TRANSX);
    % Probabilidade de falha - pilar
    [PILAR]=columncheck(PORTICO, DADOS, PILAR, PAR, ESTRUTURAL, COMBColumn);
    % Probabilidade de falha - estaca
    [ESTACA]=pilecheck(ELEMENTOS, DADOS, PAR, ESTRUTURAL, COMBPile);
    % Probabilidade de falha - solo
    [SOLO]=soilcheck(PORTICO, DADOS, PILAR, ESTRUTURAL, TRANSX, SOLO, COMBSoil);
end

%2.2 - OTIMIZAÇÃO
if DADOS.op_exec==3
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
    [OTIM, VIGA, PILAR, DADOS]=OptiVar(DADOS, PORTICO, ELEMENTOS, VIGA, PILAR);
    disp('-----------------------------------------------------------------')
    % 2.2.2 - Rotina para cálculo dos parâmetros do gain
    disp('2. Opção de utilização dos parâmetros do gain')
    if DADOS.op_gain==1
        disp('   Obetenção automática dos parâmetros  gain sequence')
        [DADOS] = gains_model1D(OTIM,DADOS, ELEMENTOS, PILAR, VIGA, PAR, PORTICO, FLUXOCAIXA);
        disp('-----------------------------------------------------------------')
    else
        disp('    Utilização dos valores contidos no arquivo DADOS.in')
    end
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
    [X, ys, vak, vck] = spsab(OTIM, DADOS, VIGA, PILAR, PAR, ELEMENTOS, PORTICO, FLUXOCAIXA);
    %2.2.5 - Imprimi e sava resultados
    disp(['   Valor médio da função objetivo após otimização: ',num2str(ys(DADOS.N))])
    disp(['   Número de iterações do algoritomo SPSA: ', num2str(DADOS.N)])
%     save('RODADA1.mat')
    
end %Multiplas Otimizaçoes
toc

