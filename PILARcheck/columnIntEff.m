function [PILAR]=columnIntEff(MOMENTO, NORMAL, DADOS, ESTRUTURAL, PILAR)
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
% Rotina para determinação dos esforços internos atuantes no pilar.
% -------------------------------------------------------------------------
% MODIFICAÇÕES:         
%--------------------------------------------------------------------------
% VARIÁVEIS DE ENTRADA: --
% VARIÁVEIS DE SAÍDA:   PILARin: "structure" contendo as variáveis necessá-
% rias ao algoritmo de detalhamento do pilar - column.m 
%--------------------------------------------------------------------------
% CRIADA EM 31-julho-2017
% -------------------------------------------------------------------------

global m

% "v" é um vetor contendo os elementos estruturais que serão dimensionados.
% No caso os quatro pilares: dois encontros, tratados como pilares e dois
% pilares internos.
% basta dimensionar 
v=[2 7 8 9];
s=size(v);
s=s(2);
PILAR.MPP=zeros(s,1);
PILAR.MPP=zeros(s,1);
PILAR.NPP=zeros(s,1);
PILAR.MPROT=zeros(s,1);
PILAR.NPROT=zeros(s,1);
PILAR.MTempPOS=zeros(s,1);
PILAR.NTempPOS=zeros(s,1);
PILAR.MTempNEG=zeros(s,1);
PILAR.NTempNEG=zeros(s,1);
PILAR.MTD=zeros(s,1);
PILAR.NTD=zeros(s,1);
PILAR.MTREMTIPO=zeros(s,1);
PILAR.NTREMTIPO=zeros(s,1);
PILAR.MEMPSOLO=zeros(s,1);
PILAR.NEMPSOLO=zeros(s,1);


for i=1:s
    % Quantidade de nós existente na discretização do elemento estrutural
    nnos=ESTRUTURAL.D(v(i),2)-ESTRUTURAL.D(v(i),1)+2;

    MPP=MOMENTO.PP{v(i),1,m};
    NPP=NORMAL.PP{v(i),1,m};
    MPROT=MOMENTO.PROT{v(i),1,m};
    NPROT=NORMAL.PROT{v(i),1,m};
    MTempPOS=MOMENTO.MTempPOS{v(i),1,m};
    NTempPOS=NORMAL.NTempPOS{v(i),1,m};
    MTempNEG=MOMENTO.MTempNEG{v(i),1,m};
    NTempNEG=NORMAL.NTempNEG{v(i),1,m};
    MTD=MOMENTO.MTD{v(i),1,m};
    NTD=NORMAL.NTD{v(i),1,m};
    MTREMTIPO=MOMENTO.TREMTIPO{v(i),1,m};
    NTREMTIPO=NORMAL.TREMTIPO{v(i),1,m};
    MEMPSOLO=MOMENTO.EMPSOLO{v(i),1,m};
    NEMPSOLO=NORMAL.EMPSOLO{v(i),1,m};

    PILAR.MPP(i)=max(abs(MPP));
    PILAR.NPP(i)=(min(NPP')');
    PILAR.MPROT(i)=max(abs(MPROT));
    PILAR.NPROT(i)=(min(NPROT')');
    PILAR.MTempPOS(i)=max(abs(MTempPOS));
    PILAR.NTempPOS(i)=(min(NTempPOS')');
    PILAR.MTempNEG(i)=max(abs(MTempNEG));
    PILAR.NTempNEG(i)=(min(NTempNEG')');
    PILAR.MTD(i)=max(abs(MTD));
    PILAR.NTD(i)=(min(NTD')');
    PILAR.MTREMTIPO(i)=max(abs(MTREMTIPO));
    PILAR.NTREMTIPO(i)=(min(NTREMTIPO')');
    PILAR.MEMPSOLO(i)=max(abs(MEMPSOLO));
    PILAR.NEMPSOLO(i)=(min(NEMPSOLO')');
end


