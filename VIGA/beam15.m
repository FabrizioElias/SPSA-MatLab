function [VIGAresult]=beam15(ARRANJOESTRIBO, VIGAresult, VIGAin, NUMVIGAS)
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
% Rotina para calcular a peso da armadura transversal
% -------------------------------------------------------------------------
% MODIFICAÇÕES:         
%--------------------------------------------------------------------------
% VARIÁVEIS DE ENTRADA: ARRANJOESTRIBO, VIGAresult, VIGAin
% VARIÁVEIS DE SAÍDA:   VIGAresult
%--------------------------------------------------------------------------
% CRIADA EM 29-setembro-2016
% -------------------------------------------------------------------------

% Serão calculadas as áresa de aco para os estribos em agrupamentos de
% 1,25metros, ou seja, os trechos entre seções adjacentes serão agrupados
% em 5 a 5 e a armadura calculada para o valor do cortante máximo exitente
% no trecho.
%Ltrecho=VIGAin.COMPRIMENTO/VIGAin.divtrans;
%nsectrecho=Ltrecho/VIGAin.compelem;
%ntrechos=VIGAin.COMPRIMENTO/Ltrecho;
ntrechos=VIGAin.COMPRIMENTO(NUMVIGAS)/VIGAin.Ltrecho; % <-- Número de trechos que a viga será dividida, é dado pelo usuário em DADOS.in


PESOestribos=0;

for i=1:ntrechos
    nbarras=floor(VIGAin.Ltrecho/ARRANJOESTRIBO(2,i));
    Asw=pi*(ARRANJOESTRIBO(1,i)/1000)^2/4;
    compestribo=(2*(VIGAin.b-2*VIGAin.cob-ARRANJOESTRIBO(1,i)/1000)+2*(VIGAin.h-2*VIGAin.cob-ARRANJOESTRIBO(1,i)/1000));
    PESO=nbarras*Asw*compestribo*VIGAin.roaco*100;
    PESOestribos=PESOestribos+PESO;
end
VIGAresult.PESOestribos(NUMVIGAS)=PESOestribos;