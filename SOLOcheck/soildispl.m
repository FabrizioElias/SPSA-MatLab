function [SOLO]=soildispl(TRANSX, DADOS, ESTRUTURAL,PORTICO)
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
% Rotina para determinação dos deslocamentos horizontais ao longo do
% encontro e do estaqueamento.
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

% Quantidade de nós existente na discretização do elemento estrutural -
% encontro + estaca
SOLO.Niestaca=PORTICO.conec(ESTRUTURAL.D(1,1),1) ;   % Nó inicial da estaca
SOLO.Nfestaca=PORTICO.conec(ESTRUTURAL.D(1,2),2) ;   % Nó final da estaca
SOLO.nnosestaca=SOLO.Nfestaca-SOLO.Niestaca+1;       % Qnt. de nos na estaca
SOLO.Niencontro=PORTICO.conec(ESTRUTURAL.D(2,1),1);  % Nó inicial encontro
SOLO.Nfencontro=PORTICO.conec(ESTRUTURAL.D(2,2),2);  % Nó final encontro
SOLO.nnosencontro=SOLO.Nfencontro-SOLO.Niencontro+1; % Qnt. de nós no encontro
SOLO.nnostotal=SOLO.nnosestaca+SOLO.nnosencontro-1;  % Qnt. total de nós estaca+encontro

DPP=zeros(DADOS.NMC,SOLO.nnostotal);
DPROT=zeros(DADOS.NMC,SOLO.nnostotal);
DTempPOS=zeros(DADOS.NMC,SOLO.nnostotal);
DTempNEG=zeros(DADOS.NMC,SOLO.nnostotal);
DTD=zeros(DADOS.NMC,SOLO.nnostotal);
DTREMTIPO=zeros(DADOS.NMC,SOLO.nnostotal);
DEMPSOLO=zeros(DADOS.NMC,SOLO.nnostotal);


% Deslocamentos provenientes do peso próprio da estrutura
deslest=TRANSX.PP{1,1,m};
sest=size(deslest);
sest=sest(2);
deslenc=TRANSX.PP{2,1,m};
DPP(m,:)=[deslest(1:sest-1),deslenc];
% Deslocamentos provenientes da sobrecarga aplicada
deslest=TRANSX.PROT{1,1,m};
deslenc=TRANSX.PROT{2,1,m};
DPROT(m,:)=[deslest(1:sest-1),deslenc];
% Deslocamentos provenientes da variação positiva de temperatura
deslest=TRANSX.TempPOS{1,1,m};
deslenc=TRANSX.TempPOS{2,1,m};
DTempPOS(m,:)=[deslest(1:sest-1),deslenc];
% Deslocamentos provenientes da variação negativa de temperatura
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





