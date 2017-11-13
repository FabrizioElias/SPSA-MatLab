% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIÊNCIAS
% PROGRAMA DE PÓS-GRADUAÇÃO EM ENGENHARIA CIVIL        - ÁREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELEÇÃO DE  MÉDIA FIDELIDADE  PARA  ANÁLISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO.
% ALUNA       Nilma Andrade
% ORIENTADOR  Prof. Ézio da Rocha Araujo
% -------------------------------------------------------------------------
% DESCRIÇÃO
% (S)tochastic (D)ynamic (O)ptimization and (S)imulation of (B)uildings)
%
% Descriçao:
% MAIN CODE.
% Codigo para Simulacao e Otimizaçao de Edificios e suas partes, 
% Otimizacao do volume de contreto
% -------------------------------------------------------------------------
% ADAPTAÇÃO DA ROTINA DE DIEGO OLIVEIRA        2006
% Criada          04-Agosto-2011      NILMA ANDRADE
%
% Modificada 
% 
% -------------------------------------------------------------------------
%clc
%clear all
fprintf('\n-----------------------------------------------------------\n');
fprintf('                          SDOSB\n');
fprintf(' (S)tochastic (D)ynamic (O)ptimization and (S)imulation of (B)uildings)\n');
fprintf('-------------------------------------------------------------\n');
fprintf('TESE DE DOUTORADO\n');
fprintf('MODELOS DE SELEÇÃO DE MÉDIA FIDELIDADE PARA ANÁLISE DE INCERTEZAS\n');
fprintf('EM ESTRUTURAS DE CONCRETO ARMADO.\n');
fprintf('\nALUNA      Nilma Andrade\n');
fprintf('\nORIENTADOR Prof. Ézio da Rocha Araujo\n');
fprintf('-------------------------------------------------------------\n');
disp(' ')
%disp('Pressione qualquer tecla para continuar...')
%pause

% Definicoes
% Arquivos
%FAB - Remoção de variávels globais sem uso.
global filetpl;
%global filetplmc;
global filepar;
global fileout;
global filesim;
%global fileinc;
% Opcoes
global op_tp_fob;
global op_gain;
global op_exec;
global op_otim;
global op_mult;
global op_minimax;
global op_montafile;
global op_fbarrier;
global op_output;
%global op_restr;
%global op_mc;
% Dados e Controladores
global X0;
global func0;
global NPar;
global NOtim;
% % Producoes
% global Vol_concreto;
% global Vol_aco;
% global XXXX;
% global XXXX;
% Precos e Custos
%global Custo_aco;
%global Custo_concreto;
%global Custo;
global outros_custos;
global tma; 
% Parametros de Otimizacao
global tolfun;   %global tolfunh; global covb; global op_mc;
global tolx;     %global tolxh; global delcov; global NMC;
% Outros
global elapsed_time
global fid;

%--------------------------------------------------------------------------
% 1.0 - PRE-PROCESSAMENTO
%--------------------------------------------------------------------------
% Leitura dos dados do Arquivo de entrada
InputDados;
%Numero de Tempos.
% switch op_PI 
%     case 1
%         Ntempos = NPar/(NWell_P-1);
%     case 2
%         Ntempos = NPar/(NWell_I-1);
%     case 3
%         Ntempos = NPar/(NWell_P-1 + NWell_I-1);
% end

%--------------------------------------------------------------------------
% Opçao por Multiplas Otimizaçoes
if op_mult~=1 && op_exec~=2
    NOtim = 1;    %Numero de Otimizaçoes
end    
%--------------------------------------------------------------------------
% Contador de Simulacoes
CountSim=0;
%--------------------------------------------------------------------------
% Limites da Funcao Barreira
facmin=25.00;   %fator de limite minimo
facmaxP=75.00;  %fator de limite maximo para produtores
facmaxI=75.00;  %fator de limite maximo para injetores

% if op_tp_fob ~= (1|2)  %facmin, facmax para f.analíticas = domínio das funções
%     facmin=-5;
%     facmaxP=5;
% end

%--------------------------------------------------------------------------
% 2.0 - EXECUCAO
%--------------------------------------------------------------------------
% 2.1 - SIMULACAO
if op_exec==1
    X=zeros(NPar);
    if op_montafile==1
        [X,NameX,NameXS]=Le_Parametros;
    end
	func=fobjetivo(X);
end
%--------------------------------------------------------------------------
% 2.2 - OTIMIZACAO
if op_exec==2
    exitflg = zeros(NOtim);
    output = zeros(NOtim);
    Sims = zeros(NOtim);
    Xfim = zeros(NOtim);
    for k=1:NOtim    %Multiplas Otimizações
        %FAB - Troca de rand por rng equivalente.
        %rand('state',sum(100*clock)); %resets it to a different state each time

        %FAB - Remoção do rng para validação de código, o único que deve
        %existir está na função principal.
        %rng(sum(100*clock));
        switch op_tp_fob
            case 6   %função banana   
                X0=(rand(1,NPar));
                func0(k)=fobjetivo(X0(k,:));
            case 7  %expg9
                X0=4.0;  %X0=1.4; X0=1.0;
                func0(k)=fobjetivo(X0(k,:));    
            case 8  %Griewank
                X0=600*(rand(1,NPar))-200;  %ponto inicial randômico (f. Griewank)
                func0(k)=fobjetivo(X0(k,:));    
            case 9  %Rosenbrock
                x0prox=[0.99 1 0.99 1 0.99 1 0.99 1 0.99 1];
                X0=x0prox(1:NPar);  %2 ou 10 variáveis
                func0(k)=fobjetivo(X0(k,:)); 
            case 10  %ST90
                X0=3*(rand(1,NPar))-3;  %ponto inicial randômico função ST90
                %X0=3*ones(1,NPar);
                func0(k)=fobjetivo(X0(k,:));
            case 11  %poly4
                X0=ones(1,NPar);  %ponto inicial randômico função ST90
                %X0=3*ones(1,NPar);
                func0(k)=fobjetivo(X0(k,:));
            otherwise
                [X0,NameX,NameXS]=Le_Parametros;
            if op_mult==1
                flag=1;
                while flag~=0
    %               X0(k,:)=Xmin + (Xmax-Xmin).*rand(1,NPar);
    %               X0(k,:)=0.5*(Xmax+Xmin)+ 0.25*(Xmax-Xmin).*(2*(rand(1,NPar)-0.5*ones(1,NPar)));
    %               Xmed=(100/(NWell_P+NWell_I))*ones(1,NPar);
                    X0(k,:)=Xmed + (Xmax-Xmed).*(2*(rand(1,NPar)-(1/2)*ones(1,NPar)));
                    flag=checkbarrier(X0(k,:));
                end
                func0(k)=fobjetivo(X0(k,:));
            else
                func0=fobjetivo(X0);
            end
        end
        switch	op_otim
            case 1 % NEALDER-MEAD SIMPLEX (NMS)
             %Definicao das Opcoes
                options=optimset('TolFun',tolfun,'TolX',tolx);
                options=optimset(options,'Display','iter');
             %Chamada do Algoritmo de Otimizacao
                CountSim=0; % Contador de Simulacoes
                ti=cputime;
                [X(k,:),func(k),exitflg(k),output(k)] = fminsearch('fobjetivo',X0(k,:),options);
                elapsed_time(k)=(cputime-ti);
                Sims(k)=CountSim;
             %Graficos das Saidas
                [arq_iter, msg] = fopen('iteracoes.log', 'r');
                if (arq_iter == -1)
                  error(msg);
                end
                lixo=fgets(arq_iter);
                cont_aux=1;
                Iteration = 0;
                Func_count= 0;                
                min_fx    = 0;
                while ~feof(arq_iter)
                    [A,count]=fscanf(arq_iter,'%f',3);
                    if count==0
                        break
                    end
                    %FAB - Como prealocar variáveis que podem mudar?
                    Iteration(cont_aux) = A(1);
                    Func_count(cont_aux)= A(2);                
                    min_fx(cont_aux)    = A(3);
                    cont_aux=cont_aux+1;
                end
                fclose(arq_iter);
                figure;
                plot(Iteration,min_fx,'k.-');
                title('Progresso do Algoritmo de Otimizacao: Nelder-Mead Simplex');
                xlabel('Iteracoes');
                ylabel('Melhor Funcao Objetivo');

            case 2 % DIRECT PATTERN SEARCH (DPS)
                options=optsps;%();
                CountSim=0; % Contador de Simulacoes
                [A, b]=matcon;
                ti=cputime;
                [X(k,:),func(k),exitflg(k),output(k)] = patternsearch(@fobjetivo,X0(k,:),A,b,[]...
                    ,[],Xmin,Xmax,options);
                string=['PSA_',num2str(k)];
                saveas(gcf, string, 'fig');
                elapsed_time(k)=(cputime-ti);
                Sims(k)=CountSim;

            case 3 % DERIVATIVE FREE OPTIMIZATION (DFO)
                CountSim=0; % Contador de Simulacoes
                ti=cputime;
                [X,func,exitflg,output] = dfo_tr(@fobjetivo,X0');
                elapsed_time=(cputime-ti);
                Sims(k)=CountSim;

            case 4 % EVOLUCIONARY GENETIC ALGORITHM (EGA)
                options=optsga;%();
                CountSim=0; % Contador de Simulacoes
                ti=cputime;
                [X(k,:),func(k),exitflg(k),output(k)] = ga(@fobjetivo,NPar,options);
                elapsed_time(k)=(cputime-ti);      

           %case 5 % SIMULATED ANNEALING ALGORITHM (SAA)
           %original modificado em 11/02/09: inclusão do SPSA (liliane)
           if op_gain ==1
                gains
           end
            case 5 % SIMULTANEOUS PERTURBATION STOCHASTIC APPROXIMATION (SPSA-A)
                CountSim=0; % Contador de Simulacoes
                op_fbarrier=0; % SPSA dispensa barreira
                ti=cputime;
                [Xfim(k,:),func(k),exitflg] = spsaa(X0');
                string=['SPSA2_',num2str(k)];
                %saveas(gcf, string, 'fig'); 
                elapsed_time(k)=(cputime-ti);
                Sims(k)=CountSim;

            case 6 % SIMULTANEOUS PERTURBATION STOCHASTIC APPROXIMATION (SPSA-B)
                CountSim=0; % Contador de Simulacoes
                op_fbarrier=0; % SPSA dispensa barreira
                ti=cputime;          
                [Xfim(k,:),func(k),exitflg] = spsab(X0');
                string=['SPSA2_',num2str(k)];
                %saveas(gcf, string, 'fig'); 
                elapsed_time(k)=(cputime-ti);
                Sims(k)=CountSim;

            case 7 % SIMULTANEOUS PERTURBATION STOCHASTIC APPROXIMATION (SPSA-H) 
                CountSim=0; % Contador de Simulacoes
                op_fbarrier=0; % SPSA dispensa barreira
                ti=cputime;
                [Xfim(k,:),func(k),exitflg] = spsah(X0');
                string=['SPSA2_',num2str(k)];
                %saveas(gcf, string, 'fig'); 
                elapsed_time(k)=(cputime-ti);
                Sims(k)=CountSim;

            case 8 % SIMULTANEOUS PERTURBATION STOCHASTIC APPROXIMATION (SPSA-  CA) 
                CountSim=0; % Contador de Simulacoes
                op_fbarrier=0; % SPSA dispensa barreira
                ti=cputime;
                [Xfim(k,:),func(k),exitflg] = spsaca(X0');
                string=['SPSA2_',num2str(k)];
                %saveas(gcf, string, 'fig'); 
                elapsed_time(k)=(cputime-ti);
                Sims(k)=CountSim;

            case 9 % SIMULTANEOUS PERTURBATION STOCHASTIC APPROXIMATION (SPSA-  CB) 
                CountSim=0; % Contador de Simulacoes
                op_fbarrier=0; % SPSA dispensa barreira
                ti=cputime;
                [Xfim(k,:),func(k),exitflg] = spsacb(X0');
                string=['SPSA2_',num2str(k)];
                %saveas(gcf, string, 'fig'); 
                elapsed_time(k)=(cputime-ti);
                Sims(k)=CountSim;

            case 10 % SIMULTANEOUS PERTURBATION STOCHASTIC APPROXIMATION (SPSA-  CH) 
                CountSim=0; % Contador de Simulacoes
                op_fbarrier=0; % SPSA dispensa barreira
                ti=cputime;
                [Xfim(k,:),func(k),exitflg] = spsach(X0');
                string=['SPSA2_',num2str(k)];
                %saveas(gcf, string, 'fig'); 
                elapsed_time(k)=(cputime-ti);
                Sims(k)=CountSim;

            otherwise
                fprintf('OPÇAO DE OTIMIZAÇAO INVALIDA. TENTE OUTRA VEZ');
        end
    end %Multiplas Otimizaçoes
end

fclose('all');
%--------------------------------------------------------------------------
% 2.3 - ANALISE DE SENSIBILIDADE


%--------------------------------------------------------------------------
% 2.4 - Organização arquivos de saída

% namedir=(fileout(1:end-4);
% mkdir(fileout(1:end-4));
% movefile=(namedir*,

%--------------------------------------------------------------------------
% 3.0 - Exibicao dos Resultados
%--------------------------------------------------------------------------
% OutputResults(exitflg,output);
if op_output==1
    fid=1;
else
    [fid, msg] = fopen(fileout, 'w');
end
%clc
fprintf(fid,'\n-----------------------------------------------------------------\n');
fprintf(fid,'                          DOPPING\n');
fprintf(fid,' (D)ynamic (OP)timization of (P)rodution and (In)jection (G)roup\n');
fprintf(fid,'-----------------------------------------------------------------\n');
fprintf(fid,'DADOS');
fprintf(fid,'\n-----------------------------------------------------------------\n');
fprintf(fid,'Numero de Paramentros: %d\n',NPar);
fprintf(fid,'Parametros Economicos\n');
fprintf(fid,'Receita Liquida Unitaria do Oleo: %0.2f\n',R_Oleo_Produzido);
fprintf(fid,'Custo Unitario da Agua Produzida: %0.2f\n',C_Agua_Produzida);
fprintf(fid,'Custo Unitario da Agua Injetada: %0.2f\n',C_Agua_Injetada);
fprintf(fid,'Outros Custos: %0.2f\n',outros_custos);
fprintf(fid,'Taxa de Desconto: %0.2f%%\n',tma*100);
fprintf(fid,'Arquivos\n');
fprintf(fid,'Arquivo de Template: %s\n',filetpl);
fprintf(fid,'Arquivo de Paramentros de Controle Iniciais: %s\n',filepar);
fprintf(fid,'Arquivo de Output: %s\n',fileout);
fprintf(fid,'Arquivo de Simulacao: %s\n',filesim);

fprintf(fid,'\nRESULTADOS');        
switch op_exec
    case 1
        fprintf(fid,'\n-----------------------------------------------------------------\n');
        fprintf(fid,'Opcao de Execucao: SIMULACAO\n\n');
        fprintf(fid,'Valor da Funcao Objetivo: %0.2f',func);
        fprintf(fid,'\n-----------------------------------------------------------------\n');
    case 2
        fprintf(fid,'\n-----------------------------------------------------------------\n');
        fprintf(fid,'Opcao de Execucao: OTIMIZACAO\n\n');
        fprintf(fid,'Tolerancia na Funcao Objetivo: %0.5f\n',tolfun);
        fprintf(fid,'Tolerancia nos Parametros de Controle: %0.5f\n',tolx);
        for k=1:NOtim
            fprintf(fid,'\n***%do. Otimização\n',k);            
            fprintf(fid,'Status da Otimizaçao:');
            if exitflg(k) > 0
                fprintf(fid,' Convergencia atingida\n');
            else
                fprintf(fid,' NAO CONVERGIU!\nMaximo Numero de Iteraçoes atingido');
            end
            switch op_otim
                case 1
                    fprintf(fid,'\nAlgoritmo: Nelder-Mead Simplex');
                case 2
                    fprintf(fid,'\nAlgoritmo: Direct Pattern Search');
                case 3
                    fprintf(fid,'\nAlgoritmo: Derivative Free Optmization');
                case 4
                    fprintf(fid,'\nAlgoritmo: Evolucionary Genetic Algorithm');
                case 5
                    fprintf(fid,'\nAlgoritmo: Simultaneous Perturbation Stochastic Approximation');
            end
            
            %%%%%%%%%%%%%
            if (op_otim > 4 && op_otim < 11)
                
            fprintf(fid,'\nNumero de Simulacoes: %d',Sims(k));
            fprintf(fid,'\nTempo de Processamento: %f sec',elapsed_time(k));
            fprintf(fid,'\nSPSA não usa função barreira tradicional');
            fprintf(fid,'\nPonto Inicial:\n');
            fprintf(fid,'%0.2f\n',X0(k,:));
            fprintf(fid,'Ponto Final:\n');
            fprintf(fid,'%0.2f\n',Xfim(k,:));
            if op_minimax==2
                func0=-func0;
                func=-func;
            end
            fprintf(fid,'\nValor Inicial da Funçao Objetivo: %0.2f\n',func0(k));
            fprintf(fid,'Valor Final da Funcao Objetivo: %0.2f\n',func(k));
            fprintf(fid,'\n-----------------------------------------------------------------\n');
            fprintf(fid,'PARAMETROS FINAIS DE OTIMIZACAO\n');
            fprintf(fid,'%e\n',Xfim(k,:));
            fprintf(fid,'\n-------------');
            
                break
            end
            %%%%%%%%%%%%%
            
            if op_otim~=4
                fprintf(fid,'\nNumero de Iteracoes: %d',output(k).iterations);
            else
                fprintf(fid,'\nNumero de Geraçoes: %d',output(k).generations);
            end
            if op_otim==1
                fprintf(fid,'\nNumero de Simulacoes: %d',output(k).funcCount);
            else
                fprintf(fid,'\nNumero de Simulacoes: %d',output(k).funccount);
            end
            fprintf(fid,'\nNumero de Simulacoes: %d',Sims(k));
            fprintf(fid,'\nTempo de Processamento: %f sec',elapsed_time(k));
            fprintf(fid,'\nPonto Inicial:\n');
            fprintf(fid,'%0.2f\n',X0(k,:));
            fprintf(fid,'Ponto Final:\n');
            fprintf(fid,'%0.2f\n',X(k,:));
            if op_minimax==2
                func0=-func0;
                func=-func;
            end
            fprintf(fid,'\nValor Inicial da Funçao Objetivo: %0.2f\n',func0(k));
            fprintf(fid,'Valor Final da Funcao Objetivo: %0.2f\n',func(k));
            fprintf(fid,'\n-----------------------------------------------------------------\n');
            fprintf(fid,'PARAMETROS FINAIS DE OTIMIZACAO\n');
            fprintf(fid,'%e\n',X(k,:));
            fprintf(fid,'\n-----------------------------------------------------------------\n');
        end
end
if op_output==2
    fclose(fid);
end

%--------------------------------------------------------------------------
%end
%clear