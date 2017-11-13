function [ESTRUTURAL]=reorder(PORTICO, VIGA, ELEMENTOS)
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
% Rotina para deterimnar o elemento inicial e o elemento final de cada
% elemento estrutural da estrutura.
% -------------------------------------------------------------------------
% MODIFICAÇÕES:         Modificada em
%--------------------------------------------------------------------------
% CRIADA EM 19-Março-2017
% -------------------------------------------------------------------------

t=max(PORTICO.elemestrutural);
s=size(PORTICO.elemestrutural);
P=PORTICO.elemestrutural;
P(1,s(2)+1)=0;
ESTRUTURAL.D=zeros(t+1,2);
j=1;
for i=2:t+1
    ESTRUTURAL.D(i,1)=ESTRUTURAL.D(i-1,2)+1;
    dim=0;
    while P(j)==P(j+1)   
        dim=dim+1;
        j=j+1;
    end
    dim=dim+1;
    ESTRUTURAL.D(i,2)=ESTRUTURAL.D(i,1)+dim-1;
    j=j+1;
end
ESTRUTURAL.D=ESTRUTURAL.D(2:t+1,:);
sD=size(ESTRUTURAL.D);
sD=sD(1);

s=size(VIGA.elemento);
s=s(2);
A=zeros(4,PORTICO.nelem+1);
ESTRUTURAL.secao=zeros(4,sD(1));
A(1,2:PORTICO.nelem+1)=PORTICO.elemestrutural;
for i=1:s
    A(2,VIGA.elemento(i)+1)=VIGA.elemento(i);
%     A(3,VIGA.elemento(i)+1)=ELEMENTOS.secao(VIGA.elemento(i),1);
%     A(4,VIGA.elemento(i)+1)=ELEMENTOS.secao(VIGA.elemento(i),2);
end
a=ELEMENTOS.secao(:,1)';
A(3,2:PORTICO.nelem+1)=a;
a=ELEMENTOS.secao(:,2)';
A(4,2:PORTICO.nelem+1)=a;

j=1;
k=1;
for i=1:PORTICO.nelem
    if A(1,j)~=A(1,j+1)
        ESTRUTURAL.secao(1,k)=A(1,j+1);
        ESTRUTURAL.secao(2,k)=A(2,j+1);
        ESTRUTURAL.secao(3,k)=A(3,j+1);
        ESTRUTURAL.secao(4,k)=A(4,j+1);
        
        k=k+1;
    end
    j=j+1;
end

kp=1;
kv=1;
s=size(ESTRUTURAL.secao);
s=s(2);

for i=1:s
    if ESTRUTURAL.secao(2,i)==0
        ESTRUTURAL.ELEMPILAR(kp)=ESTRUTURAL.secao(1,i);
        kp=kp+1;
    else
        ESTRUTURAL.ELEMVIGA(kv)=ESTRUTURAL.secao(1,i);
        kv=kv+1;
    end
end










