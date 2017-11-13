function [VIGAresult, VIGAin]=beam10(VIGAin, ARRANJOLONGinf, lbnecVante, lbnecRe, al, Abarra, MCOORD, AsCalculadoInf, NUMVIGAS, VIGAresult)
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
% CRIADA EM 07-novembro-2015
% -------------------------------------------------------------------------

% OBSERVAÇÃO DE EXTREMA IMPORTÂNCIA!!!! ESSA ROTINA FOI FEITA DE FORMA QUE
% NÃO MUITO GENERALIZADA, OU SEJA, ELA FUNCIONA PERFEITAMENTE PARA O DMF DA
% VIGA DO EXEMPLO EM QUESTÃO ONDE TEM-SE MF NEGATIVO NO APOIO ESQUERDO E MF
% POSITIVO NO APOIO DIREITO. SITUAÇÕES ONDE ESSA CONFIGURAÇÃO FOR ALTERADA
% TERÁ QUE SER FEITO UM AJUSTE NESSA ROTINA DE FORMA A TORNÁ-LA MAIS GERAL.

% Comprimento das barras entre seções - Foi considerado que o DMF será
% escalonado em 5 partes, logo a variável "VIGAin.numsecoestrechopos" será
% igual a 5 e foi definida na rotina beamPos.m, na primeira linha.

% A variável MCOORD é uma atriz 5x3, conde a primera coluna contém os
% valores dos MF nas cinco seções arbitradas (VIGAin.numsecoestrechopos=5, vide
% comentário anterior), a segunda coluna os 

Lbarra=zeros(1,VIGAin.numsecoestrechopos);
for i=1:VIGAin.numsecoestrechopos
    Lbarra(i)=abs(MCOORD(i,2)-MCOORD(i,3));
end
Lbarra(VIGAin.numsecoestrechopos)=VIGAin.COMPRIMENTO(NUMVIGAS);
Lbarra=fliplr(Lbarra);

% Verificação da armadura mínima no apoio
Asvao=max(AsCalculadoInf);
Asapoio=Asvao/3;
nbarras=ceil(Asapoio./Abarra);

%FAB - Prealocação não é recomendada aqui pois abaixo, Q é retorno de uma
%função.
%Q=zeros(VIGAin.numsecoestrechopos,1);

% Nesse loop será verificado a qnt mínima de barras no apoio. A variável
% nbarras é a qnt mínima de barras no apoio.
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
        COMP(j)=Lbarra(j)+2*lbnecVante+2*al; % <-- VIDE OBS NO INÍCIO DA PÁGINA
        vol(j)=COMP(j)*Abarra.*Q(j);
    end

% A multiplicação por cem serve para transormar a unidade de kN (unidade
% utilizada no arquivos de input) para kgf, unidade mais fácil de assimilar
% como output.
%FAB - Remoção da transposição da matriz e colocação da instrução para
%somar as linhas de vol.
%PESO=sum(vol').*VIGAin.roaco*100;
PESO=sum(vol, 2).*VIGAin.roaco*100;

VIGAresult.PESOpos(NUMVIGAS)=PESO;

% CÁLCULO DO PESO DE AÇO DAS ARMADURAS DE COMPRESSÃO
s= size(VIGAresult.ARRANJOLONGsup);
s=s(1);
% Comprimento da armadura de compressão
Lcomp=fliplr(Lbarra);
VIGAin.Lcomp=Lcomp(s)+2*lbnecVante;
% Área da barra utilizada no arranjo das armaduras de compressão
Abarracomp=pi*(VIGAresult.ARRANJOLONGsup(2)/1000)^2/4;
% Volume das barras do arranjo da armadura de compressão
volcomp= VIGAresult.ARRANJOLONGsup(1,1)*Abarracomp*VIGAin.Lcomp;
% Peso total das armaduras de compressão
VIGAresult.PESOcomp(NUMVIGAS)=volcomp*VIGAin.roaco*100;

