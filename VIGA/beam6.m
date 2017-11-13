%FAB - Otimiza��o da assinatura do m�todo, remo��o de lbnecVante.
function [VIGAresult, COMPneg]=beam6(VIGAin, ARRANJOLONGsup, trecho, ~, lbnecRe, al, NUMVIGAS, VIGAresult, COMPneg)
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
% Rotina para calcular o peso de a�o da armadura negativa
% -------------------------------------------------------------------------
% MODIFICA��ES:         
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: VIGAout
% VARI�VEIS DE SA�DA:   VIGAout: structure contendo os dados de sa�da da
% viga
%--------------------------------------------------------------------------
% CRIADA EM 07-novembro-2015
% -------------------------------------------------------------------------
global m

% Cria��o dos vetores nulos
Lbarra=zeros(1,VIGAin.numsecoestrechoneg(trecho));
Q=zeros(1,VIGAin.numsecoestrechoneg(trecho));
COMP=zeros(1,VIGAin.numsecoestrechoneg(trecho));
vol=zeros(1,VIGAin.numsecoestrechoneg(trecho));

% Comprimento das barras entre se��es
for i=1:VIGAin.numsecoestrechoneg(trecho)
    Lbarra(i)=i*VIGAin.compelem(1,1);
end

% �rea da barra empregada no arranjo
Abarra=pi*(ARRANJOLONGsup(1,2)*10^-3)^2/4;

A=ARRANJOLONGsup;
s=size(A);
s=s(1);
A(s+1)=0;
for j=1:s
    Q(j)=A(j)-A(j+1); %<-- Quantidade de barra entre se��es adjacentes
end



for j=1:VIGAin.numsecoestrechoneg(trecho)
    COMP(j)=Lbarra(j)+lbnecRe+8*ARRANJOLONGsup(1,2)/1000+al;
    vol(j)=COMP(j).*Abarra.*Q(j);
end


% Caso as matrizes COMP e vol s� tenham uma coluna deve-se utilizar as
% pr�prias matrizes, por isso foi inserido esse "if" abaixo. A
% multiplica��o por cem serve para transormar a unidade de kN (unidade
% utilizada no arquivos de input) para kgf, unidade mais f�cil de assimilar
% como output.
if VIGAin.numsecoestrechoneg(trecho)==1
    PESO=vol'.*VIGAin.roaco*100;
else
    %FAB - Remo��o da transposi��o e coloca��o de instru��o para somar cada
    %linha de vol. sum(vol') iria somar as colunas que antes da
    %transposi��o s�o as linhas.
    %PESO=sum(vol').*VIGAin.roaco*100;
    PESO=sum(vol, 2).*VIGAin.roaco*100;
end

% Peso de a�o da armadura negativa
VIGAresult.PESOneg(NUMVIGAS, trecho, m)=PESO; 

% Maior comprimento da barra da armadura negativa - ser� utilizado para o
% c�lculo da armadura de montagem
COMPneg(trecho)=max(COMP);