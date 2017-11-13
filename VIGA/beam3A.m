function [VIGAresult]=beam3A(AsCalculadoSup, VIGA, VIGAin, ARRANJOLONGsup)
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
% Rotina para calcular o peso total da armadura positiva.
% -------------------------------------------------------------------------
% MODIFICAÇÕES:         
%--------------------------------------------------------------------------
% VARIÁVEIS DE ENTRADA: VIGAin, ARRANJOLONGinf, lbnecVante, lbnecRe, al, Abarra, MCOORD, AsCalculadoInf
% VARIÁVEIS DE SAÍDA:   PESO - peso de armadura positiva
%--------------------------------------------------------------------------
% CRIADA EM 10-outubro-2015
% -------------------------------------------------------------------------
Ascomp=max(AsCalculadoSup);
tag=0;
for i=1:VIGAin.qntbitolaslong
    if tag==0
        Abarra=pi*(VIGA.TABELALONG(i)/1000)^2/4;
        if Ascomp<2*Abarra
            nbarras=ceil(Ascomp/Abarra);
            tag=1;
            bitola=VIGA.TABELALONG(i);
            if nbarras<=1
                nbarras=2;
            end
        end
    end
end
s=size(AsCalculadoSup);
s=s(2);
for i=1:s
    if AsCalculadoSup(i)>0
        VIGAresult.ARRANJOLONGsup(i, 1)=nbarras;
        VIGAresult.ARRANJOLONGsup(i, 2)=bitola;
    end
end
