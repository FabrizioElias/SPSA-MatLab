function [Fcc, Fcs, fecc, fecs]=TDload(PAR, PORTICO, ELEMENTOS, VIGA, deltacc, deltacs, ngl, gdle, ROT)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIENCIAS
% PROGRAMA DE POS-GRADUACAO EM ENGENHARIA CIVIL        - AREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELECAO DE  MEDIA FIDELIDADE  PARA  ANALISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO
% ALUNA       Sérgio José Priori Jovino Marques Filho
% ORIENTADOR  Prof. Ezio da Rocha Araujo
% -------------------------------------------------------------------------
% DESCRICAO
% Cálculo da força equivalente de retração e fluência em cada viga
% -------------------------------------------------------------------------
% Criada      23-dezembro-2016                 SÉRGIO MARQUES
% -------------------------------------------------------------------------

s=size(VIGA.elemento);
numvigas=s(2);
% Módulo de elasticidade
Ecs=PAR.CONC.Ecs.parest1;
% Montagem de uma matriz nula para abrigar os valores das forças referentes
% à retração e fluência. Essa matriz terá 6linhas (correspondente aos seis
% graus de liberdade) e a qnt de colunas será a qnt de elementos
fecc=zeros(6, PORTICO.nelem);
fecs=zeros(6, PORTICO.nelem);

% Cálculo da força equivalente para cada viga ddo pórtico
for i=1:numvigas
    A=ELEMENTOS.A(VIGA.elemento(i));
    L=PORTICO.comp(VIGA.elemento(i));
    % Força devido a fluência
    % A força deve ser negativa, força de compressão. O sinal negativo
    % antes da expressão de Fcc(i,2) e a sua ausência antes de Fcc(i,1)
    % serve para quando essas forças forem inseridas nas direções dos graus
    % de liberdade, elas atuem no sentido de TRACIONAR o elemento
    % esturtural.
    fecc(1,VIGA.elemento(i))=(deltacc(i)*Ecs*A/L);
    fecc(4,VIGA.elemento(i))=-(deltacc(i)*Ecs*A/L);
    
    % Força devido a retração
    % Os sinais seguem a mesma lógicca conforme comentário acima.
    fecs(1,VIGA.elemento(i))=(deltacs(i)*Ecs*A/L);
    fecs(4,VIGA.elemento(i))=-(deltacs(i)*Ecs*A/L);   
end

% Esforços nodais equivalentes no referencial global
Fecc=zeros(6,PORTICO.nelem);
Fecs=zeros(6,PORTICO.nelem);
for i=1:PORTICO.nelem
    Fecc(:,i)=-ROT(:,:,i)*fecc(:,i);
    Fecs(:,i)=-ROT(:,:,i)*fecs(:,i);
end

% Escreve o esforço de engastamento perfeito no referencial global
% Esforço de fluêcia
Feq=zeros(1,ngl);
for i=1:PORTICO.nelem
    for j=1:6
        k=gdle(i,j);
        if k>0
            Feq(k)=Feq(k)+Fecc(j,i);
        end
    end
end
Fcc=Feq;
% Esforço de fluêcia
Feq=zeros(1,ngl);
for i=1:PORTICO.nelem
    for j=1:6
        k=gdle(i,j);
        if k>0
            Feq(k)=Feq(k)+Fecs(j,i);
        end
    end
end
Fcs=Feq;    