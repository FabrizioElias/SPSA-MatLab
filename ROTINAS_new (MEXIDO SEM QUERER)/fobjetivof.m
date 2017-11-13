function [N,V,M] = fobjetivof(X)

% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIENCIAS
% PROGRAMA DE POS-GRADUACAO EM ENGENHARIA CIVIL        - AREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELECAO DE  MÉDIA FIDELIDADE  PARA  ANÁLISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO.
% ALUNA       Nilma Andrade
% ORIENTADOR  Prof. Ezio da Rocha Araujo
% -------------------------------------------------------------------------
% DESCRIÇÃO
% Calcula o valor da funcao objetivo
% Opcao de Loop Interno de Monte Carlo
% f - fobjetivo(X)
% f - Valor da funcao objetivo calculada    (out)
% X - Parametros                            (in)             
% -------------------------------------------------------------------------
% ADAPTACAO DA ROTINA DE DIEGO OLIVEIRA 30-Janeiro-2006
% Criada      04-Agosto-2011              NILMA ANDRADE
%
% Modificada 
% 
% -------------------------------------------------------------------------
% 1-DEFINICAO DAS VARIÁVEIS GLOBAIS
% FOBJETIVOF: calcula o valor da funcao objetivo, considerando minimizacao.
% Opcao de Loop Interno de Monte Carlo
% -------------------------------------------------------------------------
% f = fobjetivo(X)
%
% f        -  valor da funcao objetivo calculada                       (out)
%
% X        -  parametros                                                (in)
% -------------------------------------------------------------------------
% 1-DEFINICAO DAS VARIÁVEIS GLOBAIS

%global op_tp_fob;
%global op_exec;
%global op_otim;
%global op_minimax;
global op_montafile; global op_fbarrier; global tma; global NPar;
global filepar filesim fileout; 

global namedir; global op_restr;
global f_mc; global varfmc; global stdfmc; global covfmc;
global covb; global stdb; global delcov; global freal; global NMC; global op_mc;
global Dias; global Diasmax; global fdias; global vfdias; global vdiasmax;

global N; global V%global X;

%--------------------------------------------------------------------------
%2 - LOOP INTERNO - MONTE CARLO
%fazer monte carlo em outra rotina*****************************************
if op_mc == 0
    NMC = 1;
end  
%--------------------------------------------------------------------------
%3 - CHAMADA DO MODELO SIMPLIFICADO

%************ CALCULO DOS PARAMETROS

%Execução da Função Objetivo 
% switch op_tp_fob
%     case 1
%         f=VIGA(i);           %Viga
%     case 2
%         f=PILAR;             %Pilar
%     case 3
%         f=LAJE(i);           %Laje
%     case 6
%         f=EDIFICIO(X);       %Edificio
%     case 7
%         f=expg9(X);         %Teste
%     otherwise
%         f=NaN;
% end
%--------------------------------------------------------------------------

%Imprime resultados de otimização: NM, PSA, GA (Diego) 'em arquivo.res'

% OBSERVACAO LAF :&&&&& TALVEZ USAR ESTA LOGICA PARA IMPRIMIR OS RESULTADOS 
% DO FEAP OU MODELO EM UM ARQUIVO .res (ARQUIVO DE RESPOSTA) &&&&&&&&&&&&&&

% fileres = 'simulacao.ite';
% [fidres, msg] = fopen(fileres, 'a');
% if CountSim==1
%     fprintf(fidres,'Sim.\t');
%     for kk=1:NPar
%         fprintf(fidres,'\t');
%     end
%     fprintf(fidres,'Func.Obj.\n');
% end
% fprintf(fidres,'%d\t',CountSim);
% for kk=1:NPar
%     fprintf(fidres,'%0.2f\t',X(kk));
% end
% fprintf(fidres,'%0.0f\n',f);
% fclose(fidres);
%--------------------------------------------------------------------------
    
% if (op_minimax==2)&(op_exec==2)
%     
% %     f=-f;
% %     L=-L;
% end
