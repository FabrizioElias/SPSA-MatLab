function M=beamRemoveZeros(M)
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
% Rotina para remover os zeros da vari�vel M. M � um vetor contendo os
% valores do MF em um determinado trecho da viga.
% -------------------------------------------------------------------------
% MODIFICA��ES:         
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: M: linha da matriz VIGAout.NEG
% VARI�VEIS DE SA�DA:   M: mesma vari�vel sem os zeros
%--------------------------------------------------------------------------
% CRIADA EM 07-novembro-2015
% -------------------------------------------------------------------------
% Remove os zeros do DMF
s=size(M);
numsec=s(2);

j=1;
%FAB - Prealoca��o de matriz.
A = zeros(numsec,1);
for i=1:numsec
    if M(i)~=0
        A(j)=M(i);
        j=j+1;
    end 
end
M=A;