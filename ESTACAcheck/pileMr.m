function [ESTACA]=pileMr(ESTACA, PAR, DADOS)
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
% Rotina para determinação momemnto fletor resistente. É dispensada a
% verificação à flambagem, uma vez que o perfil estará enterrado.
% verificação à flamb
% -------------------------------------------------------------------------
% MODIFICAÇÕES:         
%--------------------------------------------------------------------------
% VARIÁVEIS DE ENTRADA: --
% VARIÁVEIS DE SAÍDA:   PILARin: "structure" contendo as variáveis necessá-
% rias ao algoritmo de detalhamento do pilar - column.m 
%--------------------------------------------------------------------------
% CRIADA EM 01-agosto-2017
% -------------------------------------------------------------------------

% CLASSIFICAÇÃO DO PERFIL QUANTO A ESBELTEZ
% Serão atribuídos valores para cada classe de seção a fim de facilitar a
% classificação da viga como um todo. Estou sem saco de explicar melhor,
% pesquise se não tiver entendido!!!!
% 1 - Seção compactada
% 2 - Seção semi-compacta
% 3 - Seção esbelta

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

% CÁLCULO DOS MOMENTOS FLETORES
ESTACA.Mr=zeros(1,DADOS.NMC);
% Momento de plastificação
A1=DADOS.bf*DADOS.tf/2;
y1=DADOS.bf/4;
A2=(DADOS.hest-2*DADOS.tf)*DADOS.tw/2;
y2=DADOS.tw/4;
ycg=(2*A1*y1+A2*y2)/(2*A1*A2);
Z=2*(A1+A2)*ycg;
% Foi considerado o momento resistente igual ao momento de plastificação
% uma vez que o perfil cravado não sofre flambagem.
ESTACA.Mr=Z*PAR.STEEL.fyV;
% % Momento crítico
% W=ELEMENTOS.I(ESTRUTURAL.D(1,1))*(DADOS.bf/2);
% Mcr=W*PAR.STEEL.RESTRAC.parest1;
% Mcr=(ELEMENTOS.I(ESTRUTURAL.D(1,1))/(DADOS.hest/2))*fcr