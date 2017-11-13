function [VIGAresult, VIGAout]=beam7(trecho, PESO, COMP, lbnecRe, NUMVIGAS, VIGAresult)
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
% Rotina para determinar a bitola que fornecer� o menor peso de a�o para
% armadura negativa em cada trecho
% -------------------------------------------------------------------------
% MODIFICA��ES:         
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: VIGAout
% VARI�VEIS DE SA�DA:   VIGAout: structure contendo os dados de sa�da da
% viga
%--------------------------------------------------------------------------
% CRIADA EM 26-janeiro-2016
% -------------------------------------------------------------------------

global m

% peso=min(PESO);
% menorbitolaneg=find(PESO==peso);

% Peso de a�o da armadura negativa
VIGAresult.PESOneg(NUMVIGAS, trecho, m)=PESO; 

% Comprimento da maior barra do arranjo, necess�rio p calcular a armadura
% de montagem
comp= max(COMP);
VIGAout.COMPneg(trecho)=comp;
VIGAout.lbnecReneg(trecho)=lbnecRe(menorbitolaneg);
