function V=shear(PORTICO, ELEMENTOS, esf, CARREGAMENTO)
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
% Calcula o esforço cortante nos elementos do pórtico 
% -------------------------------------------------------------------------
% MODIFICAÇÕES:         Modificada em 16/05/2015
%--------------------------------------------------------------------------
% VARIÁVEIS DE ENTRADA: PORTICO, ELEMENTOS, DADOS, esf
% VARIÁVEIS DE SAÍDA:   CORTANTE: esforços internos nos elementos
%                       do pórtico.
%--------------------------------------------------------------------------
% CRIADA EM 13-Janeiro-2015
% -------------------------------------------------------------------------

% Vetor com as cargas distribuídas nas barras
Qy=CARREGAMENTO.qy;

% Vetor com as cargas concentradas nas barras e a distância da carga ao nó
% à esquerda
Py=CARREGAMENTO.Py;
a=CARREGAMENTO.a;

% Criação dos vetores nulos
%maxelem=max(ELEMENTOS.elem);
V=zeros(PORTICO.nelem,2);

% Diagrama de esforço cortante para cada barra do pórtico
for j=1:PORTICO.nelem    
    q=-Qy(j);    
    p=-Py(j);
    V1=esf(2,j);
    x=(0:PORTICO.comp(j):PORTICO.comp(j));
    s=size(x);
    Vp=zeros(1,s(2));   
    % Cortante devido à carga distribuída
    Vq=-q*x;    
    % Esforço cortante devido à carga concentrada
    s=size(x);
    for i=1:s(2)
        if x(i)<a(j)
            Vp(i)=V1;
        end
        if x(i)>=a(j)
            Vp(i)=V1-p;
        end
    end
        % Vp - esforço cortnte devido às cargas concentradas
        VP(j,1:s(2))=Vp; 
        % Vq - esforço cortante devido às cargas distribuídas
        VQ(j,1:s(2))=Vq;
        % Esforço cortante total
        V(j,:)=VP(j,:)+VQ(j,:);
end