function [A, I]=areauniform(HH, i, PAR)
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
% Função irá calcular a áea de aço uniformizada
% -------------------------------------------------------------------------
% Criada      23-maio-2016                 SÉRGIO MARQUES
% -------------------------------------------------------------------------

% Dimensões da estaca circular de aço
Dext=HH(5*(i-1)+2);
esp=HH(5*(i-1)+3);
Dint=Dext-2*esp;

% Nova área de aço - Considera que toda a seção transversal é composta por
% aço
n=PAR.CONC.Ecs.parest1/PAR.STEEL.Es.parest1;
Aconc=pi*Dint^2/4;
Aaco=pi*Dext^2/4-pi*Dint^2/4;
A=n*Aconc+Aaco;
% Novo momento de inércia - Considera que toda a seção transversal é
% composta por aço
Iaco=pi*(Dext/2)^4/4-pi*(Dint/2)^4/4;
Iconc=pi*(Dint/2)^4/4;
I=n*Iconc+Iaco;
