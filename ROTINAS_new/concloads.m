function [PORTICO]=concloads(G,PORTICO)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIENCIAS
% PROGRAMA DE POS-GRADUACAO EM ENGENHARIA CIVIL        - AREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELECAO DE  MEDIA FIDELIDADE  PARA  ANALISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO
% ALUNA       Sérgio José Priori Jovino Marques Filho
% ORIENTADOR  Prof. Ezio da Rocha Araujo
% -------------------------------------------------------------------------
% DESCRICAO
% Função irá escrever na structure PORTICO sa cargas nodais aplicadas ao
% pórtico plano.
% -------------------------------------------------------------------------
% Criada      23-maio-2016                 SÉRGIO MARQUES
% -------------------------------------------------------------------------

s=size(G);
s=s(1);
PORTICO.qntelemcargaconc=s/8;
PORTICO.qntelemcargaconcx=0;
PORTICO.qntelemcargaconcy=0;

for i=1:PORTICO.qntelemcargaconc
    GG=G((1+8*(i-1):1+8*(i-1)+7))';
    if GG(2)~=0     % Carga ditribuída em x local
        PORTICO.elemcargaconcx(i)=GG(1);
        PORTICO.cargaconcx=GG(2);
        PORTICO.distcargaconcx=GG(3);
        PORTICO.cargaconcxPDF=GG(6);
        PORTICO.cargaconcxParEst1=GG(7);
        PORTICO.cargaconcxParEst1=GG(8);
        PORTICO.qntelemcargaconcx=PORTICO.qntelemcargadistx+1;
    end
    if GG(4)~=0
        PORTICO.elemcargaconcy(i)=GG(1);
        PORTICO.cargaconcy(i)=GG(4);
        PORTICO.distcargaconcx=GG(5);
        PORTICO.cargaconcyPDF=GG(6);
        PORTICO.cargaconcyParEst1=GG(7);
        PORTICO.cargaconcyParEst2=GG(8);
        PORTICO.qntelemcargaconcy=PORTICO.qntelemcargadisty+1;
    end
end