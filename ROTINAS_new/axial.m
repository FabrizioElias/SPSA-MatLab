function N=axial(PORTICO, ELEMENTOS, esf, CARREGAMENTO)
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
% Calcula o esforço normal nos elementos do pórtico 
% -------------------------------------------------------------------------
% MODIFICAÇÕES:         
%--------------------------------------------------------------------------
% VARIÁVEIS DE ENTRADA: PORTICO, ELEMENTOS, DADOS, esf
% VARIÁVEIS DE SAÍDA:   NORMAL: esforços internos nos elementos
%                       do pórtico.
%--------------------------------------------------------------------------
% CRIADA EM 16-maio-2015
% -------------------------------------------------------------------------

%Vetor com as cargas distribuídas nas barras
Qx=CARREGAMENTO.qx;

% Vetor com as cargas concentradas nas barras e a distância da
% carga ao nó à esquerda
Px=CARREGAMENTO.Px;
a=CARREGAMENTO.a;

% Criação dos vetores nulos
maxelem=max(ELEMENTOS.elem);
N=zeros(PORTICO.nelem,maxelem+1);

% Diagrama de Esforço Normal
%FAB - Prealocamento de memória - A remoção dessas variáveis não deve
%afetar em nada.
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
    % Esforço normal devido ao carregamento distriubído
    Nq=q.*(PORTICO.comp(j)-x);
    
    % Esforço normal devido à carga concentrada
    for i=1:s(2)
        if x(i)<a(j)
            Np(i)=p;
        end
        if x(i)>=a(j)
            Np(i)=0;
        end
    end   
    % Esforço normal devido ao carregamento axial distribuído
    %Ndist(j,1:s(2))=N1;
    % Esforço normal devido a uma carga concentrada transversal ao 
    % elemento
    %NP(j,1:s(2))=Np;
    % Esforço normal devido a uma carga distribuída transversal ao 
    % elemento
    %NQ(j,1:s(2))=Nq;
    % Esforço normal total devido à sobrecarga da estrutura
    %N(j,:)=Ndist(j,:)+NP(j,:)+NQ(j,:);
    N(j,:)=N1(:)+Np(:)+Nq(:);
end
