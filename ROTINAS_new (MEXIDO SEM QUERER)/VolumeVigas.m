function VolumeVigas
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
% Soma dos volumes de concreto de todas as vigas
% % -----------------------------------------------------------------------
% Criada      03-janeiro-2012              NILMA ANDRADE
% Modificada 
% -------------------------------------------------------------------------

global VC_V SVC_V;
global m;

%VIGAS
%SVC_V(m): Soma dos volumes de concreto de todas as vigas (m3) (escalar)
SVC_V(m)=sum(VC_V);
    


