
function FormaPilares
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
% Soma das áreas de forma de todas as vigas
% % -----------------------------------------------------------------------
% Criada      03-janeiro-2012              NILMA ANDRADE
% Modificada 
% -------------------------------------------------------------------------

global Forma_P SForma_P;
global m;

%PILARES
%SForma_P(m): Soma das áreas de forma de todos os pilares (m2) (escalar)
SForma_P(m)=sum(Forma_P);
    


