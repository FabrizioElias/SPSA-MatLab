function M=beamRemoveZeros(M)
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
% Rotina para remover os zeros da variável M. M é um vetor contendo os
% valores do MF em um determinado trecho da viga.
% -------------------------------------------------------------------------
% MODIFICAÇÕES:         
%--------------------------------------------------------------------------
% VARIÁVEIS DE ENTRADA: M: linha da matriz VIGAout.NEG
% VARIÁVEIS DE SAÍDA:   M: mesma variável sem os zeros
%--------------------------------------------------------------------------
% CRIADA EM 07-novembro-2015
% -------------------------------------------------------------------------
% Remove os zeros do DMF
s=size(M);
numsec=s(2);

j=1;
%FAB - Prealocação de matriz.
A = zeros(numsec,1);
for i=1:numsec
    if M(i)~=0
        A(j)=M(i);
        j=j+1;
    end 
end
M=A;