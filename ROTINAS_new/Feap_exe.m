function Feap_exe
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIENCIAS
% PROGRAMA DE POS-GRADUACAO EM ENGENHARIA CIVIL        - AREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELECAO DE  MEDIA FIDELIDADE  PARA  ANALISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO
% ALUNA       Nilma Andrade
% ORIENTADOR  Prof. Ezio da Rocha Araujo
% -------------------------------------------------------------------------
% DESCRICAO
% Função para execução do Feap.

global filesim;
global CountSim
CountSim=0;
% Chama o Feap e lhe informa o arquivo de entrada, que é o arquivo de
% simulacao preparado em MontafileS.m.Faz-se uma cópia de simfepa.txt para
% Isimfeap.txt já que os arquivos de entrada do Feap precisam da letra I no
% início.
copyfile('simfeap.txt','Isimfeap.txt');

comando=['feap.bat -iI' filesim];
% Em feap.bat encontra-se o "caminho" para executar o feap. A variável comando
% monta o "caminho" com o arquivo de simulação (que é o arquivo de entrada do feap).
% iI - prefixo específico do Feap, necessário nos arquivos de entrada do Feap
%FAB - Remoção de variável sem uso.
%[status, currdir] = system(comando);
[status, ~] = system(comando);
if status~=0
    disp('ATENÇÃO. A SIMULAÇÃO NÃO FOI REALIZADA.') 
    disp('O FEAP NÃO FOI EXECUTADO.HOUVE UM ERRO NA EXECUÇÃO DO FEAP')
end
CountSim=CountSim+1; %Contador para as simulacoes.

% Se status for igual a 0, a simulacao foi realizada
% Se o Feap foi executado com exito, foi gerado um arquivo de saída com o
% prefixo O. O nome deste arquivo é Ofilesim.txt.