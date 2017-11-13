function [SOLO]=soilcheck(PORTICO, DADOS, PILAR, ESTRUTURAL, TRANSX, SOLO, COMBSoil)
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
% Rotina para varifica��o da capacidade de carga do solo proveniente do
% empuxo passivo.
% -------------------------------------------------------------------------
% MODIFICA��ES:         
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: --
% VARI�VEIS DE SA�DA:   PILARin: "structure" contendo as vari�veis necess�-
% rias ao algoritmo de detalhamento do pilar - column.m 
%--------------------------------------------------------------------------
% CRIADA EM 31-JULHO-2017
% -------------------------------------------------------------------------

% Cria��o do vetor nulo ELU


% Determina o valor dos deslocamentos ao longo da altura do encontro/estaca.
%[SOLO]=soildispl(TRANSX, DADOS, ESTRUTURAL, PILAR, PORTICO);
% Calcula o valor da �rea do encontro/estaca de cada trecho em contato com
% o solo.
[SOLO]=soilarea(DADOS, PORTICO, SOLO);
% Determina o valor da tens�o no solo proveniente do empuxo passivo
%[SOLO]=soilreac(TRANSX, DADOS, ESTRUTURAL, PILAR, SOLO, PORTICO);

%-------------------------------------------------------------------------%
%--- AMOSTRAGEM DAS TENS�ES ADMISS�VEIS DO SOLO - MAIS UMA GAMBIARRA  ----%
z=randn(1, DADOS.NMC);
sigmasolo=DADOS.covSOLO*DADOS.sigmaadm;
tensaoadmV=DADOS.sigmaadm+z*sigmasolo;
%-------------------------------------------------------------------------%
%Verifica��o da se��o transversal � ruptura
SOLO.ELU=zeros(DADOS.NMC,12);
SOLO.FS=zeros(DADOS.NMC,12);
% SOLO.Sd=zeros(DADOS.NMC,33,12);
for j=1:DADOS.NMC
    for i=1:12
        disp=COMBSoil(j,:,i);
        s=size(disp);
        s=s(2);
        springEncEncurt=PORTICO.springsEncurtV(SOLO.Niencontro:SOLO.Nfencontro, DADOS.NMC);
        springEncAlong=PORTICO.springsAlongV(SOLO.Niencontro:SOLO.Nfencontro, DADOS.NMC);
        springEstEncurt=PORTICO.springsEncurtV(SOLO.Niestaca:SOLO.Nfestaca-1, DADOS.NMC);
        springEstAlong=PORTICO.springsAlongV(SOLO.Niestaca:SOLO.Nfestaca-1, DADOS.NMC);
        springTotalEncurt=[springEstEncurt', springEncEncurt'];
        springTotalAlong=[springEstAlong', springEncAlong'];
        for k=1:s
            if disp(k)>=0
                spring(k)=springTotalEncurt(k);
            else
                spring(k)=springTotalAlong(k);
            end
        end
        
        Rd=disp.*spring;    % <-- Rea��o na mola
        Sd=Rd./SOLO.A';     % <-- Tens�o atuante em cada trecho do encontro
        Sdmaxabs=max(abs(Sd));  % <-- Valor m�ximo absoluto da tens�o no encontro
        SOLO.FS(j,i)=1-Sdmaxabs/tensaoadmV(j);
        if SOLO.FS(j,i)<0 % Condi��o de ruptura
            SOLO.ELU(j,i)=1;
        end
    end 
end



