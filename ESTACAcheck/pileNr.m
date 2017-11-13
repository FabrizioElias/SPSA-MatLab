function [ESTACA]=pileNr(ESTRUTURAL, ELEMENTOS, PAR, DADOS)
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
% Rotina para determina��o esfor�o norMal resistente. � dispensada a
% verifica��o � flambagem uma vez que o perfil estar� enterrado.
% verifica��o � flamb
% -------------------------------------------------------------------------
% MODIFICA��ES:         
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: --
% VARI�VEIS DE SA�DA:   PILARin: "structure" contendo as vari�veis necess�-
% rias ao algoritmo de detalhamento do pilar - column.m 
%--------------------------------------------------------------------------
% CRIADA EM 01-agosto-2017
% -------------------------------------------------------------------------

% Valor de QSI calculado no MATHCAD e inserido diretamente. Arrumar isso
% depois
qsi=0.973;
% Valor de Q (Q=Qa*Qs) iserido diretamente, arrumar isso depois,
% automatizando.
Q=1;
ESTACA.Nr=zeros(1,DADOS.NMC);
ESTACA.Nr=Q*qsi*ELEMENTOS.A(ESTRUTURAL.D(1,1))*PAR.STEEL.fyV;

