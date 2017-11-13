function [VIGAresult, VIGAin]=beam10(VIGAin, ARRANJOLONGinf, lbnecVante, lbnecRe, al, Abarra, MCOORD, AsCalculadoInf, NUMVIGAS, VIGAresult)
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
% CRIADA EM 07-novembro-2015
% -------------------------------------------------------------------------

% OBSERVA��O DE EXTREMA IMPORT�NCIA!!!! ESSA ROTINA FOI FEITA DE FORMA QUE
% N�O MUITO GENERALIZADA, OU SEJA, ELA FUNCIONA PERFEITAMENTE PARA O DMF DA
% VIGA DO EXEMPLO EM QUEST�O ONDE TEM-SE MF NEGATIVO NO APOIO ESQUERDO E MF
% POSITIVO NO APOIO DIREITO. SITUA��ES ONDE ESSA CONFIGURA��O FOR ALTERADA
% TER� QUE SER FEITO UM AJUSTE NESSA ROTINA DE FORMA A TORN�-LA MAIS GERAL.

% Comprimento das barras entre se��es - Foi considerado que o DMF ser�
% escalonado em 5 partes, logo a vari�vel "VIGAin.numsecoestrechopos" ser�
% igual a 5 e foi definida na rotina beamPos.m, na primeira linha.

% A vari�vel MCOORD � uma atriz 5x3, conde a primera coluna cont�m os
% valores dos MF nas cinco se��es arbitradas (VIGAin.numsecoestrechopos=5, vide
% coment�rio anterior), a segunda coluna os 

Lbarra=zeros(1,VIGAin.numsecoestrechopos);
for i=1:VIGAin.numsecoestrechopos
    Lbarra(i)=abs(MCOORD(i,2)-MCOORD(i,3));
end
Lbarra(VIGAin.numsecoestrechopos)=VIGAin.COMPRIMENTO(NUMVIGAS);
Lbarra=fliplr(Lbarra);

% Verifica��o da armadura m�nima no apoio
Asvao=max(AsCalculadoInf);
Asapoio=Asvao/3;
nbarras=ceil(Asapoio./Abarra);

%FAB - Prealoca��o n�o � recomendada aqui pois abaixo, Q � retorno de uma
%fun��o.
%Q=zeros(VIGAin.numsecoestrechopos,1);

% Nesse loop ser� verificado a qnt m�nima de barras no apoio. A vari�vel
% nbarras � a qnt m�nima de barras no apoio.
a=zeros(1,VIGAin.numsecoestrechopos);
if nbarras<2
    nbarras=2;
end
if ARRANJOLONGinf(1,1)~=0
    AR=fliplr(ARRANJOLONGinf(:,1)')';
    a(1)=nbarras;
    for j=1:VIGAin.numsecoestrechopos-1
        aa=AR(j+1)-sum(a);
        if aa<0
            a(j+1)=0;
        else
            a(j+1)=aa;
        end
    end
end
Q=fliplr(a')';

Q=Q';
        
COMP=zeros(1,VIGAin.numsecoestrechopos);
vol=zeros(1,VIGAin.numsecoestrechopos);

    COMP(1)=Lbarra(1)+2*lbnecRe+2*al+2*8*ARRANJOLONGinf(1,2)/1000; % <-- A ultima parcela da soma corresponde ao comprimento dos dois ganchos
    vol(1)=COMP(1)*Abarra.*Q(1);
    for j=2:VIGAin.numsecoestrechopos
        COMP(j)=Lbarra(j)+2*lbnecVante+2*al; % <-- VIDE OBS NO IN�CIO DA P�GINA
        vol(j)=COMP(j)*Abarra.*Q(j);
    end

% A multiplica��o por cem serve para transormar a unidade de kN (unidade
% utilizada no arquivos de input) para kgf, unidade mais f�cil de assimilar
% como output.
%FAB - Remo��o da transposi��o da matriz e coloca��o da instru��o para
%somar as linhas de vol.
%PESO=sum(vol').*VIGAin.roaco*100;
PESO=sum(vol, 2).*VIGAin.roaco*100;

VIGAresult.PESOpos(NUMVIGAS)=PESO;

% C�LCULO DO PESO DE A�O DAS ARMADURAS DE COMPRESS�O
s= size(VIGAresult.ARRANJOLONGsup);
s=s(1);
% Comprimento da armadura de compress�o
Lcomp=fliplr(Lbarra);
VIGAin.Lcomp=Lcomp(s)+2*lbnecVante;
% �rea da barra utilizada no arranjo das armaduras de compress�o
Abarracomp=pi*(VIGAresult.ARRANJOLONGsup(2)/1000)^2/4;
% Volume das barras do arranjo da armadura de compress�o
volcomp= VIGAresult.ARRANJOLONGsup(1,1)*Abarracomp*VIGAin.Lcomp;
% Peso total das armaduras de compress�o
VIGAresult.PESOcomp(NUMVIGAS)=volcomp*VIGAin.roaco*100;

