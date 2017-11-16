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

% O controle de geradores de n�meros rand�micos deve ser retirado ap�s a
% valida��o do c�digo
rng('default')
fprintf('\n----------------------------------------------------------------\n');
fprintf('TESE DE DOUTORADO\n');
fprintf('MODELOS  DE SELECAO DE  MEDIA FIDELIDADE  PARA  ANALISE \n');
fprintf('DE  INCERTEZAS EM ESTRUTURAS DE CONCRETO ARMADO');
fprintf('\nALUNO      S�rgio J. Priori J. Marques Filho'); 
fprintf('\nORIENTADOR �zio da Rocha Araujo\n');
fprintf('------------------------------------------------------------------\n');
disp(' ')

%FAB - Remo��o de vari�vel global sem uso.
%global m

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
    %[OTIM, DADOS]=OptiVar(DADOS, ELEMENTOS, ESTRUTURAL)
    %FAB - Devido mudan�as na assinatura de OptiVar, deve-se mudar aqui
    %tamb�m.
    %[OTIM, VIGA, PILAR, DADOS]=OptiVar(DADOS, PORTICO, ELEMENTOS, VIGA, PILAR, ESTRUTURAL);
    [OTIM, DADOS]=OptiVar(DADOS, ELEMENTOS, ESTRUTURAL);
    disp('-----------------------------------------------------------------')
    % 2.2.2 - Rotina para c�lculo dos par�metros do gain
    disp('2. Op��o de utiliza��o dos par�metros do gain')
    DADOS.op_gain=1; %FAB - Controle r�pido de DADOS.op_gain.
    if DADOS.op_gain==1
        disp('   Obten��o autom�tica dos par�metros  gain sequence')
        [DADOS] = gains_model1D(OTIM,DADOS, ELEMENTOS, ESTRUTURAL, PILAR, VIGA, PAR, PORTICO, FLUXOCAIXA);
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
                    disp(['   Valor m�dio da fun��o objetivo   = ',num2str(ESTATISTICA.med)])
                    disp(['   Desvio padr�o da fun��o objetivo = ',num2str(ESTATISTICA.std)])
                    disp('-----------------------------------------------------------------')
                    disp(['   Valor m�dio da fun��o objetivo ap�s otimiza��o: ',num2str(ys(k))])
                    disp(['   N�mero de itera��es do algoritomo SPSA: ', num2str(k)])
                else
                    disp(['   Itera��o descartada pois alpha/gamma est� fora do valor ideal: ', num2str(DADOS.alphaSPSA), '/', num2str(DADOS.gamma), '=', num2str(DADOS.alphaSPSA / DADOS.gamma)])
                end
                    DADOS.alphaSPSA=DADOS.alphaSPSA + stepAlphaGamma;      % Par�metro "alpha" da fun��o de ganho
                    kkTotal=kkTotal+1;
            end
            DADOS.alphaSPSA=startAlpha;
            DADOS.gamma=DADOS.gamma + stepAlphaGamma;      % Par�metro "alpha" da fun��o de ganho
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
            disp(['   Valor m�dio da fun��o objetivo   = ',num2str(ESTATISTICA.med)])
            disp(['   Desvio padr�o da fun��o objetivo = ',num2str(ESTATISTICA.std)])
            disp('-----------------------------------------------------------------')
            disp(['   Valor m�dio da fun��o objetivo ap�s otimiza��o: ',num2str(ys(k))])
            disp(['   N�mero de itera��es do algoritomo SPSA: ', num2str(k)])
        end
        xlswrite(['rodadasSPSA_',num2str(stepAlphaGamma),'.xlsx'],rodadasSPSA);
        xlswrite(['yks_rodadas_',num2str(stepAlphaGamma),'.xlsx'],yks_rodadas);
    end
    
end %Multiplas Otimiza�oes
toc

