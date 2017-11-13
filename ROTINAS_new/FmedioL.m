function FmedioV
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
% Calculo da área de forma por elemento estrutural.
% % -----------------------------------------------------------------------
% Criada      03-janeiro-2012              NILMA ANDRADE
% Modificada 
% -------------------------------------------------------------------------

global op_est;
global Forma_V;
global SForma_V;

%VIGAS
%SForma_V: Soma das áreas de forma de todas as vigas (m2)
SForma_V=sum(Forma_V);
    


