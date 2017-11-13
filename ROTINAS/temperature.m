function [FtempPOS, FtempNEG, fetempPOS, fetempNEG]=temperature(PAR, PORTICO, ELEMENTOS, VIGA, ngl, ROT, gdle)
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
% Calcula os par�metros f�sicos do concreto que s�o dependentes do tempo.
% M�dulo de elasticidada e coeficientes de retra��o e flu�ncia
% -------------------------------------------------------------------------
% Criada      13-janeiro-2016                 S�RGIO MARQUES
% -------------------------------------------------------------------------

Ecs=PAR.CONC.Ecs.parest1;
alfa=PAR.CONC.ALFATEMP.parest1;

%FtempPOS=zeros(1,ngl); %FAB - Prealocar mem�ria para vari�vel de sa�da
                        %n�o � necess�rio. Mesma coisa abaixo.
%FtempNEG=zeros(1,ngl);

fetempPOS=zeros(6, PORTICO.nelem);
fetempNEG=zeros(6, PORTICO.nelem);

s=size(VIGA.elemento);
numvigas=s(2);
% C�lculo da for�a equivalente para cada viga ddo p�rtico
for i=1:numvigas
    A=ELEMENTOS.A(VIGA.elemento(i));
    % For�a devido � varia��o uniforme de temperatura
    % A vari�vel FtempPOS diz respeito a uma varia��o positiva de
    % temperatura enquanto que FtempNEG uma varia��o negativa.
    fetempPOS(1,VIGA.elemento(i))=alfa*Ecs*A*PORTICO.TempMax(VIGA.elemento(i),1);
    fetempPOS(4,VIGA.elemento(i))=-alfa*Ecs*A*PORTICO.TempMax(VIGA.elemento(i),1);
    fetempNEG(1,VIGA.elemento(i))=alfa*Ecs*A*PORTICO.TempMin(VIGA.elemento(i),1);
    fetempNEG(4,VIGA.elemento(i))=-alfa*Ecs*A*PORTICO.TempMin(VIGA.elemento(i),1);
end

% Esfor�os nodais equivalentes no referencial global
FetempPOS=zeros(6,PORTICO.nelem);
FetempNEG=zeros(6,PORTICO.nelem);
for i=1:PORTICO.nelem
    FetempPOS(:,i)=-ROT(:,:,i)*fetempPOS(:,i);
    FetempNEG(:,i)=-ROT(:,:,i)*fetempNEG(:,i);
end

% Escreve o esfor�o de engastamento perfeito no referencial global
% Esfor�o devido a varia��o positiva de temperatura
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
% Esfor�o de flu�cia
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