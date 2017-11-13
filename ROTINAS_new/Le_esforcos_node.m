function [N,V,M] = Le_esforcos_node
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIENCIAS
% PROGRAMA DE POS-GRADUAÇAO EM ENGENHARIA CIVIL        - AREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELECAO DE  MEDIA FIDELIDADE  PARA  ANALISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO.
% ALUNA       Nilma Andrade
% ORIENTADOR  Prof. Ezio da Rocha Araujo
% -------------------------------------------------------------------------
% DESCRICAO
% Le o arquivo de saida do Feap e organiza os  esforços (normal, cortante
% e momento) em um arquivo.
% Rotina especifica para ler esforços nodais de elementos FRAME2D.
% Obs. No Feap deve ser usado o comando STREss NODE
% -------------------------------------------------------------------------
% ADAPTACAO DA ROTINA DE DIEGO OLIVEIRA 30-Janeiro-2006
% Criada      04-Agosto-2011              NILMA ANDRADE
%
% Modificada  
% 
% -------------------------------------------------------------------------
% 1-DEFINICAO DAS VARIÁVEIS GLOBAIS
%FAB - Remoção de variável global sem uso.
%global NPar;
global filesim;
global nnos;
%FAB - Essas variávels globais são também de retorno. Se necessário, criar
%outras com nomes diferentes.
%global N;
%global V;
%global M;

%*************************************************************************
%ATENCAO
%***********Por que definir filesim aqui se já foi definido antes?????????
filesim='simfeap.txt';
nnos=3;%ONDE COLOCO nnos????????????????????????????????????????????????
%*************************************************************************

% 2-LEITURA DO ARQUIVO DE SAIDA DO FEAP
%Prepara o nome do arquivo de saida do Feap para ser lido:
fileout=['O' filesim];%O prefixo O é utilizado nos arquivos de saída do Feap
%fileout é a variável que recebe o arquivo de saída do Feap
%Le o arquivo de saida do Feap:
%FAB - Remoção de variável sem uso.
%[fidfileout,msg]=fopen(fileout, 'r');
[fidfileout,~]=fopen(fileout, 'r');
%Monta um arquivo (previo) com os esforcos,que sera refinado no proximo
%item:
while ~feof(fidfileout)   %Loop até o final do arquivo de saída do Feap
    str=fgets(fidfileout); %Le cada linha do arquivo de saída do Feap
    %FAB - Uso de função melhor (strfind). Remoção de variável sem uso.
    %mac3=findstr(str,'*Macro   3');%Procura os caracteres *Macro 3
    %mac3=strfind(str,'*Macro   3');%Procura os caracteres *Macro 3
    %FAB - Troca para função mais eficiente.
    %if ~isempty(mac3)%Se encontrar *Macro 3, entra no if
    if contains(str,'*Macro   3')%Se encontrar *Macro 3, entra no if
        for k=1:10   %Retira as 10 primeiras linhas ("lixo")após *Macro 3
            %FAB - Somente lê.
            %lixo=fgets(fidfileout);
            fgets(fidfileout);
        end %Escreve um novo arquivo de saída, apenas com as linhas
            %contendo os esforcos
            %FAB - Remoção de variável sem uso.
        %[A,count]=fscanf(fidfileout,'%e',11*nnos);
        [A,~]=fscanf(fidfileout,'%e',11*nnos);
        break%Após ter montado o arquivo apenas com os esforcos,interrompe o loop
    end
end

%3-MONTAGEM DOS VETORES COM OS ESFORCOS SOLICITANTES
%Retira apenas os esforcos normal,cortante e momento do arquivo de saída
%do Feap e os organiza em vetores:
%FAB - Prealocação de matrizes e otimização do loop.
N = zeros(nnos, 1);
V = zeros(nnos, 1);
M = zeros(nnos, 1);
for ii=1:nnos
%     Nnnos(ii)=A(ii*11-2);     %Esforço normal
%     Vnnos(ii)=A(ii*11-1);     %Esforço cortante
%     Mnnos(ii)=A(ii*11);       %Momento
%     N(:,ii)=Nnnos(ii);        %Vetor com esforco normal
%     V(:,ii)=Vnnos(ii);        %Vetor com esforco cortante
%     M(:,ii)=Mnnos(ii);        %Vetor com momento
    N(:,ii)=A(ii*11-2);        %Vetor com esforco normal
    V(:,ii)=A(ii*11-1);        %Vetor com esforco cortante
    M(:,ii)=A(ii*11);          %Vetor com momento
end



