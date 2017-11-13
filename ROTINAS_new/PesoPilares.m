function PesoPilares
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIENCIAS
% PROGRAMA DE POS-GRADUACAO EM ENGENHARIA CIVIL        - AREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELECAO DE  MEDIA FIDELIDADE  PARA  ANALISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO
% ALUNA       Nilma Andrade
% ORIENTADOR  Prof. Ezio da Rocha Araujo
% -------------------------------------------------------------------------
% DESCRICAO
% Soma dos pesos de aço de todos os pilares
% % -----------------------------------------------------------------------
% Criada      30-Novembro-2011              NILMA ANDRADE
% Modificada 
% -------------------------------------------------------------------------

global PA_P SPA_P;
global m;

%PILARES
%SPA_P(m): Soma dos pesos de aço de todos os pilares para fck(m)
SPA_P(m)=sum(PA_P);



    


