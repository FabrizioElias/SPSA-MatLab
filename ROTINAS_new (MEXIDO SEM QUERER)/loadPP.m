function [Fpp, fepp, CARGA]=loadPP(PORTICO, ELEMENTOS, ROT, gdle, ngl, CARGA)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCI�NCIAS
% PROGRAMA DE P�S-GRADUA��O EM ENGENHARIA CIVIL        - �REA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELE��O DE  M�DIA FIDELIDADE  PARA  AN�LISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO.
% ALUNA       S�rgio Jos� Priori Jovino Marques Filho
% ORIENTADOR  Prof. �zio da Rocha Ara�jo
% -------------------------------------------------------------------------
% DESCRI��O
% Rotina para o c�lculo do vetor de cargas devido ao peso pr�prio e
% sobrecarga atuante na estrutura
% -------------------------------------------------------------------------
% MODIFICA��ES:         Modificada em 16/05/2015
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: PORTICO, ELEMENTOS, DADOS
% VARI�VEIS DE SA�DA:   esf: esfor�os nodais obtidos � partir do m�todo dos
%                       deslocamentos
%--------------------------------------------------------------------------
% CRIADA EM 14-Janeiro-2015
% -------------------------------------------------------------------------

% 1 - C�LCULO DAS CARGAS ATUANTES
% 1.1 - Vetor contendo os carregamentos distribu�dos - dir Y local
qy=ELEMENTOS.ppy';
CARGA.PPqy=qy;
% 1.2 - Vetor contendo os carregamentos distribu�dos - dir X local
qx=ELEMENTOS.ppx';
CARGA.PPqx=qx;

% 2. ESFOR�OS DE ENGASTAMENTO PERFEITO
% 2.1 - A n�vel de elemento - Referencial local
feq = zeros(6,PORTICO.nelem);
for i=1:PORTICO.nelem
    f=[-qx(i)*PORTICO.comp(i)/2 -qy(i)*PORTICO.comp(i)/2 -qy(i)*PORTICO.comp(i)^2/12 -qx(i)*PORTICO.comp(i)/2 -qy(i)*PORTICO.comp(i)/2 qy(i)*PORTICO.comp(i)^2/12];
    feq(:,i)=f;
end
fepp=feq;   %<-- Devido apenas ao peso pr�prio da estrutura
% 2.2 - A n�vel de elemento - Referencial global
Fe=zeros(6,PORTICO.nelem);
for i=1:PORTICO.nelem
    Fe(:,i)=-ROT(:,:,i)*fepp(:,i);
end
% 2.2 - A n�vel de estrutura - Referencial global
Feq=zeros(1,ngl);
for i=1:PORTICO.nelem
    for j=1:6
        k=gdle(i,j);
        if k>0
            Feq(k)=Feq(k)+Fe(j,i);
        end
    end
end

Fpp=Feq;