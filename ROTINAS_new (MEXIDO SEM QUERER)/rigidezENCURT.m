function [KESTenc, gdle, ngl, KELEM, ROT]=rigidezENCURT(PORTICO, ELEMENTOS, DADOS, CS)
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
% Rotina para c�lculo da matriz de rigidez da estrutura
% -------------------------------------------------------------------------
% MODIFICA��ES:         Modificada em 16/05/2015
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: PORTICO, ELEMENTOS, DADOS
% VARI�VEIS DE SA�DA:   esf: esfor�os nodais obtidos � partir do m�todo dos
%                       deslocamentos
%--------------------------------------------------------------------------
% CRIADA EM 14-Janeiro-2015
% -------------------------------------------------------------------------

global m

% 1.2 - Leitura das condi��es de contorno do p�rtico
id=zeros(PORTICO.nnos,3);
v=[1 3 5];  % Esse vetor faz com que a rotina leia apenas os graus de liberdade referentes a um p�ritco plano,
            % ou seja dx, dz e rot y. Lembrando que as condi��es de
            % contorno s�o inseridas como se o p�rtico fosse espacial de
            % forma a termos compatibilidade nas entradas do FEAP e da
            % rotina PorticoPlano.m
AUX=PORTICO.restricao;
AUX=AUX(:,v);
for i=1:PORTICO.qntnosrestritos
    id(PORTICO.nosrestritos(i),:)=AUX(i,:);
end

% 2 - MONTAGEM DO SISTEMA DE EQUA��ES
% 2.1 - Reorganiza��o da matriz id (por que?)
ngl=0;
for i=1:PORTICO.nnos
    for j=1:3
        n=id(i,j);
        if n>=1
            id(i,j)=0; 
        else
            ngl=ngl+1;
            id(i,j)=ngl;
        end
    end
end

% 2.2 - Montagem da matriz gdle
for i=1:PORTICO.nelem
    for j=1:3
        gdle(i,j)=id(PORTICO.conec(i,1),j);
        gdle(i,j+3)=id(PORTICO.conec(i,2),j);
    end
end
%2.2.1 - N�mero de graus de liberdade da estrutura
v=max(gdle);
ngle=max(v);

% 2.3 - Montagem da matriz de rota��o - matriz tridimensional
ROT=zeros(6,6,PORTICO.nelem);
for i=1:PORTICO.nelem
    R=[cos(PORTICO.teta(i)) -sin(PORTICO.teta(i)) 0 0 0 0;
    sin(PORTICO.teta(i)) cos(PORTICO.teta(i)) 0 0 0 0;
    0 0 1 0 0 0;
    0 0  0 cos(PORTICO.teta(i)) -sin(PORTICO.teta(i)) 0;
    0 0  0 sin(PORTICO.teta(i)) cos(PORTICO.teta(i)) 0;
    0 0 0 0 0 1];
ROT(:,:,i)=R;
end

% 2.4 - Montagem da matriz de rigidez dos elementos
% 2.4.1 - Matriz de rigidez dos elementos no referencial local
KELEM=zeros(6,6,PORTICO.nelem);
for i=1:PORTICO.nelem
    kelem=[ELEMENTOS.E(i)*ELEMENTOS.A(i)/PORTICO.comp(i) 0 0 -ELEMENTOS.E(i)*ELEMENTOS.A(i)/PORTICO.comp(i) 0 0
        0 12*ELEMENTOS.E(i)*ELEMENTOS.I(i)/PORTICO.comp(i)^3 6*ELEMENTOS.E(i)*ELEMENTOS.I(i)/PORTICO.comp(i)^2 0 -12*ELEMENTOS.E(i)*ELEMENTOS.I(i)/PORTICO.comp(i)^3 6*ELEMENTOS.E(i)*ELEMENTOS.I(i)/PORTICO.comp(i)^2
        0 6*ELEMENTOS.E(i)*ELEMENTOS.I(i)/PORTICO.comp(i)^2 4*ELEMENTOS.E(i)*ELEMENTOS.I(i)/PORTICO.comp(i) 0 -6*ELEMENTOS.E(i)*ELEMENTOS.I(i)/PORTICO.comp(i)^2 2*ELEMENTOS.E(i)*ELEMENTOS.I(i)/PORTICO.comp(i)
        -ELEMENTOS.E(i)*ELEMENTOS.A(i)/PORTICO.comp(i) 0 0 ELEMENTOS.E(i)*ELEMENTOS.A(i)/PORTICO.comp(i) 0 0
        0 -12*ELEMENTOS.E(i)*ELEMENTOS.I(i)/PORTICO.comp(i)^3 -6*ELEMENTOS.E(i)*ELEMENTOS.I(i)/PORTICO.comp(i)^2 0 12*ELEMENTOS.E(i)*ELEMENTOS.I(i)/PORTICO.comp(i)^3 -6*ELEMENTOS.E(i)*ELEMENTOS.I(i)/PORTICO.comp(i)^2
        0 6*ELEMENTOS.E(i)*ELEMENTOS.I(i)/PORTICO.comp(i)^2 2*ELEMENTOS.E(i)*ELEMENTOS.I(i)/PORTICO.comp(i) 0 -6*ELEMENTOS.E(i)*ELEMENTOS.I(i)/PORTICO.comp(i)^2 4*ELEMENTOS.E(i)*ELEMENTOS.I(i)/PORTICO.comp(i)];
    
    if DADOS.op_spring==1
        %disp(['Elemento ',num2str(i)])
        a=PORTICO.conec(i,2);
        %disp(['Spring ',num2str(a),' = ',num2str(PORTICO.springs(a))])      
        kelem(5,5)=kelem(5,5)+PORTICO.springsV(a,m);
%         kelem(5,5)=kelem(5,5)+CS(i,1)*PORTICO.springsV(a,m);
    end
    
%=============== TESTE PARA IMPLEMENTA��O DA BASE EL�STICA ===============%
%    kelem(2,2)=kelem(2,2)+500;
%    kelem(5,5)=kelem(2,2)+500;
%-------------------------------------------------------------------------%
    
    KELEM(:,:,i)=kelem;
    
end

% 2.4.2 - Matriz de rigidez dos elementos no referencial global
KELEMG=zeros(6,6,PORTICO.nelem);
for i=1:PORTICO.nelem
    D=ROT(:,:,i);
    B=KELEM(:,:,i);
    KELEMG(:,:,i)=D*B*D';
end

% 2.5- Montagem da Matriz de rigidez da estrutura
KEST=zeros(ngle,ngle);
    for i=1:PORTICO.nelem
        rig=KELEMG(:,:,i);
        for ii=1:6
            j=gdle(i,ii);
            if j>0
                for n=1:6
                    k=gdle(i,n);
                    if k>0
                        KEST(j,k)=KEST(j,k)+rig(ii,n);
                    end                                                                
                end
            end
        end
    end
    KESTenc=KEST;