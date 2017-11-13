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
% Fun��o para execu��o do Feap.

global filesim;
global CountSim
CountSim=0;
% Chama o Feap e lhe informa o arquivo de entrada, que � o arquivo de
% simulacao preparado em MontafileS.m.Faz-se uma c�pia de simfepa.txt para
% Isimfeap.txt j� que os arquivos de entrada do Feap precisam da letra I no
% in�cio.
copyfile('simfeap.txt','Isimfeap.txt');

comando=['feap.bat -iI' filesim];
% Em feap.bat encontra-se o "caminho" para executar o feap. A vari�vel comando
% monta o "caminho" com o arquivo de simula��o (que � o arquivo de entrada do feap).
% iI - prefixo espec�fico do Feap, necess�rio nos arquivos de entrada do Feap
%FAB - Remo��o de vari�vel sem uso.
%[status, currdir] = system(comando);
[status, ~] = system(comando);
if status~=0
    disp('ATEN��O. A SIMULA��O N�O FOI REALIZADA.') 
    disp('O FEAP N�O FOI EXECUTADO.HOUVE UM ERRO NA EXECU��O DO FEAP')
end
CountSim=CountSim+1; %Contador para as simulacoes.

% Se status for igual a 0, a simulacao foi realizada
% Se o Feap foi executado com exito, foi gerado um arquivo de sa�da com o
% prefixo O. O nome deste arquivo � Ofilesim.txt.