function [SOLO]=soilcheck(PORTICO, DADOS, PILAR, ESTRUTURAL, TRANSX, SOLO, COMBSoil)
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
% Rotina para varificação da capacidade de carga do solo proveniente do
% empuxo passivo.
% -------------------------------------------------------------------------
% MODIFICAÇÕES:         
%--------------------------------------------------------------------------
% VARIÁVEIS DE ENTRADA: --
% VARIÁVEIS DE SAÍDA:   PILARin: "structure" contendo as variáveis necessá-
% rias ao algoritmo de detalhamento do pilar - column.m 
%--------------------------------------------------------------------------
% CRIADA EM 31-JULHO-2017
% -------------------------------------------------------------------------

% Criação do vetor nulo ELU


% Determina o valor dos deslocamentos ao longo da altura do encontro/estaca.
%[SOLO]=soildispl(TRANSX, DADOS, ESTRUTURAL, PILAR, PORTICO);
% Calcula o valor da área do encontro/estaca de cada trecho em contato com
% o solo.
[SOLO]=soilarea(DADOS, PORTICO, SOLO);
% Determina o valor da tensão no solo proveniente do empuxo passivo
%[SOLO]=soilreac(TRANSX, DADOS, ESTRUTURAL, PILAR, SOLO, PORTICO);

%-------------------------------------------------------------------------%
%--- AMOSTRAGEM DAS TENSÕES ADMISSÍVEIS DO SOLO - MAIS UMA GAMBIARRA  ----%
z=randn(1, DADOS.NMC);
sigmasolo=DADOS.covSOLO*DADOS.sigmaadm;
tensaoadmV=DADOS.sigmaadm+z*sigmasolo;
%-------------------------------------------------------------------------%
%Verificação da seção transversal à ruptura
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
        
        Rd=disp.*spring;    % <-- Reação na mola
        Sd=Rd./SOLO.A';     % <-- Tensão atuante em cada trecho do encontro
        Sdmaxabs=max(abs(Sd));  % <-- Valor máximo absoluto da tensão no encontro
        SOLO.FS(j,i)=1-Sdmaxabs/tensaoadmV(j);
        if SOLO.FS(j,i)<0 % Condição de ruptura
            SOLO.ELU(j,i)=1;
        end
    end 
end



