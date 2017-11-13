function [SOLO]=soilreac(TRANSX, DADOS, ESTRUTURAL, PILAR, SOLO, PORTICO)
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
% Rotina para cálculo do empuxo passivo proveniente dos movimentos de
% expansão e contração da ponte.
% -------------------------------------------------------------------------
% MODIFICAÇÕES:         
%--------------------------------------------------------------------------
% VARIÁVEIS DE ENTRADA: --
% VARIÁVEIS DE SAÍDA:   PILARin: "structure" contendo as variáveis necessá-
% rias ao algoritmo de detalhamento do pilar - column.m 
%--------------------------------------------------------------------------
% CRIADA EM 31-julho-2017
% -------------------------------------------------------------------------

s=size(SOLO.DeslTempPOS(1,:));
s=s(2);
SOLO.ELU=zeros(DADOS.NMC,s);
for i=1:DADOS.NMC
    disp=SOLO.DeslTempPOS(i,:);
    springEnc=PORTICO.springsV(SOLO.Niencontro:SOLO.Nfencontro, DADOS.NMC);
    springEst=PORTICO.springsV(SOLO.Niestaca:SOLO.Nfestaca-1, DADOS.NMC);
    springTotal=[springEst', springEnc'];
    Fs=disp.*springTotal;
    Ss=Fs./SOLO.A';
    % Verificação
    SOLO.ELU(i,:)=Ss>DADOS.sigmaadm;  
end




