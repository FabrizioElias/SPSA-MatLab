function M=bend(PORTICO, ELEMENTOS, esf,CARREGAMENTO)
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
% Calcula o momento fletor nos elementos do p�rtico 
% -------------------------------------------------------------------------
% MODIFICA��ES:         Modificada em16/05/2015
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: PORTICO, ELEMENTOS, DADOS, esf
% VARI�VEIS DE SA�DA:   MOMENTO: esfor�os internos nos elementos
%                       do p�rtico.
%--------------------------------------------------------------------------
% CRIADA EM 13-Janeiro-2015
% -------------------------------------------------------------------------

% Vetor com as cargas distribu�das nas barras
Qy=CARREGAMENTO.qy;

% Vetor com as cargas concentradas nas barras e a dist�ncia da
% carg
Py=CARREGAMENTO.Py;
a=CARREGAMENTO.a;

% Cria��o dos vetores nulos
%maxelem=max(ELEMENTOS.elem);
M=zeros(PORTICO.nelem,2);

% Diagrama de Momento Fletor
for j=1:PORTICO.nelem
    q=-Qy(j);    
    p=-Py(j);
    M1=esf(3,j);
    M2=esf(6,j);
    V1=esf(2,j);
    x=(0:PORTICO.comp(j):PORTICO.comp(j));
    s=size(x);
    Mp=zeros(1,s(2));
    
    % Momento devido ao carregamento distribu�do
    Mq=-q*(x.^2)/2;
    
    % Momento fletor na extremidade da barra
    Mm=-M1*ones(1,s(2));
    
    % Momento fletor devido � carga concentrada
    for i=1:s(2)
        if x(i)<a(j)
            Mp(i)=V1*x(i);
        end
        if x(i)>=a(j)
            Mp(i)=V1*x(i)+p*(a(j)-x(i));
        end
    end
    MP(j,1:s(2))=Mp;
    MQ(j,1:s(2))=Mq;
    MM(j,1:s(2))=Mm;
    M(j,:)=MP(j,:)+MQ(j,:)+MM(j,:);
end        