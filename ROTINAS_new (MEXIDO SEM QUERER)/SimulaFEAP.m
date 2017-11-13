function [esf, CORTANTE, MOMENTO, NORMAL]=SimulaFEAP(PORTICO, ELEMENTOS, DADOS)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIÊNCIAS
% PROGRAMA DE PÓS-GRADUAÇÃO EM ENGENHARIA CIVIL        - ÁREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELEÇÃO DE  MÉDIA FIDELIDADE  PARA  ANÁLISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO.
% ALUNA       Sérgio José Priori Jovino Marques Filho
% ORIENTADOR  Prof. Ézio da Rocha Araújo
% -------------------------------------------------------------------------
% DESCRIÇÃO
% Rotina para processar o pórtico chamando o FEAP 
% -------------------------------------------------------------------------
% MODIFICAÇÕES:         
%--------------------------------------------------------------------------
% VARIÁVEIS DE ENTRADA: PORTICO, ELEMENTOS, DADOS
% VARIÁVEIS DE SAÍDA:   esf: esforços nodais obtidos à partir do método dos
%                       deslocamentos
%                       CORTANTE, MOMENTO: esforços internos nos elementos
%                       do pórtico.
%--------------------------------------------------------------------------
% CRIADA EM 
% -------------------------------------------------------------------------
disp('SIMULAÇÃO UTILIZANDO O FEAP')

%3.1 - MONTAGEM DO ARQUIVO DE SIMULACAO
% Para cada conjunto de valores das variáveis aleatórias,monta-se o arquivo
% de simulação.
% Para cada arquivo de simulação, o FEAP e os modelos VIGA,LAJE e PILAR são
% rodados e um valor da função objetivo é calculado.


for m=1:DADOS.NMC

    PA_V=[]; VC_V=[]; Forma_V=[];%VIGA
    PA_P=[]; VC_P=[]; Forma_P=[];%PILAR

    if DADOS.op_montafile==1
       %Cálculo das propriedades geométricas.Em Calc_geom.m são calculadas as 
       %áreas e momentos de inércia das vigas, lajes e pilares.

       %Chamada da função Calc_geom_carga.m para o cáclculo da geometria e
       %das cargas atuantes no pórtico.
       [GEOM, CARGA]=Calc_geom(m, bvV, hvV, hpxV, hpyV, hlV, DADOS,PROP);

       %Montagem do arquivo de simulaçao para o PorticoOT
       MontafileS(GEOM, CARGA, DADOS);
    end
end

%3.2 - EXECUTA FEAP
%Roda o programa Feap. O arquivo de entrada foi gerado em MontafileS.m
CountSim=0;%
% pause on;
% pause (10);
% pause off;
Feap_exe
%3.3 - LEITURA DO ARQUIVO DE SAÍDA DO FEAP
%Lê deslocamentos e esforços do arquivo txt gerado na execuçao do Feap.
Le_SaidaFEAP;
