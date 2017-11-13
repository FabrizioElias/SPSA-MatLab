function [ESTACA]=pileMr(ESTACA, PAR, DADOS)
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
% Rotina para determina��o momemnto fletor resistente. � dispensada a
% verifica��o � flambagem, uma vez que o perfil estar� enterrado.
% verifica��o � flamb
% -------------------------------------------------------------------------
% MODIFICA��ES:         
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: --
% VARI�VEIS DE SA�DA:   PILARin: "structure" contendo as vari�veis necess�-
% rias ao algoritmo de detalhamento do pilar - column.m 
%--------------------------------------------------------------------------
% CRIADA EM 01-agosto-2017
% -------------------------------------------------------------------------

% CLASSIFICA��O DO PERFIL QUANTO A ESBELTEZ
% Ser�o atribu�dos valores para cada classe de se��o a fim de facilitar a
% classifica��o da viga como um todo. Estou sem saco de explicar melhor,
% pesquise se n�o tiver entendido!!!!
% 1 - Se��o compactada
% 2 - Se��o semi-compacta
% 3 - Se��o esbelta

% % Mesa
% lambdab=DADOS.bf/(2*DADOS.tf);
% lambdap=0.38*(PAR.STEEL.Es.parest1/PAR.STEEL.RESTRAC.parest1)^0.5;
% lambdar=0.83*(PAR.STEEL.Es.parest1/(0.7*PAR.STEEL.RESTRAC.parest1))^0.5;
% if lambdab<=lambdap
%     classemesa=1;
% elseif lambdab>lambdap && lambdab<=lambdar
%     classemesa=2;
% else
%     classemesa=3;
% end
% % Alma
% % Mesa
% hw=DADOS.hest-2*DADOS.tf;
% lambdab=hw/DADOS.tw;
% lambdap=3.76*(PAR.STEEL.Es.parest1/PAR.STEEL.RESTRAC.parest1)^0.5;
% lambdar=5.7*(PAR.STEEL.Es.parest1/PAR.STEEL.RESTRAC.parest1)^0.5;
% if lambdab<=lambdap
%     classealma=1
% elseif lambdab>lambdap && lambdab<=lambdar
%     classealma=2
% else
%     classealma=3
% end
% % Viga
% classeviga=max(classemesa,classealma);

% C�LCULO DOS MOMENTOS FLETORES
ESTACA.Mr=zeros(1,DADOS.NMC);
% Momento de plastifica��o
A1=DADOS.bf*DADOS.tf/2;
y1=DADOS.bf/4;
A2=(DADOS.hest-2*DADOS.tf)*DADOS.tw/2;
y2=DADOS.tw/4;
ycg=(2*A1*y1+A2*y2)/(2*A1*A2);
Z=2*(A1+A2)*ycg;
% Foi considerado o momento resistente igual ao momento de plastifica��o
% uma vez que o perfil cravado n�o sofre flambagem.
ESTACA.Mr=Z*PAR.STEEL.fyV;
% % Momento cr�tico
% W=ELEMENTOS.I(ESTRUTURAL.D(1,1))*(DADOS.bf/2);
% Mcr=W*PAR.STEEL.RESTRAC.parest1;
% Mcr=(ELEMENTOS.I(ESTRUTURAL.D(1,1))/(DADOS.hest/2))*fcr