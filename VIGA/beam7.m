function [VIGAresult, VIGAout]=beam7(trecho, PESO, COMP, lbnecRe, NUMVIGAS, VIGAresult)
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
% Rotina para determinar a bitola que fornecerá o menor peso de aço para
% armadura negativa em cada trecho
% -------------------------------------------------------------------------
% MODIFICAÇÕES:         
%--------------------------------------------------------------------------
% VARIÁVEIS DE ENTRADA: VIGAout
% VARIÁVEIS DE SAÍDA:   VIGAout: structure contendo os dados de saída da
% viga
%--------------------------------------------------------------------------
% CRIADA EM 26-janeiro-2016
% -------------------------------------------------------------------------

global m

% peso=min(PESO);
% menorbitolaneg=find(PESO==peso);

% Peso de aço da armadura negativa
VIGAresult.PESOneg(NUMVIGAS, trecho, m)=PESO; 

% Comprimento da maior barra do arranjo, necessário p calcular a armadura
% de montagem
comp= max(COMP);
VIGAout.COMPneg(trecho)=comp;
VIGAout.lbnecReneg(trecho)=lbnecRe(menorbitolaneg);
