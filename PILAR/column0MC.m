%FAB - Troca do nome da função para o nome do arquivo.
function [PILARout]=column0MC(MOMENTO, NORMAL, PILARin, pilar, NumPilar)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIÊNCIAS
% PROGRAMA DE PÓS-GRADUAÇÃO EM ENGENHARIA CIVIL        - ÁREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELEÇÃO DE  MÉDIA FIDELIDADE  PARA  ANÁLISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO.
% ALUNO       Sérgio José Priori Jovino Marques Filho
% ORIENTADOR  Prof. Ézio da Rocha Araújo
% -------------------------------------------------------------------------
% DESCRIÇÃO
% Rotina para determinar os esforços internos atuantes no pilar
% -------------------------------------------------------------------------
% MODIFICAÇÕES:         
%--------------------------------------------------------------------------
% VARIÁVEIS DE ENTRADA: CORTANTE, MOMENTO, NORMAL, PILARin, PILARout, pilar
% VARIÁVEIS DE SAÍDA:   PILARout: "structure" contendo as variáveis necessá-
% rias ao algoritmo de detalhamento do pilar.
%--------------------------------------------------------------------------
% CRIADA EM 21-fevereiro-2016
% -------------------------------------------------------------------------

%FAB - Remoção de variável global sem uso.
%global m

% Esforços solicitantes no elemento estrutural
% Esforço Normal
N=NORMAL.TOTAL{pilar,:};          % <-- Esforço normal total: PP+SC
N=N(N~=0);                        % <-- Remove os zeros do vetor N  
PILARout.Nmax=max(abs(N));
ni=PILARout.Nmax/(PILARin.A*PILARin.fcd);    % <-- Valor admensinal do esforço normal
%FAB - Remoção de variável sem uso (Raio de giração).
%r=(ni+0.5)*PILARin.h/.005;        % <--1/r=0.005/((ni+0.5)*h), raio de giração
Npp=NORMAL.PP{pilar,:};           % <-- Esforço normal devido ao PP - cálculo da excentricidade suplementar
Npp=Npp(Npp~=0);                  % <-- Remove os zeros do vetor Npp
% Momento Fletor
M=MOMENTO.TOTAL{pilar,:};         % <-- Momento fletor total: PP+SC
M=M(M~=0);                        % <-- Remove os zeros do vetor M
Mmax=max(abs(M));
Mpp=MOMENTO.PP{pilar,:};     % <-- Momento fletor devido ao PP - cálculo da excentricidade suplementar
Mpp=Mpp(Mpp~=0);                  % <-- Remove os zeros do vetor Mpp

% CÁLCULO DAS EXCÊNTRICIDADES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------- EXCENTRICIDADES DE 1 ORDEM -----------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Excentricidade inicial
PILARout.ei=Mmax/PILARout.Nmax;

% Excentricidade de forma
PILARout.ef=0;      % < Tomada igual à zero - eixo da viga e pilar são concorrentes

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
% Excêntricidade total de primeira ordem - não inclui a excentricidade
% acidental, vide NBR 6118
e1=PILARout.ei+PILARout.ef;

% Cálculo do momento fletor mínimo
M1dmin=max(abs(N))*(0.015+0.03*PILARin.h);

% Cálculo do parâmetro alfab - pilar bi-apoiado
s=size(M);
s=s(2);
MA=max((abs(M(s))),abs(M(1)));  % Maior MF dentre as extremidades do pilar
MB=min((abs(M(s))),abs(M(1)));  % Menor MF dentre as extremidades do pilar
if M(s)/M(1)<0
    MB=-MB;                     % Se MA e MB tracionares fibras opostas devem possuir sinais contrários
end
% Valor de alfab - devem ser verificadas as seguintes condições: alfab<0.4,
% alfab>1 e alfab deve ser igual a 1 se o momento ao longo do pilar for
% menor que o momento mínimo definido em 11.3.3.4.3 da NBR 6118/2014
alfab=0.6+0.4*MB/MA;
if alfab<0.4
    alfab=0.4;
elseif alfab>1
    alfab=1;
elseif M1dmin>max(abs(M))
    alfab=1;
end
% Valor limite para o índice de esbeltez do pilar
lambda1=(25+12.5*e1/PILARin.h)/alfab;
if lambda1<35
    lambda1=35;
elseif lambda1>90
    lambda1=90;
end
%disp(['    Valor limite da esbeltez, lamda1= ',num2str(lambda1)])
% Classificação dos pilares
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
    PILARout.e2=99;  % Com e2 muito alto o pilar não passará, será lançado um valor muito para o peso da armadura a fim de gerar um custo muito alto, penalizando o algoritmo de otimização
elseif PILARin.lambda>140 && PILARin.lambda<200
    disp(['    Pilar muito esbelto: lambda=  ',num2str(PILARin.lambda)])
    disp('    IMPLEMENTAR PROCESSO GERAL')
    PILARout.e2=99;
else
    disp('     ESBLETEZ MUITO ALTA (LAMBDA>200) - IMPOSSÍVEL DIMENSIONAR')
    PILARout.e2=99;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------- EXCENTRICIDADES SUPLEMENTAR ----------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if PILARin.lambda>90
    % Esforços solicitantes devido às ações permanentes
    Msg=max(abs(Mpp));
    Nsg=max(abs(Npp));
    Ne=10*PILARin.Ec*PILARin.I/PILARin.Lef^2;
    PILARout.ec=(Msg/Nsg+PILARout.ea)*(2.718^(PILARin.phi*Nsg/(Ne-Nsg))-1); 
else
    PILARout.ec=0;
end
% Excentricidade total 
PILARout.et=PILARout.ei+PILARout.ef+PILARout.ea+PILARout.e2+PILARout.ec;
