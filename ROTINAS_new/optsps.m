function options = optsps()
% OPTSPS: Define a estrutura de opções para PS.
% --------------------------------------------------------------------------
% options = optsps
%
% options  -  estrutura de dados das opcoes para PS                     (in)
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
global tolfun;
global tolx;

options = psoptimset('TolMesh',0.1*tolx);
%     TolMesh              - Tolerance on mesh size used to terminate the
%   	                        iteration 
%                            [ positive scalar | {1e-6} ]
options = psoptimset(options,'TolFun',tolfun);
%     TolFun               - Tolerance on Fun used to terminate the iteration
%                            [ positive scalar | {1e-6} ] 
options = psoptimset(options,'TolX',tolx);
%     TolX                 - Tolerance on X used to terminate the iteration
%                            [ positive scalar | {1e-6} ] 
options = psoptimset(options,'TolBind',1e-3);
%     TolBind              - Binding Tolerance
%                            [ positive scalar | {1e-3} ]
options = psoptimset(options,'MaxIteration',50*NPar);
%     MaxIteration         - Maximum number of iterations allowed 
%                            [ positive scalar | {100*numberOfVariables} ]
options = psoptimset(options,'MaxFunEvals',1000*NPar);
%     MaxFunEvals          - Maximum number of function (objective)
%   	                        evaluations allowed 
%                            [ positive scalar | {2000*numberOfVariables} ]
%   	
options = psoptimset(options,'MeshContraction',0.5);
%     MeshContraction      - Mesh refining factor used when an iteration is not
%                            successful 
%                            [ positive scalar | {0.5} ]
options = psoptimset(options,'MeshExpansion',2.0);
%     MeshExpansion        - Mesh coarsening factor used when an iteration is
%                            successful 
%                            [ positive scalar | {2.0} ] 
options = psoptimset(options,'MeshAccelerator','off');
%     MeshAccelerator      - Accelerate convergence when near a minima (may
%                            lose some accuracy)
%                            [ 'on',{'off'} ]
options = psoptimset(options,'MeshRotate','on');
%     MeshRotate           - Rotate the pattern before declaring a point to
%                            be optimum
%                            [ 'off',{'on'} ]
options = psoptimset(options,'InitialMeshSize',1.0);
%     InitialMeshSize      - Initial mesh size at start
%                            [ positive scalar | {1.0} ]
options = psoptimset(options,'ScaleMesh','on');
%     ScaleMesh            - Mesh is scaled if 'on'
%                            [ 'off', {'on'} ]
options = psoptimset(options,'MaxMeshSize',Inf);
%     MaxMeshSize          - Maximum mesh size used in a POLL/SEARCH step
%                            [ positive scalar | {Inf} ]
%   	
options = psoptimset(options,'PollMethod','PositiveBasis2N');
%     PollMethod           - Polling method
%                            [ 'PositiveBasisNp1' | {'PositiveBasis2N'} ]
options = psoptimset(options,'CompletePoll','off');
%     CompletePoll         - Complete polling around the current iterate
%                            [ 'on',{'off'} ]
options = psoptimset(options,'PollingOrder','Consecutive');
%     PollingOrder         - Ordering of the POLL directions
%                            [ 'Random' |'Success'| {'Consecutive'} ]
%   	
options = psoptimset(options,'SearchMethod',[]);
%     SearchMethod         - Search method
%                            [ @PositiveBasisNp1 | @PositiveBasis2N  |
%                              @searchlhs        | @searchneldermead | 
%                              @searchga         | {[]} ]
options = psoptimset(options,'CompleteSearch','off');
%     CompleteSearch       - Complete search around the current iterate
%                            [ 'on',{'off'} ]
%  
options = psoptimset(options,'Display','final');
%     Display              - Level of display 
%                            [ 'off' | 'iter' | 'diagnose' | {'final'} ]
options = psoptimset(options,'OutputFcns',[]);
%     OutputFcns           - A set of functions called in every iteration 
%                            [ @psoutputhistory| {[]} ]
options = psoptimset(options,'PlotFcns',{@psplotbestf,@psplotmeshsize,@psplotfuncount,@psplotbestx});
%     PlotFcns             - A set of specialized plot functions called in
%                            every iteration 
%                            [ @psplotbestf    |  @psplotmeshsize | 
%                              @psplotfuncount |  @psplotbestx    | {[]} ]
options = psoptimset(options,'PlotInterval',1);
%     PlotInterval         - Plot functions will be called every interval
%                            [ {1} ]
options = psoptimset(options,'Cache','off');
%     Cache                - Use a CACHE of the points evaluated. This
%   	                        options could be expensive in terms of memory 
%                            and speed . If the objective function is
%                            stochastic, it is advised not to use this option.
%                            [ 'on', {'off'} ]
options = psoptimset(options,'CacheSize',1e4);
%     CacheSize            - Limit the CACHE size. A typical choice of 1e4 is
%                            suggested but it depends on computer speed and 
%                            memory. Used if 'Cache' option is 'on'.
%                            [ positive scalar | {1e4} ]
options = psoptimset(options,'CacheTol',eps);
%     CacheTol             - Tolerance used to determine if two points are
%                            close enough to be declared same. 
%                            Used if 'Cache' option is 'on'. 
%                            [ positive scalar | {eps} ]
%   	
options = psoptimset(options,'Vectorized','off');
%     Vectorized           - Objective function is vectorized and it can
%                            evaluate more than one point in one call 
%                            [ 'on' | {'off'} ]