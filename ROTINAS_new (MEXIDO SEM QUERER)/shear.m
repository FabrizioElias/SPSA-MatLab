function V=shear(PORTICO, ELEMENTOS, esf, CARREGAMENTO)
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
% Calcula o esfor�o cortante nos elementos do p�rtico 
% -------------------------------------------------------------------------
% MODIFICA��ES:         Modificada em 16/05/2015
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: PORTICO, ELEMENTOS, DADOS, esf
% VARI�VEIS DE SA�DA:   CORTANTE: esfor�os internos nos elementos
%                       do p�rtico.
%--------------------------------------------------------------------------
% CRIADA EM 13-Janeiro-2015
% -------------------------------------------------------------------------

% Vetor com as cargas distribu�das nas barras
Qy=CARREGAMENTO.qy;

% Vetor com as cargas concentradas nas barras e a dist�ncia da carga ao n�
% � esquerda
Py=CARREGAMENTO.Py;
a=CARREGAMENTO.a;

% Cria��o dos vetores nulos
%maxelem=max(ELEMENTOS.elem);
V=zeros(PORTICO.nelem,2);

% Diagrama de esfor�o cortante para cada barra do p�rtico
for j=1:PORTICO.nelem    
    q=-Qy(j);    
    p=-Py(j);
    V1=esf(2,j);
    x=(0:PORTICO.comp(j):PORTICO.comp(j));
    s=size(x);
    Vp=zeros(1,s(2));   
    % Cortante devido � carga distribu�da
    Vq=-q*x;    
    % Esfor�o cortante devido � carga concentrada
    s=size(x);
    for i=1:s(2)
        if x(i)<a(j)
            Vp(i)=V1;
        end
        if x(i)>=a(j)
            Vp(i)=V1-p;
        end
    end
        % Vp - esfor�o cortnte devido �s cargas concentradas
        VP(j,1:s(2))=Vp; 
        % Vq - esfor�o cortante devido �s cargas distribu�das
        VQ(j,1:s(2))=Vq;
        % Esfor�o cortante total
        V(j,:)=VP(j,:)+VQ(j,:);
end