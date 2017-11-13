function [SOLO]=soilarea(DADOS, PORTICO, SOLO)
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
% Rotina para determina��o da �rea de cada elemento da discretiza��o do
% encontro/estaca em contato com o solo.
% -------------------------------------------------------------------------
% MODIFICA��ES:         
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: --
% VARI�VEIS DE SA�DA:   PILARin: "structure" contendo as vari�veis necess�-
% rias ao algoritmo de detalhamento do pilar - column.m 
%--------------------------------------------------------------------------
% CRIADA EM 31-julho-2017
% -------------------------------------------------------------------------

% ESTACA
% Qnt. de n�s na estaca
nosestaca=linspace(SOLO.Niestaca,SOLO.Nfestaca,(SOLO.Nfestaca-SOLO.Niestaca+1));
sest=size(nosestaca);
sest=sest(2);
% Vetor contendo a largura da estaca em cada n�
SOLO.Lestaca=ones(sest,1);
SOLO.Lestaca=DADOS.Lest*SOLO.Lestaca;
% ENCONTRO
% Qnt. de n�s do encontro
nosencontro=linspace(SOLO.Niencontro+1,SOLO.Nfencontro,SOLO.Nfencontro-SOLO.Niencontro);
senc=size(nosencontro);
senc=senc(2);
% Vetor contendo a largura do encontro em cada n�
SOLO.Lencontro=ones(senc,1);
SOLO.Lencontro=DADOS.Lenc*SOLO.Lencontro;
nos=[nosestaca,nosencontro];
s=size(nos);
s=s(2);
% Altura de cada elemento
h=zeros(s,1);
% Altura da �rea de influ�ncia do n�
SOLO.H=zeros(s-1,1);
for i=1:s
    h(i)=PORTICO.coord(i+1,2)-PORTICO.coord(i,2);
end
hh=zeros(s+1,1);
hh(2:s+1)=h;
for i=1:s
    SOLO.H(i)=(hh(i)+hh(i+1))/2;
end
SOLO.L=[SOLO.Lestaca;SOLO.Lencontro];
SOLO.A=SOLO.L.*SOLO.H;
SOLO.A(SOLO.Nfestaca)=(SOLO.A(SOLO.Nfestaca+1)+SOLO.A(SOLO.Nfestaca-1))/2;