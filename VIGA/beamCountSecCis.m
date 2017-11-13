function [VIGAout]=beamCountSecCis(VIGA, VIGAin, VIGAout)
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
% 
% -------------------------------------------------------------------------
% MODIFICAÇÕES:         
%--------------------------------------------------------------------------
% VARIÁVEIS DE ENTRADA: VIGAout
% VARIÁVEIS DE SAÍDA:   VIGAout: structure contendo os dados de saída da
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

