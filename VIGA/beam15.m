function [VIGAresult]=beam15(ARRANJOESTRIBO, VIGAresult, VIGAin, NUMVIGAS)
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
% Rotina para calcular a peso da armadura transversal
% -------------------------------------------------------------------------
% MODIFICA��ES:         
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: ARRANJOESTRIBO, VIGAresult, VIGAin
% VARI�VEIS DE SA�DA:   VIGAresult
%--------------------------------------------------------------------------
% CRIADA EM 29-setembro-2016
% -------------------------------------------------------------------------

% Ser�o calculadas as �resa de aco para os estribos em agrupamentos de
% 1,25metros, ou seja, os trechos entre se��es adjacentes ser�o agrupados
% em 5 a 5 e a armadura calculada para o valor do cortante m�ximo exitente
% no trecho.
%Ltrecho=VIGAin.COMPRIMENTO/VIGAin.divtrans;
%nsectrecho=Ltrecho/VIGAin.compelem;
%ntrechos=VIGAin.COMPRIMENTO/Ltrecho;
ntrechos=VIGAin.COMPRIMENTO(NUMVIGAS)/VIGAin.Ltrecho; % <-- N�mero de trechos que a viga ser� dividida, � dado pelo usu�rio em DADOS.in


PESOestribos=0;

for i=1:ntrechos
    nbarras=floor(VIGAin.Ltrecho/ARRANJOESTRIBO(2,i));
    Asw=pi*(ARRANJOESTRIBO(1,i)/1000)^2/4;
    compestribo=(2*(VIGAin.b-2*VIGAin.cob-ARRANJOESTRIBO(1,i)/1000)+2*(VIGAin.h-2*VIGAin.cob-ARRANJOESTRIBO(1,i)/1000));
    PESO=nbarras*Asw*compestribo*VIGAin.roaco*100;
    PESOestribos=PESOestribos+PESO;
end
VIGAresult.PESOestribos(NUMVIGAS)=PESOestribos;