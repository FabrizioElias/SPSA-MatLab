function [ELEMENTOS]=Le_Media_DP(DADOS, PORTICO)

% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIENCIAS
% PROGRAMA DE POS-GRADUACAO EM ENGENHARIA CIVIL        - AREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELECAO DE  MEDIA FIDELIDADE  PARA  ANALISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO.
% ALUNO       S�rgio Marques
% ORIENTADOR  Prof. Ezio da Rocha Araujo
% -------------------------------------------------------------------------
% DESCRI��O
% Rotina para leitura das propriedades f�sicas e geom�tricas do p�rtico a
% ser analisado.
%--------------------------------------------------------------------------
% MODIFICA��ES - S�rgio Marques
% Essa rotina foi alterada por de forma que n�o mais � feita nenhum
% distin��o entre os elementos estruturais, vigas pilares e lajes.
% Posteriormente, caso necess�rio, uma rotina adicional ser� criada para
% identificar cada um deles e efetuar o seu dimensionamento de forma
% adequada.
% ---------------------------------------------------
% VARI�VEIS DE ENTRADA: DADOS
% VARI�VEIS DE SA�DA:   ELEMENTOS - contem o valor m�dio e o desvio padr�o
% das propriedades f�sicas e geometria de cada elemento do p�rtico.
% -------------------------------------------------------------------------
% ADAPTA��O DA ROTINA DE DIEGO OLIVEIRA 30-Janeiro-2006
% Modificada      04-Agosto-2011              NILMA ANDRADE
% Modificada      13-Janeiro-2015             S�RGIO MARQUES  
% -------------------------------------------------------------------------
% 1-DEFINICAO DAS VARIAVEIS GLOBAIS
%
%global filepar7 filepar8 filepar9;

%Vari�veis do MODELO_VIGA
%global bvm sigma_bv hvm sigma_hv;

%Vari�veis do MODELO_PILAR
%global hpxm sigma_hpx hpym sigma_hpy;

%Vari�veis do MODELO_LAJE
%global hlm sigma_hl ;

[fidinc7, msg] = fopen(DADOS.filepar7,'r');%Abre o arquivo com as m�dias e DP dos elementos 
% [fidinc8, msg] = fopen(DADOS.filepar8,'r');%Abre o arquivo com as m�dias e DP dos pilares
% [fidinc9, msg] = fopen(DADOS.filepar9,'r');%Abre o arquivo com as m�dias e DP das lajes 

%2 - LEITURA DOS VALORES M�DIOS E DESVIOS PADR�ES
% Leitura das m�dias e desvios padr�es das propriedades geom�tricas de todas
% as vigas e pilares


ELEMENTOS.secao=zeros(PORTICO.nelem,2);      %Matriz contendo as se��es transversais dos elementos
ELEMENTOS.dp=zeros(PORTICO.nelem,2);         %Matriz contendo os DP das se��es dos elementos
ELEMENTOS.E=zeros(PORTICO.nelem,1);          %Matriz contendo o m�dulo de elastiicidade dos elementos
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









