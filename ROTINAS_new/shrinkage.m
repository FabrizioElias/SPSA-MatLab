function [deltacs]=shrinkage(PORTICO, VIGA, PAR)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIENCIAS
% PROGRAMA DE POS-GRADUACAO EM ENGENHARIA CIVIL        - AREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELECAO DE  MEDIA FIDELIDADE  PARA  ANALISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO
% ALUNA       S�rgio Jos� Priori Jovino Marques Filho
% ORIENTADOR  Prof. Ezio da Rocha Araujo
% -------------------------------------------------------------------------
% DESCRICAO
% C�lculo da deforma��o espec�fica de flu�ncia.
% -------------------------------------------------------------------------
% Criada      21-dezembro-2016                 S�RGIO MARQUES
% -------------------------------------------------------------------------

global m

s=size(VIGA.elemento);
deltacs=zeros(1,s(2));
% A vari�vel "i" ir� variar de 1 at� o n�mero total de vigas
for i=1:s(2)
    % C�lculo da deforma��o absoluta dde flu�ncia
    L=PORTICO.comp(VIGA.elemento(i));
    %L=25;
    deltacs(i)=PAR.CONC.epsoncsV(i,m)*L;
end