function [PORTICO]=temp(GG,PORTICO)
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
% Função irá escrever na structure PORTICO a variação de temperatura
% uniforme a qual determinados elementos estarão submetidos
% -------------------------------------------------------------------------
% Criada      13-janeiro-2017                 SÉRGIO MARQUES
% -------------------------------------------------------------------------

s=size(GG);
s=s(1);
PORTICO.qntelemtemp=s/6;
PORTICO.TempMax=zeros(PORTICO.nelem,1);
PORTICO.TempMin=zeros(PORTICO.nelem,1);
PORTICO.TempPDF=zeros(PORTICO.nelem,1);
PORTICO.TempParEst1=zeros(PORTICO.nelem,1);
PORTICO.TempParEst2=zeros(PORTICO.nelem,1);

for i=1:PORTICO.qntelemtemp
    aux=GG((1+6*(i-1):6*(i-1)+6))'; 
    PORTICO.elemcargatemp(i,1)=aux(1);
    PORTICO.TempMax(PORTICO.elemcargatemp(i,1),1)=aux(2);
    PORTICO.TempMin(PORTICO.elemcargatemp(i,1),1)=aux(3);
    PORTICO.TempPDF(PORTICO.elemcargatemp(i,1),1)=aux(4);
    PORTICO.TempParEst1(PORTICO.elemcargatemp(i,1),1)=aux(5);
    PORTICO.TempParEst2(PORTICO.elemcargatemp(i,1),1)=aux(6);
end