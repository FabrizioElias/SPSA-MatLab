function [ESTACA]=pileIntEff(DADOS, MOMENTO, NORMAL, ESTRUTURAL)
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
% Rotina para determinação dos esforços internos atuantes na estaca.
% -------------------------------------------------------------------------
% MODIFICAÇÕES:         
%--------------------------------------------------------------------------
% VARIÁVEIS DE ENTRADA: --
% VARIÁVEIS DE SAÍDA:   PILARin: "structure" contendo as variáveis necessá-
% rias ao algoritmo de detalhamento do pilar - column.m 
%--------------------------------------------------------------------------
% CRIADA EM 01-agosto-2017
% -------------------------------------------------------------------------

% Quantidade de nós existente na discretização do elemento estrutural
nnos=ESTRUTURAL.D(1,2)-ESTRUTURAL.D(1,1)+2;

MPP=zeros(DADOS.NMC,nnos);
MPROT=zeros(DADOS.NMC,nnos);
MTempPOS=zeros(DADOS.NMC,nnos);
MTempNEG=zeros(DADOS.NMC,nnos);
MTD=zeros(DADOS.NMC,nnos);
MTREMTIPO=zeros(DADOS.NMC,nnos);
MEMPSOLO=zeros(DADOS.NMC,nnos);
NPP=zeros(DADOS.NMC,nnos);
NPROT=zeros(DADOS.NMC,nnos);
NTempPOS=zeros(DADOS.NMC,nnos);
NTempNEG=zeros(DADOS.NMC,nnos);
NTD=zeros(DADOS.NMC,nnos);
NTREMTIPO=zeros(DADOS.NMC,nnos);
NEMPSOLO=zeros(DADOS.NMC,nnos);
% Carga de Protensão
for i=1:DADOS.NMC
    MPP(i,:)=MOMENTO.PP{1,1,i};
    NPP(i,:)=NORMAL.PP{1,1,i};
    MPROT(i,:)=MOMENTO.PROT{1,1,i};
    NPROT(i,:)=NORMAL.PROT{1,1,i};
    MTempPOS(i,:)=MOMENTO.MTempPOS{1,1,i};
    NTempPOS(i,:)=NORMAL.NTempPOS{1,1,i};
    MTempNEG(i,:)=MOMENTO.MTempNEG{1,1,i};
    NTempNEG(i,:)=NORMAL.NTempNEG{1,1,i};
    MTD(i,:)=MOMENTO.MTD{1,1,i};
    NTD(i,:)=NORMAL.NTD{1,1,i};
    MTREMTIPO(i,:)=MOMENTO.TREMTIPO{1,1,i};
    NTREMTIPO(i,:)=NORMAL.TREMTIPO{1,1,i};
    MEMPSOLO(i,:)=MOMENTO.EMPSOLO{1,1,i};
    NEMPSOLO(i,:)=NORMAL.EMPSOLO{1,1,i};
end
ESTACA.MPP=MPP(:,nnos);
ESTACA.NPP=(min(NPP')');
ESTACA.MPROT=MPROT(:,nnos);
ESTACA.NPROT=(min(NPROT')');
ESTACA.MTempPOS=MTempPOS(:,nnos);
ESTACA.NTempPOS=(min(NTempPOS')');
ESTACA.MTempNEG=MTempNEG(:,nnos);
ESTACA.NTempNEG=(min(NTempNEG')');
ESTACA.MTD=MTD(:,nnos);
ESTACA.NTD=(min(NTD')');
ESTACA.MTREMTIPO=MTREMTIPO(:,nnos);
ESTACA.NTREMTIPO=(min(NTREMTIPO')');
ESTACA.MEMPSOLO=MEMPSOLO(:,nnos);
ESTACA.NEMPSOLO=(min(NEMPSOLO')');

