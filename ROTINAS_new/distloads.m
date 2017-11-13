function [PORTICO]=distloads(F,PORTICO)
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

s=size(F);
s=s(1);
PORTICO.qntelemcargadist=s/6;
PORTICO.qntelemcargadisty=0;
PORTICO.qntelemcargadistx=0;

for i=1:PORTICO.qntelemcargadist
    FF=F((1+6*(i-1):1+6*(i-1)+5))';
    if FF(2)~=0     % Carga ditribuída em x local
        PORTICO.elemcargadistx(i)=FF(1);
        PORTICO.cargadistx(i)=FF(2);
        PORTICO.cargadistxPDF(i)=FF(4);
        PORTICO.cargadistxParEst1(i)=FF(5);
        PORTICO.cargadistxParEst2(i)=FF(6);
        PORTICO.qntelemcargadistx=PORTICO.qntelemcargadistx+1;
    end
    if FF(3)~=0
        PORTICO.elemcargadisty(i)=FF(1);
        PORTICO.cargadisty(i)=FF(3);
        PORTICO.cargadistyPDF(i)=FF(4);
        PORTICO.cargadistyParEst1(i)=FF(5);
        PORTICO.cargadistyParEst2(i)=FF(6);
        PORTICO.qntelemcargadisty=PORTICO.qntelemcargadisty+1;
    end
end

PORTICO.qntelemcargadist=PORTICO.qntelemcargadistx+PORTICO.qntelemcargadisty;