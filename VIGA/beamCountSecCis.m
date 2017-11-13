function [VIGAout]=beamCountSecCis(VIGA, VIGAin, VIGAout)
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
% 
% -------------------------------------------------------------------------
% MODIFICA��ES:         
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: VIGAout
% VARI�VEIS DE SA�DA:   VIGAout: structure contendo os dados de sa�da da
% viga
%--------------------------------------------------------------------------
% CRIADA EM 01-fevereiro-2016
% -------------------------------------------------------------------------
V=abs(VIGAin.V)
VV=zeros(1,VIGAin.qntsecoes)
for i=1:VIGAin.qntsecoes
    if V(i)>VIGAin.Vmaxres
        VV(i)=V(i)
    end
end

