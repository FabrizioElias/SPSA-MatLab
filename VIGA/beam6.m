%FAB - Otimização da assinatura do método, remoção de lbnecVante.
function [VIGAresult, COMPneg]=beam6(VIGAin, ARRANJOLONGsup, trecho, ~, lbnecRe, al, NUMVIGAS, VIGAresult, COMPneg)
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
% Rotina para calcular o peso de aço da armadura negativa
% -------------------------------------------------------------------------
% MODIFICAÇÕES:         
%--------------------------------------------------------------------------
% VARIÁVEIS DE ENTRADA: VIGAout
% VARIÁVEIS DE SAÍDA:   VIGAout: structure contendo os dados de saída da
% viga
%--------------------------------------------------------------------------
% CRIADA EM 07-novembro-2015
% -------------------------------------------------------------------------
global m

% Criação dos vetores nulos
Lbarra=zeros(1,VIGAin.numsecoestrechoneg(trecho));
Q=zeros(1,VIGAin.numsecoestrechoneg(trecho));
COMP=zeros(1,VIGAin.numsecoestrechoneg(trecho));
vol=zeros(1,VIGAin.numsecoestrechoneg(trecho));

% Comprimento das barras entre seções
for i=1:VIGAin.numsecoestrechoneg(trecho)
    Lbarra(i)=i*VIGAin.compelem(1,1);
end

% Área da barra empregada no arranjo
Abarra=pi*(ARRANJOLONGsup(1,2)*10^-3)^2/4;

A=ARRANJOLONGsup;
s=size(A);
s=s(1);
A(s+1)=0;
for j=1:s
    Q(j)=A(j)-A(j+1); %<-- Quantidade de barra entre seções adjacentes
end



for j=1:VIGAin.numsecoestrechoneg(trecho)
    COMP(j)=Lbarra(j)+lbnecRe+8*ARRANJOLONGsup(1,2)/1000+al;
    vol(j)=COMP(j).*Abarra.*Q(j);
end


% Caso as matrizes COMP e vol só tenham uma coluna deve-se utilizar as
% próprias matrizes, por isso foi inserido esse "if" abaixo. A
% multiplicação por cem serve para transormar a unidade de kN (unidade
% utilizada no arquivos de input) para kgf, unidade mais fácil de assimilar
% como output.
if VIGAin.numsecoestrechoneg(trecho)==1
    PESO=vol'.*VIGAin.roaco*100;
else
    %FAB - Remoção da transposição e colocação de instrução para somar cada
    %linha de vol. sum(vol') iria somar as colunas que antes da
    %transposição são as linhas.
    %PESO=sum(vol').*VIGAin.roaco*100;
    PESO=sum(vol, 2).*VIGAin.roaco*100;
end

% Peso de aço da armadura negativa
VIGAresult.PESOneg(NUMVIGAS, trecho, m)=PESO; 

% Maior comprimento da barra da armadura negativa - será utilizado para o
% cálculo da armadura de montagem
COMPneg(trecho)=max(COMP);