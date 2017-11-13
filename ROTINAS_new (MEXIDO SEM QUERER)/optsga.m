function options = optsga()
% OPTSGA: Define a estrutura de opções para GA.
% --------------------------------------------------------------------------
% options = optsga
%
% options  -  estrutura de dados das opcoes para GA                     (in)
%
% --------------------------------------------------------------------------
% -------------------------------------------------------------------------
% OTIMIZACAO DINAMICA DAS VAZOES DE PRODUCAO E INJECAO EM POCOS DE PETROLEO
% -------------------------------------------------------------------------
% Universidade Federal de Pernambuco
% Programa de Pos-Graduaçao Engenharia Civil / Estruturas
%
% Petrobras
% Centro de Pesquisas - CENPES
% 
% --------------------------------------------------------------------------
% Criado:        15-Abr-2006      Diego Oliveira
%
% Moficaçao:     
% --------------------------------------------------------------------------

global NPar;
global facmin facmaxP facmaxI;

% Estão aqui listados todos os valores Defaults.
options = gaoptimset('PopulationType','doubleVector');
%     PopulationType      - The type of Population being entered
%                         [ 'bitstring' | 'custom' | {'doubleVector'} ]
options = gaoptimset(options,'PopInitRange',[facmin;min(facmaxP,facmaxI)]);
%     PopInitRange        - Initial range of values a population may have
%                         [ Matrix  | {[0;1]} ]
options = gaoptimset(options,'PopulationSize',max(20,NPar));
%     PopulationSize      - Positive scalar indicating the number of individuals
%                         [ positive scalar | {20} ]
options = gaoptimset(options,'EliteCount',round(0.1*max(20,NPar)));
%     EliteCount          - Number of best individuals that survive to next 
%                           generation without any change
%                         [ positive scalar | {2} ]
options = gaoptimset(options,'CrossoverFraction',0.8);
%     CrossoverFraction   - The fraction of genes swapped between individuals
%                         [ positive scalar | {0.8} ]
options = gaoptimset(options,'MigrationDirection','forward');
%     MigrationDirection  - Direction that fittest individuals from the various
%                           sub-populations may migrate to other sub-populations
%                         ['both' | {'forward'}]  
options = gaoptimset(options,'MigrationInterval',20);
%     MigrationInterval   - The number of generations between the migration of
%                           the fittest individuals to other sub-populations
%                         [ positive scalar | {20} ]
options = gaoptimset(options,'MigrationFraction',0.2);
%     MigrationFraction   - Fraction of those individuals scoring the best
%                           that will migrate
%                         [ positive scalar | {0.2} ]
options = gaoptimset(options,'Generations',5*NPar);
%     Generations         - Number of generations to be simulated
%                         [ positive scalar | {100} ]
options = gaoptimset(options,'TimeLimit',Inf);
%     TimeLimit           - The total time (in seconds) allowed for simulation
%                         [ positive scalar | {INF} ]
options = gaoptimset(options,'FitnessLimit',-Inf);
%     FitnessLimit        - The lowest allowed score
%                         [ scalar | {-Inf} ]
options = gaoptimset(options,'StallGenLimit',50);
%     StallGenLimit       - If after this number of generations there is
%                           no improvement, the simulation will end
%                         [ positive scalar | {50} ]
options = gaoptimset(options,'StallTimeLimit',Inf);
%     StallTimeLimit      - If after this many seconds there is no improvement,
%                           the simulation will end
%                         [ positive scalar | {20} ]
options = gaoptimset(options,'InitialPopulation',[]);
%     InitialPopulation   - The initial population used in seeding the GA
%                           algorithm
%                         [ Matrix | {[]} ]
options = gaoptimset(options,'InitialScores',[]);
%     InitialScores       - The initial scores used to determine fitness; used
%                           in seeding the GA algorithm
%                         [ column vector | {[]} ]
%                         [ positive scalar | {1} ]
options = gaoptimset(options,'CreationFcn',@gacreationuniform);
%     CreationFcn         - Function used to generate initial population
%                         [ {@gacreationuniform} ]
options = gaoptimset(options,'FitnessScalingFcn',@fitscalingrank);
%     FitnessScalingFcn   - Function used to scale fitness scores.
%                         [ @fitscalingshiftlinear | @fitscalingprop | @fitscalingtop |
%                           {@fitscalingrank} ]
options = gaoptimset(options,'SelectionFcn',@selectionstochunif);
%     SelectionFcn        - Function used in selecting parents for next generation
%                         [ @selectionremainder | @selectionrandom | 
%                           @selectionroulette  |  @selectiontournament | 
%                           {@selectionstochunif} ]
options = gaoptimset(options,'CrossoverFcn',@crossoverscattered);
%     CrossoverFcn        - Function used to do crossover
%                         [ @crossoverheuristic | @crossoverintermediate | 
%                           @crossoversinglepoint | @crossovertwopoint | 
%                           {@crossoverscattered} ]
options = gaoptimset(options,'MutationFcn',@mutationgaussian);
%     MutationFcn         - Function used in mutating genes
%                         [ @mutationuniform | {@mutationgaussian} ]
options = gaoptimset(options,'HybridFcn',[]);
%     HybridFcn           - Another optimization function to be used once GA 
%                           has normally terminated (for whatever reason)
%                         [ @fminsearch | @patternsearch | @fminunc | {[]} ]
options = gaoptimset(options,'Display','final');
%     Display              - Level of display 
%                         [ 'off' | 'iter' | 'diagnose' | {'final'} ]
options = gaoptimset(options,'OutputFcns',[]);
%     OutputFcns          - Function(s) called in every generation. This is more   
%                           general than PlotFcns.
%                         [ @gaoutputgen | {[]} ]
options = gaoptimset(options,'PlotFcns',...
                              {@gaplotbestf,@gaplotbestindiv,@gaplotdistance,@gaplotrange});
%     PlotFcns            - Function(s) used in plotting various quantities 
%                           during simulation
%                         [ @gaplotbestf | @gaplotbestindiv | @gaplotdistance | 
%                           @gaplotexpectation | @gaplotgenealogy | @gaplotselection |
%                           @gaplotrange | @gaplotscorediversity  | @gaplotscores | 
%                           @gaplotstopping | {[]} ]
options = gaoptimset(options,'PlotInterval',1);
%     PlotInterval        - The number of generations between plotting results
%                         [ positive scalar | {1} ]
options = gaoptimset(options,'Vectorized','off');
%     Vectorized           - Objective function is vectorized and it can evaluate
%                           more than one point in one call 
%                         [ 'on' | {'off'} ]