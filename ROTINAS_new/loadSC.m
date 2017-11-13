function [Fsc, fesc, CARGA]=loadSC(PORTICO, ROT, gdle, ngl, CARGA)
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
% Processa o p�rtico plano a partir dos dados de entrada 
% -------------------------------------------------------------------------
% MODIFICA��ES:         Modificada em 16/05/2015
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: PORTICO, ELEMENTOS, DADOS
% VARI�VEIS DE SA�DA:   esf: esfor�os nodais obtidos � partir do m�todo dos
%                       deslocamentos
%--------------------------------------------------------------------------
% CRIADA EM 13-Janeiro-2015
% -------------------------------------------------------------------------

%FAB - Vari�vel global n�o utilizada.
%global m

% Matriz contendo as cargas concentradas aplicas �s barras - dir Y local
Py=zeros(PORTICO.nelem,1);
for i=1:PORTICO.qntelemcargaconcy
    Py(PORTICO.elemcargaconcy(i))=PORTICO.cargaconcy(i);
end
CARGA.SCPy=Py; 

% Matriz contendo as cargas concentradas aplicas �s barras - dir X local
Px=zeros(PORTICO.nelem,1);
for i=1:PORTICO.qntelemcargaconcx
    Px(PORTICO.elemcargaconcx(i))=PORTICO.cargaconcx(i);
end
CARGA.SCPx=Px;

% dist�ncia do n� inicial ao ponto de aplica��o da carga concentrada em y
a=zeros(PORTICO.nelem,1);
for i=1:PORTICO.qntelemcargaconcy
    a(PORTICO.elemcargaconcy(i))=PORTICO.distcargaconcy(i);
end
CARGA.SCa=a;

% dist�ncia do n� inicial ao ponto de aplica��o da carga concentrada em x
b=zeros(PORTICO.nelem,1);
for i=1:PORTICO.qntelemcargaconcx
    b(PORTICO.elemcargaconcx(i))=PORTICO.distcargaconcx(i);
end
CARGA.SCb=b;

% Vetor contendo os carregamentos distribu�dos - dir Y local
qy=zeros(PORTICO.nelem,1);
for i=1:PORTICO.qntelemcargadisty
    qy(PORTICO.elemcargadisty(i))=PORTICO.cargadisty(i);
end
CARGA.SCqy=qy;

% Vetor contendo os carregamentos distribu�dos - dir X local
qx=zeros(PORTICO.nelem,1);
for i=1:PORTICO.qntelemcargadistx
    qx(PORTICO.elemcargadist(i))=PORTICO.cargadistx(i);
end
CARGA.SCqx=qx;

feq = zeros(6,PORTICO.nelem);
for i=1:PORTICO.nelem
    f=[-qx(i)*PORTICO.comp(i)/2 -qy(i)*PORTICO.comp(i)/2 -qy(i)*PORTICO.comp(i)^2/12 -qx(i)*PORTICO.comp(i)/2 -qy(i)*PORTICO.comp(i)/2 qy(i)*PORTICO.comp(i)^2/12];
    feq(:,i)=f;
end

% 2.6.2 - Esfor�os de engastamento perfeito - carregamento concentrado
s=size(Px);                             % Vari�vel auxiliar
nP=s(2);                                % Quantidade de cargas aplicas ao elemento
C=zeros(PORTICO.nelem, nP);             % Matriz contendo o comprimento de cada barra
for i=1:nP
    C(:,i)=PORTICO.comp(i);
end
b=C-a;

feP=zeros(6,PORTICO.nelem);        

for i=1:PORTICO.nelem
    f=zeros(1,6);
    f=f';
    for j=1:nP
        P(1) = -Px(i,j)*b(i,j)/PORTICO.comp(i);
        P(2) = -Py(i,j)*(b(i,j)/PORTICO.comp(i)-a(i,j)^2*b(i,j)/PORTICO.comp(i)^3+a(i,j)*b(i,j)^2/PORTICO.comp(i)^3);
        P(3) = -Py(i,j)*a(i,j)*b(i,j)^2/PORTICO.comp(i)^2;
        P(4) = -Px(i,j)*a(i,j)/PORTICO.comp(i);
        P(5) = -Py(i,j)*(a(i,j)/PORTICO.comp(i)+a(i,j)^2*b(i,j)/PORTICO.comp(i)^3-a(i,j)*b(i,j)^2/PORTICO.comp(i)^3);
        P(6) = Py(i,j)*a(i,j)^2*b(i,j)/PORTICO.comp(i)^2;
        f=f+P';
    end
    feP(:,i)=f;
end

% 2.6.4 - Esfor�os de engastamento perfeito - soma dos esfo�os
% Sistema local
fesc=feq+feP;

% Esfor�os nodais equivalentes no referencial global
Fe=zeros(6,PORTICO.nelem);
for i=1:PORTICO.nelem
    Fe(:,i)=-ROT(:,:,i)*fesc(:,i);
end

% 2.6.4 - Montagem do vetor de for�as nodais equivalentes
Feq=zeros(1,ngl);
for i=1:PORTICO.nelem
    for j=1:6
        k=gdle(i,j);
        if k>0
            Feq(k)=Feq(k)+Fe(j,i);
        end
    end
end

% 2.6.5 - Montagem do vetor de cargas aplicadas diretamente aos graus de
% liberdade - n�o deve ser processado se tagcarga==2, pois nessa situa��o
% s� � onde se considera as a��es externas na estrutura (sobrecarga).
Fn=zeros(1,ngl);
for i=1:PORTICO.qntdircarregadas
    Fn(PORTICO.dircarregadas(i))=PORTICO.carganodal(i);
end


Fsc=Fn+Feq;