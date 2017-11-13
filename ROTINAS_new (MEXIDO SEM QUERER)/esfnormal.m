function [N]=esfnormal(PORTICO, ELEMENTOS, KEST, KELEM, ROT, Fsc, fesc, Fpp, fepp, gdle, CARGA)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIÊNCIAS
% PROGRAMA DE PÓS-GRADUAÇÃO EM ENGENHARIA CIVIL        - ÁREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELEÇÃO DE  MÉDIA FIDELIDADE  PARA  ANÁLISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO.
% ALUNA       Sérgio José Priori Jovino Marques Filho
% ORIENTADOR  Prof. Ézio da Rocha Araújo
% -------------------------------------------------------------------------
% DESCRIÇÃO
% Rotina para cálculo do esforço normal nos elementos estruturais
% -------------------------------------------------------------------------
% MODIFICAÇÕES:         Modificada em 16/05/2015
%--------------------------------------------------------------------------
% VARIÁVEIS DE ENTRADA: PORTICO, ELEMENTOS, DADOS
% VARIÁVEIS DE SAÍDA:   esf: esforços nodais obtidos à partir do método dos
%                       deslocamentos
%                       CORTANTE, MOMENTO: esforços internos nos elementos
%                       do pórtico.
%--------------------------------------------------------------------------
% CRIADA EM 13-Janeiro-2015
% -------------------------------------------------------------------------

F=Fsc+Fpp;
fe=fesc+fepp;

% Resolve o sistema de equações
[esf]=solver2(KEST, F, fe, PORTICO, gdle, KELEM, ROT);
% Calcula o esforço axial nas barras
N=axial2(PORTICO, ELEMENTOS, esf,CARGA);