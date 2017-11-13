function [VIGAresult, ARRANJOESTRIBO]=beam14(VIGA, VIGAin, VIGAresult, NUMVIGAS)
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
% Rotina para calcular a taxa de armadura transversal
% -------------------------------------------------------------------------
% MODIFICAÇÕES:         
%--------------------------------------------------------------------------
% VARIÁVEIS DE ENTRADA: VIGA, VIGAin, VIGAresult
% VARIÁVEIS DE SAÍDA:   VIGAresult, ARRANJOESTRIBO
%--------------------------------------------------------------------------
% CRIADA EM 01-fevereiro-2016
% -------------------------------------------------------------------------

ntrechos=VIGAin.COMPRIMENTO(NUMVIGAS)/VIGAin.Ltrecho; % <-- Número de trechos que a viga será dividida, é dado pelo usuário em DADOS.in
nsectrecho=VIGAin.Ltrecho/VIGAin.compelem(1,1);  % <-- Número de seções no trecho onde o EC é tomado constante
%Vd=VIGAin.V(NUMVIGAS,:);                    % <-- Vetor com os valores do EC na viga
Vd=VIGAin.V;
% Remove zeros - aqui será utilizada a rotina RemoveZeros.m, a princíio
% desenvolvida para remover os zeros do vertor MF, adaptada para remover os
% zeros do vetor EC.
% M=Vd;
% M=beamRemoveZeros(M);
% Vd=M;

% Criação de matrizes nulas para otimizar o tempo de processamento

Vmax=zeros(1,ntrechos);
ARRANJOESTRIBO=zeros(1,ntrechos);
for i=1:ntrechos    
    V=Vd(1+nsectrecho*(i-1):(nsectrecho+1)+nsectrecho*(i-1)); % <-- Retira do vetor de esforço cortante, os valores referentes ao trecho de 1,25m
    Vmax(i)=max(abs(V));
end


% Cálculo da tensão de cisalhamento solicitante
tauSd=Vmax./(VIGAin.b*0.9*VIGAin.h);

% Cálculo da tensão de cisalhamento resistente
alfav2=1-(VIGAin.fcd/1000)/250; % <-- A divisão por mil é para transformar a unidade para MPa
tauRd2I=0.27*alfav2*VIGAin.fcd; 

% Verificação quanto ao esmagamento da biela de compressão
if tauSd<tauRd2I
    % Parcela do esforço cortante absorvida pelo concreto, kN/m2
    tauc=0.6*VIGAin.fctd;
    % Parcela do esforço cortante a ser absorvida pela armadura, kN/m2
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
    disp('Esmagamento da biela de compressão')
    VIGAresult.tagdimcorte=1;
end
