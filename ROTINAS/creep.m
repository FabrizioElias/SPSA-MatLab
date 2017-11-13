function [epsoncc, deltacc]=creep(PAR, PORTICO, ELEMENTOS, VIGA, N)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIENCIAS
% PROGRAMA DE POS-GRADUACAO EM ENGENHARIA CIVIL        - AREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELECAO DE  MEDIA FIDELIDADE  PARA  ANALISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO
% ALUNA       Sérgio José Priori Jovino Marques Filho
% ORIENTADOR  Prof. Ezio da Rocha Araujo
% -------------------------------------------------------------------------
% DESCRICAO
% Cálculo da deformação específica de fluência.
% -------------------------------------------------------------------------
% Criada      21-dezembro-2016                 SÉRGIO MARQUES
% -------------------------------------------------------------------------

global m

s=size(VIGA.elemento);
epsoncc=zeros(1,s(2));
deltacc=zeros(1,s(2));
for i=1:s(2)
    % Cálculo da área da seção da viga "i"
    A=ELEMENTOS.A(VIGA.elemento(i));
    % Esforço normal atuante na viga
    normal=min(N(VIGA.elemento(i),:));
    % Tensão normal de compressão atuante na viga
    sigma=normal/A;
    % Cálculo da deformação específica de fluência
    epsoncc(i)=sigma/PAR.CONC.Ecs.parest1*PAR.CONC.phi(i,m);
    % Cálculo da deformação absoluta dde fluência
    L=PORTICO.comp(VIGA.elemento(i));
    deltacc(i)=epsoncc(i)*L;
end