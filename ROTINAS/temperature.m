function [FtempPOS, FtempNEG, fetempPOS, fetempNEG]=temperature(PAR, PORTICO, ELEMENTOS, VIGA, ngl, ROT, gdle)
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
% Calcula os parâmetros físicos do concreto que são dependentes do tempo.
% Módulo de elasticidada e coeficientes de retração e fluência
% -------------------------------------------------------------------------
% Criada      13-janeiro-2016                 SÉRGIO MARQUES
% -------------------------------------------------------------------------

Ecs=PAR.CONC.Ecs.parest1;
alfa=PAR.CONC.ALFATEMP.parest1;

%FtempPOS=zeros(1,ngl); %FAB - Prealocar memória para variável de saída
                        %não é necessário. Mesma coisa abaixo.
%FtempNEG=zeros(1,ngl);

fetempPOS=zeros(6, PORTICO.nelem);
fetempNEG=zeros(6, PORTICO.nelem);

s=size(VIGA.elemento);
numvigas=s(2);
% Cálculo da força equivalente para cada viga ddo pórtico
for i=1:numvigas
    A=ELEMENTOS.A(VIGA.elemento(i));
    % Força devido à variação uniforme de temperatura
    % A variável FtempPOS diz respeito a uma variação positiva de
    % temperatura enquanto que FtempNEG uma variação negativa.
    fetempPOS(1,VIGA.elemento(i))=alfa*Ecs*A*PORTICO.TempMax(VIGA.elemento(i),1);
    fetempPOS(4,VIGA.elemento(i))=-alfa*Ecs*A*PORTICO.TempMax(VIGA.elemento(i),1);
    fetempNEG(1,VIGA.elemento(i))=alfa*Ecs*A*PORTICO.TempMin(VIGA.elemento(i),1);
    fetempNEG(4,VIGA.elemento(i))=-alfa*Ecs*A*PORTICO.TempMin(VIGA.elemento(i),1);
end

% Esforços nodais equivalentes no referencial global
FetempPOS=zeros(6,PORTICO.nelem);
FetempNEG=zeros(6,PORTICO.nelem);
for i=1:PORTICO.nelem
    FetempPOS(:,i)=-ROT(:,:,i)*fetempPOS(:,i);
    FetempNEG(:,i)=-ROT(:,:,i)*fetempNEG(:,i);
end

% Escreve o esforço de engastamento perfeito no referencial global
% Esforço devido a variação positiva de temperatura
Feq=zeros(1,ngl);
for i=1:PORTICO.nelem
    for j=1:6
        k=gdle(i,j);
        if k>0
            Feq(k)=Feq(k)+FetempPOS(j,i);
        end
    end
end
FtempPOS=Feq;
% Esforço de fluêcia
Feq=zeros(1,ngl);
for i=1:PORTICO.nelem
    for j=1:6
        k=gdle(i,j);
        if k>0
            Feq(k)=Feq(k)+FetempNEG(j,i);
        end
    end
end
FtempNEG=Feq;