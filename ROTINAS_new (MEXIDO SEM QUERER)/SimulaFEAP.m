function [esf, CORTANTE, MOMENTO, NORMAL]=SimulaFEAP(PORTICO, ELEMENTOS, DADOS)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCI�NCIAS
% PROGRAMA DE P�S-GRADUA��O EM ENGENHARIA CIVIL        - �REA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELE��O DE  M�DIA FIDELIDADE  PARA  AN�LISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO.
% ALUNA       S�rgio Jos� Priori Jovino Marques Filho
% ORIENTADOR  Prof. �zio da Rocha Ara�jo
% -------------------------------------------------------------------------
% DESCRI��O
% Rotina para processar o p�rtico chamando o FEAP 
% -------------------------------------------------------------------------
% MODIFICA��ES:         
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: PORTICO, ELEMENTOS, DADOS
% VARI�VEIS DE SA�DA:   esf: esfor�os nodais obtidos � partir do m�todo dos
%                       deslocamentos
%                       CORTANTE, MOMENTO: esfor�os internos nos elementos
%                       do p�rtico.
%--------------------------------------------------------------------------
% CRIADA EM 
% -------------------------------------------------------------------------
disp('SIMULA��O UTILIZANDO O FEAP')

%3.1 - MONTAGEM DO ARQUIVO DE SIMULACAO
% Para cada conjunto de valores das vari�veis aleat�rias,monta-se o arquivo
% de simula��o.
% Para cada arquivo de simula��o, o FEAP e os modelos VIGA,LAJE e PILAR s�o
% rodados e um valor da fun��o objetivo � calculado.


for m=1:DADOS.NMC

    PA_V=[]; VC_V=[]; Forma_V=[];%VIGA
    PA_P=[]; VC_P=[]; Forma_P=[];%PILAR

    if DADOS.op_montafile==1
       %C�lculo das propriedades geom�tricas.Em Calc_geom.m s�o calculadas as 
       %�reas e momentos de in�rcia das vigas, lajes e pilares.

       %Chamada da fun��o Calc_geom_carga.m para o c�clculo da geometria e
       %das cargas atuantes no p�rtico.
       [GEOM, CARGA]=Calc_geom(m, bvV, hvV, hpxV, hpyV, hlV, DADOS,PROP);

       %Montagem do arquivo de simula�ao para o PorticoOT
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
%3.3 - LEITURA DO ARQUIVO DE SA�DA DO FEAP
%L� deslocamentos e esfor�os do arquivo txt gerado na execu�ao do Feap.
Le_SaidaFEAP;
