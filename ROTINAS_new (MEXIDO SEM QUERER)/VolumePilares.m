function VolumePilares
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
% Soma dos volumes de concreto de todos os pilares
% % -----------------------------------------------------------------------
% Criada      03-janeiro-2012              NILMA ANDRADE
% Modificada 
% -------------------------------------------------------------------------

global VC_P SVC_P;
global m;

%PILARES
%SVC_P(m): Soma dos volumes de concreto de todos os pilares (m3) (escalar)
SVC_P(m)=sum(VC_P);
    


