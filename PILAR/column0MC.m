%FAB - Troca do nome da fun��o para o nome do arquivo.
function [PILARout]=column0MC(MOMENTO, NORMAL, PILARin, pilar, NumPilar)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCI�NCIAS
% PROGRAMA DE P�S-GRADUA��O EM ENGENHARIA CIVIL        - �REA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELE��O DE  M�DIA FIDELIDADE  PARA  AN�LISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO.
% ALUNO       S�rgio Jos� Priori Jovino Marques Filho
% ORIENTADOR  Prof. �zio da Rocha Ara�jo
% -------------------------------------------------------------------------
% DESCRI��O
% Rotina para determinar os esfor�os internos atuantes no pilar
% -------------------------------------------------------------------------
% MODIFICA��ES:         
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: CORTANTE, MOMENTO, NORMAL, PILARin, PILARout, pilar
% VARI�VEIS DE SA�DA:   PILARout: "structure" contendo as vari�veis necess�-
% rias ao algoritmo de detalhamento do pilar.
%--------------------------------------------------------------------------
% CRIADA EM 21-fevereiro-2016
% -------------------------------------------------------------------------

%FAB - Remo��o de vari�vel global sem uso.
%global m

% Esfor�os solicitantes no elemento estrutural
% Esfor�o Normal
N=NORMAL.TOTAL{pilar,:};          % <-- Esfor�o normal total: PP+SC
N=N(N~=0);                        % <-- Remove os zeros do vetor N  
PILARout.Nmax=max(abs(N));
ni=PILARout.Nmax/(PILARin.A*PILARin.fcd);    % <-- Valor admensinal do esfor�o normal
%FAB - Remo��o de vari�vel sem uso (Raio de gira��o).
%r=(ni+0.5)*PILARin.h/.005;        % <--1/r=0.005/((ni+0.5)*h), raio de gira��o
Npp=NORMAL.PP{pilar,:};           % <-- Esfor�o normal devido ao PP - c�lculo da excentricidade suplementar
Npp=Npp(Npp~=0);                  % <-- Remove os zeros do vetor Npp
% Momento Fletor
M=MOMENTO.TOTAL{pilar,:};         % <-- Momento fletor total: PP+SC
M=M(M~=0);                        % <-- Remove os zeros do vetor M
Mmax=max(abs(M));
Mpp=MOMENTO.PP{pilar,:};     % <-- Momento fletor devido ao PP - c�lculo da excentricidade suplementar
Mpp=Mpp(Mpp~=0);                  % <-- Remove os zeros do vetor Mpp

% C�LCULO DAS EXC�NTRICIDADES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------- EXCENTRICIDADES DE 1 ORDEM -----------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Excentricidade inicial
PILARout.ei=Mmax/PILARout.Nmax;

% Excentricidade de forma
PILARout.ef=0;      % < Tomada igual � zero - eixo da viga e pilar s�o concorrentes

% Excentricidade acidental
teta1=1/(100*(PILARin.COMPRIMENTO(NumPilar)^(1/2)));
teta1min=1/300;
teta1max=1/200;
if teta1<teta1min
    teta1=teta1min;
elseif teta1>teta1max
    teta1=teta1max;
end
PILARout.ea=teta1*PILARin.COMPRIMENTO(NumPilar)/2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------- EXCENTRICIDADES DE 2 ORDEM -----------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exc�ntricidade total de primeira ordem - n�o inclui a excentricidade
% acidental, vide NBR 6118
e1=PILARout.ei+PILARout.ef;

% C�lculo do momento fletor m�nimo
M1dmin=max(abs(N))*(0.015+0.03*PILARin.h);

% C�lculo do par�metro alfab - pilar bi-apoiado
s=size(M);
s=s(2);
MA=max((abs(M(s))),abs(M(1)));  % Maior MF dentre as extremidades do pilar
MB=min((abs(M(s))),abs(M(1)));  % Menor MF dentre as extremidades do pilar
if M(s)/M(1)<0
    MB=-MB;                     % Se MA e MB tracionares fibras opostas devem possuir sinais contr�rios
end
% Valor de alfab - devem ser verificadas as seguintes condi��es: alfab<0.4,
% alfab>1 e alfab deve ser igual a 1 se o momento ao longo do pilar for
% menor que o momento m�nimo definido em 11.3.3.4.3 da NBR 6118/2014
alfab=0.6+0.4*MB/MA;
if alfab<0.4
    alfab=0.4;
elseif alfab>1
    alfab=1;
elseif M1dmin>max(abs(M))
    alfab=1;
end
% Valor limite para o �ndice de esbeltez do pilar
lambda1=(25+12.5*e1/PILARin.h)/alfab;
if lambda1<35
    lambda1=35;
elseif lambda1>90
    lambda1=90;
end
%disp(['    Valor limite da esbeltez, lamda1= ',num2str(lambda1)])
% Classifica��o dos pilares
% Pilares curtos
if PILARin.lambda<=lambda1
    %disp(['    Pilar curto: lambda=  ',num2str(PILARin.lambda)])
    PILARout.e2=0;
% Pilares medianamente esbeltos
elseif PILARin.lambda>lambda1 && PILARin.lambda<90
    %disp(['    Pilar medianamento esbelto: lambda=  ',num2str(PILARin.lambda)])
    PILARout.e2=PILARin.Lef^2*0.005/(10*(ni+0.5)*PILARin.h);
% Pilares esbeltos
elseif PILARin.lambda>90 && PILARin.lambda<140
    disp(['    Pilar esbelto: lambda=  ',num2str(PILARin.lambda)])
    disp('    IMPLEMENTAR PROCESSO MAIS EXATO')
    PILARout.e2=99;  % Com e2 muito alto o pilar n�o passar�, ser� lan�ado um valor muito para o peso da armadura a fim de gerar um custo muito alto, penalizando o algoritmo de otimiza��o
elseif PILARin.lambda>140 && PILARin.lambda<200
    disp(['    Pilar muito esbelto: lambda=  ',num2str(PILARin.lambda)])
    disp('    IMPLEMENTAR PROCESSO GERAL')
    PILARout.e2=99;
else
    disp('     ESBLETEZ MUITO ALTA (LAMBDA>200) - IMPOSS�VEL DIMENSIONAR')
    PILARout.e2=99;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------- EXCENTRICIDADES SUPLEMENTAR ----------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if PILARin.lambda>90
    % Esfor�os solicitantes devido �s a��es permanentes
    Msg=max(abs(Mpp));
    Nsg=max(abs(Npp));
    Ne=10*PILARin.Ec*PILARin.I/PILARin.Lef^2;
    PILARout.ec=(Msg/Nsg+PILARout.ea)*(2.718^(PILARin.phi*Nsg/(Ne-Nsg))-1); 
else
    PILARout.ec=0;
end
% Excentricidade total 
PILARout.et=PILARout.ei+PILARout.ef+PILARout.ea+PILARout.e2+PILARout.ec;
