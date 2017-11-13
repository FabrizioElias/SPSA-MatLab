%FAB - Remo��o de vari�vel sem uso (VIGA)
function [VIGAresult]=beam13(~, VIGAin, VIGAresult, NUMVIGAS)
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
% Rotina para calcular o peso da armadura de pele
% -------------------------------------------------------------------------
% MODIFICA��ES:         
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: VIGA, VIGAin, VIGAresult
% VARI�VEIS DE SA�DA:   VIGAresult
%--------------------------------------------------------------------------
% CRIADA EM 01-fevereiro-2016
% -------------------------------------------------------------------------

% Comprimento de uma �nica barra da armadura de pele
L=VIGAin.COMPRIMENTO(NUMVIGAS); 

% �rea de a�o da armadura de pele em cada face da viga
Aspele=0.1/100*VIGAin.b*VIGAin.h;

% Cria��o de vetores nulos para otimiza��o do tempo de processamento
% nbarras=zeros(1,VIGAin.qntbitolaslong);
% vol=zeros(1,VIGAin.qntbitolaslong);

Abarra=pi*(5.0/1000)^2/4;
nbarras=ceil(Aspele/Abarra); % ,-- Qnt de barras em uma face
esp=VIGAin.h/(nbarras-1);
nbarras=ceil(VIGAin.h/(min(0.2,0.9*VIGAin.h/3)))+1;

while esp>0.2 && esp>0.9*VIGAin.h/3
    nbarras=nbarras+1;
    esp=VIGAin.h/(nbarras-1);
end
L=2*nbarras*L; % <-- C�lculo do comprimento de todas as barras juntas
vol=L*Abarra;


% for i=1:VIGAin.qntbitolaslong
%     Abarra=pi*(VIGA.TABELALONG(i)/1000)^2/4;
%     nbarras(i)=ceil(Aspele/Abarra); % ,-- Qnt de barras em uma face
%     esp=VIGAin.h/(nbarras(i)-1);
%     if esp<0.2 && esp<0.9*VIGAin.h/3 % <-- Considerou-se d=0.9*h, para efeito de simplicidade dos c�lculos
%         nbarras(i)=ceil(VIGAin.h/(min(0.2,0.9*VIGAin.h/3)))+1;
%     else
%         nbarras(i)=999; % Foi utilizado um n�mero grande quando o espa�amento n�o atender os requisitos de norma
%     end
%     L(i)=2*nbarras(i)*L(i); % <-- C�lculo do comprimento de todas as barras juntas
%     vol(i)=L(i)*Abarra;
% end

% A multiplica��o por cem serve para transormar a unidade de kN (unidade
% utilizada no arquivos de input) para kgf, unidade mais f�cil de assimilar
% como output.
PESO=vol*VIGAin.roaco*100;
VIGAresult.PESOpele(NUMVIGAS)=min(PESO);
