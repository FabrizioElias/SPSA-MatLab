function [VIGAresult]=beam3A(AsCalculadoSup, VIGA, VIGAin, ARRANJOLONGsup)
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
% Rotina para calcular o peso total da armadura positiva.
% -------------------------------------------------------------------------
% MODIFICA��ES:         
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: VIGAin, ARRANJOLONGinf, lbnecVante, lbnecRe, al, Abarra, MCOORD, AsCalculadoInf
% VARI�VEIS DE SA�DA:   PESO - peso de armadura positiva
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
