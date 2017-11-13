function [SOLO]=soildispl(TRANSX, DADOS, ESTRUTURAL,PORTICO)
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
% Rotina para determina��o dos deslocamentos horizontais ao longo do
% encontro e do estaqueamento.
% -------------------------------------------------------------------------
% MODIFICA��ES:         
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: --
% VARI�VEIS DE SA�DA:   PILARin: "structure" contendo as vari�veis necess�-
% rias ao algoritmo de detalhamento do pilar - column.m 
%--------------------------------------------------------------------------
% CRIADA EM 31-julho-2017
% -------------------------------------------------------------------------

global m

% Quantidade de n�s existente na discretiza��o do elemento estrutural -
% encontro + estaca
SOLO.Niestaca=PORTICO.conec(ESTRUTURAL.D(1,1),1) ;   % N� inicial da estaca
SOLO.Nfestaca=PORTICO.conec(ESTRUTURAL.D(1,2),2) ;   % N� final da estaca
SOLO.nnosestaca=SOLO.Nfestaca-SOLO.Niestaca+1;       % Qnt. de nos na estaca
SOLO.Niencontro=PORTICO.conec(ESTRUTURAL.D(2,1),1);  % N� inicial encontro
SOLO.Nfencontro=PORTICO.conec(ESTRUTURAL.D(2,2),2);  % N� final encontro
SOLO.nnosencontro=SOLO.Nfencontro-SOLO.Niencontro+1; % Qnt. de n�s no encontro
SOLO.nnostotal=SOLO.nnosestaca+SOLO.nnosencontro-1;  % Qnt. total de n�s estaca+encontro

DPP=zeros(DADOS.NMC,SOLO.nnostotal);
DPROT=zeros(DADOS.NMC,SOLO.nnostotal);
DTempPOS=zeros(DADOS.NMC,SOLO.nnostotal);
DTempNEG=zeros(DADOS.NMC,SOLO.nnostotal);
DTD=zeros(DADOS.NMC,SOLO.nnostotal);
DTREMTIPO=zeros(DADOS.NMC,SOLO.nnostotal);
DEMPSOLO=zeros(DADOS.NMC,SOLO.nnostotal);


% Deslocamentos provenientes do peso pr�prio da estrutura
deslest=TRANSX.PP{1,1,m};
sest=size(deslest);
sest=sest(2);
deslenc=TRANSX.PP{2,1,m};
DPP(m,:)=[deslest(1:sest-1),deslenc];
% Deslocamentos provenientes da sobrecarga aplicada
deslest=TRANSX.PROT{1,1,m};
deslenc=TRANSX.PROT{2,1,m};
DPROT(m,:)=[deslest(1:sest-1),deslenc];
% Deslocamentos provenientes da varia��o positiva de temperatura
deslest=TRANSX.TempPOS{1,1,m};
deslenc=TRANSX.TempPOS{2,1,m};
DTempPOS(m,:)=[deslest(1:sest-1),deslenc];
% Deslocamentos provenientes da varia��o negativa de temperatura
deslest=TRANSX.TempNEG{1,1,m};
deslenc=TRANSX.TempNEG{2,1,m};
DTempNEG(m,:)=[deslest(1:sest-1),deslenc];
% Deslocamentos provenientes dos efeitos diferidos do concreto
deslest=TRANSX.TD{1,1,m};
deslenc=TRANSX.TD{2,1,m};
DTD(m,:)=[deslest(1:sest-1),deslenc];
% Deslocamentos provenientes do trem tipo
deslest=TRANSX.TREMTIPO{1,1,m};
deslenc=TRANSX.TREMTIPO{2,1,m};
DTREMTIPO(m,:)=[deslest(1:sest-1),deslenc];
% Deslocamentos provenientes dos empuxo de solo
deslest=TRANSX.EMPSOLO{1,1,m};
deslenc=TRANSX.EMPSOLO{2,1,m};
DEMPSOLO(m,:)=[deslest(1:sest-1),deslenc];


SOLO.DeslPP=DPP;
SOLO.DeslSC=DPROT;
SOLO.DeslTempPOS=DTempPOS;
SOLO.DeslTempNEG=DTempNEG;
SOLO.DeslTD=DTD;
SOLO.DeslTREMTIPO=DTREMTIPO;
SOLO.DeslEMPSOLO=DEMPSOLO;





