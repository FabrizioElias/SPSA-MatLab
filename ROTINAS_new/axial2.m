function N=axial2(PORTICO, ELEMENTOS, esf, CARGA)
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
% Calcula o esfor�o normal nos elementos do p�rtico 
% -------------------------------------------------------------------------
% MODIFICA��ES:         
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: PORTICO, ELEMENTOS, DADOS, esf
% VARI�VEIS DE SA�DA:   NORMAL: esfor�os internos nos elementos
%                       do p�rtico.
%--------------------------------------------------------------------------
% CRIADA EM 16-maio-2015
% -------------------------------------------------------------------------

%FAB - Remo��o de vari�vel sem uso.
%global m

%Vetor com as cargas distribu�das nas barras
Qx=CARGA.SCqx+CARGA.PPqx;

% Vetor com as cargas concentradas nas barras e a dist�ncia da
% carga ao n� � esquerda
Px=CARGA.SCPx;
%FB - Remo��o de vari�vel sem uso.
%b=CARGA.SCb;
a=CARGA.SCa;


% Cria��o dos vetores nulos
maxelem=max(ELEMENTOS.elem);
N=zeros(PORTICO.nelem,maxelem+1);

% Diagrama de Esfor�o Normal
%FAB - Prealoca��o de matrizes. O n�mero de colunas (2) � sempre
%suficiente?
%FAB - Remover essas vari�veis n�o deve fazer diferen�a.
%Ndist = zeros(PORTICO.nelem, 2);
%NP = zeros(PORTICO.nelem, 2);
%NQ = zeros(PORTICO.nelem, 2);
for j=1:PORTICO.nelem
    q=Qx(j);    
    p=Px(j);
    x=(0:PORTICO.comp(j)/(ELEMENTOS.elem(j)):PORTICO.comp(j));
    s=size(x);
    N1=esf(4,j);
    N1=N1.*ones(1,s(2));
    Np=zeros(1,s(2));
    % Esfor�o normal devido ao carregamento distriub�do
    Nq=q.*(5-x);
    
    % Esfor�o normal devido � carga concentrada
    for i=1:s(2)
        if x(i)<a(j)
            Np(i)=p;
        end
        if x(i)>=a(j)
            Np(i)=0;
        end
    end
    % Esfor�o normal devido ao carregamento axial distribu�do
    %Ndist(j,1:s(2))=N1;
    % Esfor�o normal devido a uma carga concentrada transversal ao 
    % elemento
    %NP(j,1:s(2))=Np;
    % Esfor�o normal devido a uma carga distribu�da transversal ao 
    % elemento
    %NQ(j,1:s(2))=Nq;
    % Esfor�o normal total devido � sobrecarga da estrutura
    %FAB - Remo��o de vari�veis.
    %N(j,:)=Ndist(j,:)+NP(j,:)+NQ(j,:);
    N(j,:)=N1(:)+Np(:)+Nq(:);
end
