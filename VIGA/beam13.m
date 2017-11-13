%FAB - Remoção de variável sem uso (VIGA)
function [VIGAresult]=beam13(~, VIGAin, VIGAresult, NUMVIGAS)
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
% Rotina para calcular o peso da armadura de pele
% -------------------------------------------------------------------------
% MODIFICAÇÕES:         
%--------------------------------------------------------------------------
% VARIÁVEIS DE ENTRADA: VIGA, VIGAin, VIGAresult
% VARIÁVEIS DE SAÍDA:   VIGAresult
%--------------------------------------------------------------------------
% CRIADA EM 01-fevereiro-2016
% -------------------------------------------------------------------------

% Comprimento de uma única barra da armadura de pele
L=VIGAin.COMPRIMENTO(NUMVIGAS); 

% Área de aço da armadura de pele em cada face da viga
Aspele=0.1/100*VIGAin.b*VIGAin.h;

% Criação de vetores nulos para otimização do tempo de processamento
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
L=2*nbarras*L; % <-- Cálculo do comprimento de todas as barras juntas
vol=L*Abarra;


% for i=1:VIGAin.qntbitolaslong
%     Abarra=pi*(VIGA.TABELALONG(i)/1000)^2/4;
%     nbarras(i)=ceil(Aspele/Abarra); % ,-- Qnt de barras em uma face
%     esp=VIGAin.h/(nbarras(i)-1);
%     if esp<0.2 && esp<0.9*VIGAin.h/3 % <-- Considerou-se d=0.9*h, para efeito de simplicidade dos cálculos
%         nbarras(i)=ceil(VIGAin.h/(min(0.2,0.9*VIGAin.h/3)))+1;
%     else
%         nbarras(i)=999; % Foi utilizado um número grande quando o espaçamento não atender os requisitos de norma
%     end
%     L(i)=2*nbarras(i)*L(i); % <-- Cálculo do comprimento de todas as barras juntas
%     vol(i)=L(i)*Abarra;
% end

% A multiplicação por cem serve para transormar a unidade de kN (unidade
% utilizada no arquivos de input) para kgf, unidade mais fácil de assimilar
% como output.
PESO=vol*VIGAin.roaco*100;
VIGAresult.PESOpele(NUMVIGAS)=min(PESO);
