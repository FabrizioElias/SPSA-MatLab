function [N]=esfnormal(PORTICO, ELEMENTOS, KEST, KELEM, ROT, Fsc, fesc, Fpp, fepp, gdle, CARGA)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCI�NCIAS
% PROGRAMA DE P�S-GRADUA��O EM ENGENHARIA CIVIL        - �REA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELE��O DE  M�DIA FIDELIDADE  PARA  AN�LISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO.
% ALUNA       S�rgio Jos� Priori Jovino Marques Filho
% ORIENTADOR  Prof. �zio da Rocha Ara�jo
% -------------------------------------------------------------------------
% DESCRI��O
% Rotina para c�lculo do esfor�o normal nos elementos estruturais
% -------------------------------------------------------------------------
% MODIFICA��ES:         Modificada em 16/05/2015
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: PORTICO, ELEMENTOS, DADOS
% VARI�VEIS DE SA�DA:   esf: esfor�os nodais obtidos � partir do m�todo dos
%                       deslocamentos
%                       CORTANTE, MOMENTO: esfor�os internos nos elementos
%                       do p�rtico.
%--------------------------------------------------------------------------
% CRIADA EM 13-Janeiro-2015
% -------------------------------------------------------------------------

F=Fsc+Fpp;
fe=fesc+fepp;

% Resolve o sistema de equa��es
[esf]=solver2(KEST, F, fe, PORTICO, gdle, KELEM, ROT);
% Calcula o esfor�o axial nas barras
N=axial2(PORTICO, ELEMENTOS, esf,CARGA);