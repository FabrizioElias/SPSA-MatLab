function [ESTACA]=pileNr(ESTRUTURAL, ELEMENTOS, PAR, DADOS)
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
% Rotina para determinação esforço norMal resistente. É dispensada a
% verificação à flambagem uma vez que o perfil estará enterrado.
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

% Valor de QSI calculado no MATHCAD e inserido diretamente. Arrumar isso
% depois
qsi=0.973;
% Valor de Q (Q=Qa*Qs) iserido diretamente, arrumar isso depois,
% automatizando.
Q=1;
ESTACA.Nr=zeros(1,DADOS.NMC);
ESTACA.Nr=Q*qsi*ELEMENTOS.A(ESTRUTURAL.D(1,1))*PAR.STEEL.fyV;

