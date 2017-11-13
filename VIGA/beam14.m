function [VIGAresult, ARRANJOESTRIBO]=beam14(VIGA, VIGAin, VIGAresult, NUMVIGAS)
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
% Rotina para calcular a taxa de armadura transversal
% -------------------------------------------------------------------------
% MODIFICA��ES:         
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: VIGA, VIGAin, VIGAresult
% VARI�VEIS DE SA�DA:   VIGAresult, ARRANJOESTRIBO
%--------------------------------------------------------------------------
% CRIADA EM 01-fevereiro-2016
% -------------------------------------------------------------------------

ntrechos=VIGAin.COMPRIMENTO(NUMVIGAS)/VIGAin.Ltrecho; % <-- N�mero de trechos que a viga ser� dividida, � dado pelo usu�rio em DADOS.in
nsectrecho=VIGAin.Ltrecho/VIGAin.compelem(1,1);  % <-- N�mero de se��es no trecho onde o EC � tomado constante
%Vd=VIGAin.V(NUMVIGAS,:);                    % <-- Vetor com os valores do EC na viga
Vd=VIGAin.V;
% Remove zeros - aqui ser� utilizada a rotina RemoveZeros.m, a princ�io
% desenvolvida para remover os zeros do vertor MF, adaptada para remover os
% zeros do vetor EC.
% M=Vd;
% M=beamRemoveZeros(M);
% Vd=M;

% Cria��o de matrizes nulas para otimizar o tempo de processamento

Vmax=zeros(1,ntrechos);
ARRANJOESTRIBO=zeros(1,ntrechos);
for i=1:ntrechos    
    V=Vd(1+nsectrecho*(i-1):(nsectrecho+1)+nsectrecho*(i-1)); % <-- Retira do vetor de esfor�o cortante, os valores referentes ao trecho de 1,25m
    Vmax(i)=max(abs(V));
end


% C�lculo da tens�o de cisalhamento solicitante
tauSd=Vmax./(VIGAin.b*0.9*VIGAin.h);

% C�lculo da tens�o de cisalhamento resistente
alfav2=1-(VIGAin.fcd/1000)/250; % <-- A divis�o por mil � para transformar a unidade para MPa
tauRd2I=0.27*alfav2*VIGAin.fcd; 

% Verifica��o quanto ao esmagamento da biela de compress�o
if tauSd<tauRd2I
    % Parcela do esfor�o cortante absorvida pelo concreto, kN/m2
    tauc=0.6*VIGAin.fctd;
    % Parcela do esfor�o cortante a ser absorvida pela armadura, kN/m2
    tauwd=tauSd-tauc;
    % Tag para entrar no loop de dimensionamento
    tagestribo=0;
    rosw90=1.11*tauwd/VIGAin.fyd;
    for i=1:ntrechos
        if rosw90(i)<VIGAin.rosw90min
            rosw90(i)=VIGAin.rosw90min;
        end
        tagestribo=0;
        for j=1:VIGAin.qntbitolastrans
            if tagestribo==0;
                Asw=2*(pi*(VIGA.TABELATRANS(j)/1000)^2)/4;
                s=Asw/(rosw90(i)*VIGAin.b);
                if s<0.05
                    tagestribo=0;
                elseif s>0.2
                    s=0.2;
                end
                tagestribo=1;
                bitolaestribo=VIGA.TABELATRANS(j);
            end
        end
        ARRANJOESTRIBO(1,i)=bitolaestribo;
        ARRANJOESTRIBO(2,i)=s;
    end
else
    disp('Esmagamento da biela de compress�o')
    VIGAresult.tagdimcorte=1;
end
