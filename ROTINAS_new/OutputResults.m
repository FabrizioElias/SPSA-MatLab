function OutputResults(exitflg,output)
% OUTPUTRESULTS: Escreve resultados e Pos-processa-os.
% --------------------------------------------------------------------------
% OutputResults
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
% Criado:        06-Fev-2006      Diego Oliveira
%
% Moficaçao: 
%
% --------------------------------------------------------------------------
% Definicoes
% Arquivos
global filetpl;
global filepar;
global fileout;
global filesim;
% Opcoes
global op_tp_fob;
global op_minimax;
global op_montafile;
global op_exec;
global op_otim;
global op_fbarrier;
global op_output;
% Dados e Controladores
global NPar;
global CountSim;
global Xmin Xmax;
global NameX NameXS;
% Producoes
global Oleo_Produzido_Ac;
global Agua_Produzida_Ac;
global Agua_Injetada_Ac;
global Dias;
% Precos e Custos
global R_Oleo_Produzido;
global C_Agua_Produzida;
global C_Agua_Injetada;
global outros_custos;
global tma;
% Parametros de Otimizacao
global tolfun;
global tolx;
% Outros
global elapsed_time

if op_output==1
    fid=1;
else
    [fid, msg] = fopen(fileout, 'w');
end;
%clc
fprintf(fid,'\n-----------------------------------------------------------------\n');
fprintf(fid,'                          DOPPING\n');
fprintf(fid,' (D)ynamic (OP)timization of (P)rodution and (In)jection (G)roup\n');
fprintf(fid,'-----------------------------------------------------------------\n');
fprintf(fid,'DADOS\n');
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

fprintf(fid,'RESULTADOS\n');        
switch op_exec
    case 1
        fprintf(fid,'\n-----------------------------------------------------------------\n');
        fprintf(fid,'Opcao de Execucao: SIMULACAO\n\n');
        fprintf(fid,'Valor da Funcao Objetivo: %0.2f',func);
        fprintf(fid,'\n-----------------------------------------------------------------\n');
    case 2
        fprintf(fid,'\n-----------------------------------------------------------------\n');
        fprintf(fid,'Opcao de Execucao: OTIMIZACAO\n\n');
        fprintf(fid,'Tolerancia na Funcao Objetivo: %0.5\n',tolfun);
        fprintf(fid,'Tolerancia nos Paramentros de COntrole: %0.5\n',tolx);
        fprintf(fid,'Status da Otimizaçao:');
        if exitflg > 0
            fprintf(fid,' Convergencia atingida\n');
        else
            fprintf(fid,' NAO CONVERGIU!\nMaximo Numero de Iteraçoes atingido');
        end
        fprintf(fid,'\nAlgoritmo: %s',output.algorithm);        
        fprintf(fid,'\nNumero de Iteracoes: %d',output.iterations);
        fprintf(fid,'\nNumero de Simulacoes: %d',output.funcCount);
        fprintf(fid,'\nNumero de Simulacoes: %d',CountSim);
        fprintf(fid,'\nTempo de Processamento: %f',elapsed_time);
        fprintf(fid,'\nPonto Inicial:\n');
        fprintf(fid,'%0.2f\n',X0);
        fprintf(fid,'Ponto Final:\n');
        fprintf(fid,'%0.2f\n',X);
        if op_minimax==2
            func0=-func0;
            func=-func;
        end
        fprintf(fid,'\nValor Inicial da Funçao Objetivo: %0.2f\n',func0);
        fprintf(fid,'Valor Final da Funcao Objetivo: %0.2f\n',func);
        fprintf(fid,'\n-----------------------------------------------------------------\n');
        fprintf(fid,'PARAMETROS FINAIS DE OTIMIZACAO%f\n',X);
        fprintf(fid,'%f\n',X);
        fprintf(fid,'\n-----------------------------------------------------------------\n');        
end
if op_output==2
    fclose(fid);
end;

