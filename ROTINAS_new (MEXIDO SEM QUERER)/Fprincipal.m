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

% global nomearquivoTremTipo nomearquivoEmpSolo
nomearquivoTremTipo=('ROD-det-TREMTIPO-PortINPUTponte2.txt');
nomearquivoEmpSolo=('ROD-det-rEMPSOLO-PortINPUTponte2.txt');


%-------------------------------------------------------------------------%
% O controle de geradores de n�meros rand�micos deve ser COMENTADO ap�s a
% valida��o do c�digo
%rng('default')
%-------------------------------------------------------------------------%


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
% 1.1- LEITURA DOS DADOS A PARTIR DO CART�O DE ENTRADA
DADOS=InputDados;
% DADOS.filein=nomearquivoinput;
% DADOS.fileparconc=nomearquivodadosconc;
% DADOS.fileparconcTD=nomearquivodadosconcTD;
% DADOS.fileparaco=nomearquivodadosaco;
% DADOS.fileparsteel=nomearquivodadossteel;
% DADOS.filepareco=nomearquivodadoseco;

% 1.2 - LEITURA DOS DADOS NECESS�RIOS � CRIA��O DO MODELO NUM�RICO
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
% 1.3 - C�LCULO DO COMPRIMENTO DE CADA ELEMENTOS
[PORTICO]=comp(PORTICO);
% 1.4 - C�CULO DO �NGULO QUE CADA ELEMENTO FAZ COM O EIXO X GLOBAL
[PORTICO]=angular(PORTICO);

%-------------------------------------------------------------------------%
% Caso a rotina autorun.m esteja sendo usada, aqui altera-se o NMC
% DADOS.NMC=v(I);
%-------------------------------------------------------------------------%

%--------------------- GAMBIARRA PARA AMOSTRAR O SOLO --------------------%
arquivoinput=nomearquivoEmpSolo;
[CARGASOLO]=amostrasolo(DADOS, arquivoinput, PORTICO);

% 1.5 - CLASSIFICA��O DOS ELEMENTOS
[VIGA, PILAR, DADOS]=ClassificaElem(DADOS, PORTICO, ELEMENTOS, VIGA, PILAR);

%1.6 - "PSEUDO'AMOSTRAGEM DOS VALORES DAS VARI�VEIS ALEAT�RIAS - serve
% para preencher as vari�veis com final "V" que s�o utilizadas nas
% demais rotinas desse c�digo. Esse artif�cio serve para que a mesma
% vari�vel possa ser utilizada em todas as rotinas sem que haja a
% necessidade de alter�-la. Caso seja feita a op��o de apenas procesar o
% p�rtico plano, os desvios padr�o das vari�veis aleat�rias ser�o zerados,
% de forma que elas passar�o a ter carater determin�sticos.
if DADOS.op_exec==0
    DADOS.NMC=1;
    % Nessa rotina o desvio padr�o ser� zerado
    [PAR]=desvpadzero(PAR, PORTICO);
end 
% Par�metros econ�micos
if DADOS.op_ecoanalise==1
    [PAR]=economicpar(PAR, DADOS);
end
% Par�metros f�sicos
[PAR]=phisicalpar(PAR, DADOS);
% Carregamentos atuantes
[PORTICO]=loads(DADOS, PORTICO);
% Par�metros geom�tricos
[ELEMENTOS]=geometricalprop(DADOS, ELEMENTOS, PORTICO);
% Par�metros do solo
[PORTICO]=soilprop(DADOS, PORTICO);

% 1.7 - ALTERA��O DOS PAR�METROS F�SICOS DO CONCRETO - M�dulo de
% elasticidade, coef. de flu�ncia e deforma��o espec�fica de retra��o
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
% Cria��o de vetores e matrizes nulas para otimizar o tempo de
%processamento
D=ESTRUTURAL.D;
[CORTANTE, MOMENTO, NORMAL, TRANSX, TRANSZ, ROTACAO, COST, VPL]=null(D, DADOS);

% 2 - EXECUCAO
% Opcao de Execucao do codigo
% 0 - Processamento do p�rtico plano
% 1 - Simulacao Simples
% 2 - Otimizacao 
% 3 - Analise de Sensibilidade

% 2.0 - MODELAGEM E PROCESSAMENTO DO P�RTICO PLANO
%--------------------------------------------------------------------------
if DADOS.op_exec==0
    disp('=================================================================')
    disp('                    PROCESSAMENTO DO P�RTICO PLANO')
    disp('=================================================================')
    % � vari�vel global "m" ser� atribu�do o valor m=1, uma vez que n�o haver� itera��es de Monte Carlo
    m=1; 
    
    % Os par�metros referentes �s constantes de mola ser�o reescritos em
    % PORTICO.springsV.
    PORTICO.springsAlongV=PORTICO.springs(:,1);
    PORTICO.springsEncurtV=PORTICO.springs(:,3);
    
% 2.0.1 - PROCESSA O P�RTICO PLANO - PorticoPlano.m
    disp('2. OBTEN��O DOS ESFOR�OS INTERNOS VIA PorticoPlano.m')
    disp(' ')
    [MOMENTO, CORTANTE, NORMAL, VIGA, PILAR, DADOS, PAR, ELEMENTOS, TRANSX, TRANSZ, ROTACAO]=PorticoPlano(CORTANTE,...
        MOMENTO, NORMAL, TRANSX, TRANSZ, ROTACAO, DADOS, PORTICO, ELEMENTOS, VIGA, PILAR, PAR, ESTRUTURAL, CARGASOLO);    
% COMBINA��ES DE CARGA
    [COMBColumn, COMBPile, SOLO]=combinacao(PORTICO, DADOS, MOMENTO, NORMAL, PILAR, ESTRUTURAL, TRANSX);
    [PILAR]=columncheck(PORTICO, DADOS, PILAR, PAR, ESTRUTURAL, COMBColumn);
% 2.0.2 - DIMENSIONAMENTO DOS ELEMENTOS ESTRUTURAIS   
    if DADOS.op_concdesing==1
        disp('3. DIMENSIONAMENTO DOS ELEMENTOS ESTRUTURAIS')
        [PILARresult, VIGAresult]=desing(PORTICO, ELEMENTOS, DADOS, CORTANTE, MOMENTO, NORMAL, VIGA, PILAR, PAR,...
            ESTRUTURAL);
% 2.0.3 - C�LCULO DO CUSTO DA ESTRUTURA
        disp(' ')
        disp('4 .C�LCULO DO CUSTO FINAL DA ESTRUTURA')
        COST.lixo=0;
        % 2.0.3.1 - Custo dos insumos utilizados nas vigas
        [COST]=CostBeam(VIGAresult, PAR, COST);
        % 2.0.3.2 - Custo dos insumos utilizados nos pilares
        [COST]=CostColumn(PILARresult, PAR, COST);
        % Custo total da estrutura
        COST.total(m)=COST.CVA(m)+COST.CVC(m)+COST.CVF(m)+COST.CPA(m)+COST.CPC(m)+COST.CPF(m);
        % 2.0.3.3 - IMPRIMI E SALVA RESULTADOS
        plotandsave(COST)
        % 2.0.3.4 - SAVA VARI�VEIS DO WORKSPACE
        %save ('PORT-ROD2.mat')
    end
end
% FIM DO LOOP PARA OP��O DE EXECU��O IGUAL � ZERO -> PROCESSAMENTO P�RTICO
%--------------------------------------------------------------------------

%2.1 - SIMULACAO SIMPLES - MONTE CARLO
%--------------------------------------------------------------------------
if DADOS.op_exec==1 || DADOS.op_exec==2
    disp('=================================================================')
    disp('                            SIMULA��O SIMPLES')
    disp('=================================================================')
    % IN�CIO DO PROCESSO DE MONTE CARLO
    [ELEMENTOS, COST, VPL, PAR, TRANSX, TRANSZ, ROTACAO, MOMENTO, CORTANTE, NORMAL] = MONTECARLO(DADOS, COST, VPL,...
        PAR, ELEMENTOS, PORTICO, VIGA, PILAR, FLUXOCAIXA, ESTRUTURAL, CORTANTE, MOMENTO, NORMAL, TRANSX, TRANSZ, ROTACAO, CARGASOLO);
    
   
end %--------------------------------------------Fim do if para op_exec = 1

% 2.2 - CONFIBILIDADE - c�lculo da probilidade de faha e �ndice de
% confiabilidade da estrutura/elementos estruturais
%--------------------------------------------------------------------------
if DADOS.op_exec==2
    disp('=================================================================')
    disp('                     �NDICE DE CONFIABILIDADE')
    disp('=================================================================')
    % Combina��es de carga
    [COMBColumn, COMBPile, COMBSoil, SOLO]=combinacao(PORTICO, DADOS, MOMENTO, NORMAL, PILAR, ESTRUTURAL, TRANSX);
    % Probabilidade de falha - pilar
    [PILAR]=columncheck(PORTICO, DADOS, PILAR, PAR, ESTRUTURAL, COMBColumn);
    % Probabilidade de falha - estaca
    [ESTACA]=pilecheck(ELEMENTOS, DADOS, PAR, ESTRUTURAL, COMBPile);
    % Probabilidade de falha - solo
    [SOLO]=soilcheck(PORTICO, DADOS, PILAR, ESTRUTURAL, TRANSX, SOLO, COMBSoil);
end

%2.2 - OTIMIZA��O
if DADOS.op_exec==3
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
    [OTIM, VIGA, PILAR, DADOS]=OptiVar(DADOS, PORTICO, ELEMENTOS, VIGA, PILAR);
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
    [X, ys, vak, vck] = spsab(OTIM, DADOS, VIGA, PILAR, PAR, ELEMENTOS, PORTICO, FLUXOCAIXA);
    %2.2.5 - Imprimi e sava resultados
    disp(['   Valor m�dio da fun��o objetivo ap�s otimiza��o: ',num2str(ys(DADOS.N))])
    disp(['   N�mero de itera��es do algoritomo SPSA: ', num2str(DADOS.N)])
%     save('RODADA1.mat')
    
end %Multiplas Otimiza�oes
toc

