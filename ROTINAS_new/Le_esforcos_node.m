function [N,V,M] = Le_esforcos_node
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIENCIAS
% PROGRAMA DE POS-GRADUA�AO EM ENGENHARIA CIVIL        - AREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELECAO DE  MEDIA FIDELIDADE  PARA  ANALISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO.
% ALUNA       Nilma Andrade
% ORIENTADOR  Prof. Ezio da Rocha Araujo
% -------------------------------------------------------------------------
% DESCRICAO
% Le o arquivo de saida do Feap e organiza os  esfor�os (normal, cortante
% e momento) em um arquivo.
% Rotina especifica para ler esfor�os nodais de elementos FRAME2D.
% Obs. No Feap deve ser usado o comando STREss NODE
% -------------------------------------------------------------------------
% ADAPTACAO DA ROTINA DE DIEGO OLIVEIRA 30-Janeiro-2006
% Criada      04-Agosto-2011              NILMA ANDRADE
%
% Modificada  
% 
% -------------------------------------------------------------------------
% 1-DEFINICAO DAS VARI�VEIS GLOBAIS
global NPar;
global filesim;
global nnos;
global N;
global V;
global M;

%*************************************************************************
%ATENCAO
%***********Por que definir filesim aqui se j� foi definido antes?????????
filesim='simfeap.txt';
nnos=3;%ONDE COLOCO nnos????????????????????????????????????????????????
%*************************************************************************

% 2-LEITURA DO ARQUIVO DE SAIDA DO FEAP
%Prepara o nome do arquivo de saida do Feap para ser lido:
fileout=['O' filesim];%O prefixo O � utilizado nos arquivos de sa�da do Feap
%fileout � a vari�vel que recebe o arquivo de sa�da do Feap
%Le o arquivo de saida do Feap:
[fidfileout,msg]=fopen(fileout, 'r');
%Monta um arquivo (previo) com os esforcos,que sera refinado no proximo
%item:
while ~feof(fidfileout);   %Loop at� o final do arquivo de sa�da do Feap
    str=fgets(fidfileout); %Le cada linha do arquivo de sa�da do Feap
    mac3=findstr(str,'*Macro   3');%Procura os caracteres *Macro 3
    if ~isempty(mac3)%Se encontrar *Macro 3, entra no if
        for k=1:10   %Retira as 10 primeiras linhas ("lixo")ap�s *Macro 3
            lixo=fgets(fidfileout);
        end %Escreve um novo arquivo de sa�da, apenas com as linhas
            %contendo os esforcos 
        [A,count]=fscanf(fidfileout,'%e',11*nnos);
        break%Ap�s ter montado o arquivo apenas com os esforcos,interrompe o loop
    end
end

%3-MONTAGEM DOS VETORES COM OS ESFORCOS SOLICITANTES
%Retira apenas os esforcos normal,cortante e momento do arquivo de sa�da
%do Feap e os organiza em vetores:
for ii=1:nnos
    Nnnos(ii)=A(ii*11-2);     %Esfor�o normal
    Vnnos(ii)=A(ii*11-1);     %Esfor�o cortante
    Mnnos(ii)=A(ii*11);       %Momento
    N(:,ii)=Nnnos(ii);        %Vetor com esforco normal
    V(:,ii)=Vnnos(ii);        %Vetor com esforco cortante
    M(:,ii)=Mnnos(ii);        %Vetor com momento
end



