function [KESTenc, gdle, ngl, KELEM, ROT]=rigidezENCURT(PORTICO, ELEMENTOS, DADOS, CS)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIÊNCIAS
% PROGRAMA DE PÓS-GRADUAÇÃO EM ENGENHARIA CIVIL        - ÁREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELEÇÃO DE  MÉDIA FIDELIDADE  PARA  ANÁLISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO.
% ALUNA       Sérgio José Priori Jovino Marques Filho
% ORIENTADOR  Prof. Ézio da Rocha Araújo
% -------------------------------------------------------------------------
% DESCRIÇÃO
% Rotina para cálculo da matriz de rigidez da estrutura
% -------------------------------------------------------------------------
% MODIFICAÇÕES:         Modificada em 16/05/2015
%--------------------------------------------------------------------------
% VARIÁVEIS DE ENTRADA: PORTICO, ELEMENTOS, DADOS
% VARIÁVEIS DE SAÍDA:   esf: esforços nodais obtidos à partir do método dos
%                       deslocamentos
%--------------------------------------------------------------------------
% CRIADA EM 14-Janeiro-2015
% -------------------------------------------------------------------------

global m

% 1.2 - Leitura das condições de contorno do pórtico
id=zeros(PORTICO.nnos,3);
v=[1 3 5];  % Esse vetor faz com que a rotina leia apenas os graus de liberdade referentes a um póritco plano,
            % ou seja dx, dz e rot y. Lembrando que as condições de
            % contorno são inseridas como se o pórtico fosse espacial de
            % forma a termos compatibilidade nas entradas do FEAP e da
            % rotina PorticoPlano.m
AUX=PORTICO.restricao;
AUX=AUX(:,v);
for i=1:PORTICO.qntnosrestritos
    id(PORTICO.nosrestritos(i),:)=AUX(i,:);
end

% 2 - MONTAGEM DO SISTEMA DE EQUAÇÕES
% 2.1 - Reorganização da matriz id (por que?)
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
%2.2.1 - Número de graus de liberdade da estrutura
v=max(gdle);
ngle=max(v);

% 2.3 - Montagem da matriz de rotação - matriz tridimensional
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
    
%=============== TESTE PARA IMPLEMENTAÇÃO DA BASE ELÁSTICA ===============%
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