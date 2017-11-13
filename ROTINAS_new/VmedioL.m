function VmedioV
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
% Calculo do volume de concreto por elemento estrutural.
% % -----------------------------------------------------------------------
% Criada      03-janeiro-2012              NILMA ANDRADE
% Modificada 
% -------------------------------------------------------------------------

global op_est;
global VC_V;
global SVC_V;

%VIGAS
%SVC_V: Soma dos volumes de concreto de todas as vigas (m3)
SVC_V=sum(VC_V);
    


