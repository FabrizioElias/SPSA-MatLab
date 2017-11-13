function [SOLO]=soilreac(TRANSX, DADOS, ESTRUTURAL, PILAR, SOLO, PORTICO)
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
% Rotina para c�lculo do empuxo passivo proveniente dos movimentos de
% expans�o e contra��o da ponte.
% -------------------------------------------------------------------------
% MODIFICA��ES:         
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: --
% VARI�VEIS DE SA�DA:   PILARin: "structure" contendo as vari�veis necess�-
% rias ao algoritmo de detalhamento do pilar - column.m 
%--------------------------------------------------------------------------
% CRIADA EM 31-julho-2017
% -------------------------------------------------------------------------

s=size(SOLO.DeslTempPOS(1,:));
s=s(2);
SOLO.ELU=zeros(DADOS.NMC,s);
for i=1:DADOS.NMC
    disp=SOLO.DeslTempPOS(i,:);
    springEnc=PORTICO.springsV(SOLO.Niencontro:SOLO.Nfencontro, DADOS.NMC);
    springEst=PORTICO.springsV(SOLO.Niestaca:SOLO.Nfestaca-1, DADOS.NMC);
    springTotal=[springEst', springEnc'];
    Fs=disp.*springTotal;
    Ss=Fs./SOLO.A';
    % Verifica��o
    SOLO.ELU(i,:)=Ss>DADOS.sigmaadm;  
end




