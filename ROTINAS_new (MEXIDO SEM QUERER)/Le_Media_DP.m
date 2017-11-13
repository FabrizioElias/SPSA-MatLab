function [ELEMENTOS]=Le_Media_DP(DADOS, PORTICO)

% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIENCIAS
% PROGRAMA DE POS-GRADUACAO EM ENGENHARIA CIVIL        - AREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELECAO DE  MEDIA FIDELIDADE  PARA  ANALISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO.
% ALUNO       Sérgio Marques
% ORIENTADOR  Prof. Ezio da Rocha Araujo
% -------------------------------------------------------------------------
% DESCRIÇÃO
% Rotina para leitura das propriedades físicas e geométricas do pórtico a
% ser analisado.
%--------------------------------------------------------------------------
% MODIFICAÇÕES - Sérgio Marques
% Essa rotina foi alterada por de forma que não mais é feita nenhum
% distinção entre os elementos estruturais, vigas pilares e lajes.
% Posteriormente, caso necessário, uma rotina adicional será criada para
% identificar cada um deles e efetuar o seu dimensionamento de forma
% adequada.
% ---------------------------------------------------
% VARIÁVEIS DE ENTRADA: DADOS
% VARIÁVEIS DE SAÍDA:   ELEMENTOS - contem o valor médio e o desvio padrão
% das propriedades físicas e geometria de cada elemento do pórtico.
% -------------------------------------------------------------------------
% ADAPTAÇÃO DA ROTINA DE DIEGO OLIVEIRA 30-Janeiro-2006
% Modificada      04-Agosto-2011              NILMA ANDRADE
% Modificada      13-Janeiro-2015             SÉRGIO MARQUES  
% -------------------------------------------------------------------------
% 1-DEFINICAO DAS VARIAVEIS GLOBAIS
%
%global filepar7 filepar8 filepar9;

%Variáveis do MODELO_VIGA
%global bvm sigma_bv hvm sigma_hv;

%Variáveis do MODELO_PILAR
%global hpxm sigma_hpx hpym sigma_hpy;

%Variáveis do MODELO_LAJE
%global hlm sigma_hl ;

[fidinc7, msg] = fopen(DADOS.filepar7,'r');%Abre o arquivo com as médias e DP dos elementos 
% [fidinc8, msg] = fopen(DADOS.filepar8,'r');%Abre o arquivo com as médias e DP dos pilares
% [fidinc9, msg] = fopen(DADOS.filepar9,'r');%Abre o arquivo com as médias e DP das lajes 

%2 - LEITURA DOS VALORES MÉDIOS E DESVIOS PADRÕES
% Leitura das médias e desvios padrões das propriedades geométricas de todas
% as vigas e pilares


ELEMENTOS.secao=zeros(PORTICO.nelem,2);      %Matriz contendo as seções transversais dos elementos
ELEMENTOS.dp=zeros(PORTICO.nelem,2);         %Matriz contendo os DP das seções dos elementos
ELEMENTOS.E=zeros(PORTICO.nelem,1);          %Matriz contendo o módulo de elastiicidade dos elementos
while ~feof(fidinc7)
        for k=1:7
            lixo=fgets(fidinc7);
        end
        for i=1:PORTICO.nelem
            X=fgets(fidinc7);
            aux = str2num(X);
            ELEMENTOS.secao(i,1)=aux(1,2);
            ELEMENTOS.secao(i,2)=aux(1,3);
            ELEMENTOS.dp(i,1)=aux(1,4);
            ELEMENTOS.dp(i,2)=aux(1,5);
            ELEMENTOS.E(i,1)=aux(1,6);
            ELEMENTOS.classe(i,1)=aux(1,7);
        end
end

fclose(fidinc7);









