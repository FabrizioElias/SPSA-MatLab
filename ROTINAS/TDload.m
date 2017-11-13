function [Fcc, Fcs, fecc, fecs]=TDload(PAR, PORTICO, ELEMENTOS, VIGA, deltacc, deltacs, ngl, gdle, ROT)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIENCIAS
% PROGRAMA DE POS-GRADUACAO EM ENGENHARIA CIVIL        - AREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELECAO DE  MEDIA FIDELIDADE  PARA  ANALISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO
% ALUNA       S�rgio Jos� Priori Jovino Marques Filho
% ORIENTADOR  Prof. Ezio da Rocha Araujo
% -------------------------------------------------------------------------
% DESCRICAO
% C�lculo da for�a equivalente de retra��o e flu�ncia em cada viga
% -------------------------------------------------------------------------
% Criada      23-dezembro-2016                 S�RGIO MARQUES
% -------------------------------------------------------------------------

s=size(VIGA.elemento);
numvigas=s(2);
% M�dulo de elasticidade
Ecs=PAR.CONC.Ecs.parest1;
% Montagem de uma matriz nula para abrigar os valores das for�as referentes
% � retra��o e flu�ncia. Essa matriz ter� 6linhas (correspondente aos seis
% graus de liberdade) e a qnt de colunas ser� a qnt de elementos
fecc=zeros(6, PORTICO.nelem);
fecs=zeros(6, PORTICO.nelem);

% C�lculo da for�a equivalente para cada viga ddo p�rtico
for i=1:numvigas
    A=ELEMENTOS.A(VIGA.elemento(i));
    L=PORTICO.comp(VIGA.elemento(i));
    % For�a devido a flu�ncia
    % A for�a deve ser negativa, for�a de compress�o. O sinal negativo
    % antes da express�o de Fcc(i,2) e a sua aus�ncia antes de Fcc(i,1)
    % serve para quando essas for�as forem inseridas nas dire��es dos graus
    % de liberdade, elas atuem no sentido de TRACIONAR o elemento
    % esturtural.
    fecc(1,VIGA.elemento(i))=(deltacc(i)*Ecs*A/L);
    fecc(4,VIGA.elemento(i))=-(deltacc(i)*Ecs*A/L);
    
    % For�a devido a retra��o
    % Os sinais seguem a mesma l�gicca conforme coment�rio acima.
    fecs(1,VIGA.elemento(i))=(deltacs(i)*Ecs*A/L);
    fecs(4,VIGA.elemento(i))=-(deltacs(i)*Ecs*A/L);   
end

% Esfor�os nodais equivalentes no referencial global
Fecc=zeros(6,PORTICO.nelem);
Fecs=zeros(6,PORTICO.nelem);
for i=1:PORTICO.nelem
    Fecc(:,i)=-ROT(:,:,i)*fecc(:,i);
    Fecs(:,i)=-ROT(:,:,i)*fecs(:,i);
end

% Escreve o esfor�o de engastamento perfeito no referencial global
% Esfor�o de flu�cia
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
% Esfor�o de flu�cia
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