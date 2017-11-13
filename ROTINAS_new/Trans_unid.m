function Trans_unid
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIENCIAS
% PROGRAMA DE POS-GRADUA�AO EM ENGENHARIA CIVIL        - AREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELECAO DE  MEDIA FIDELIDADE  PARA  ANALISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO.
% ALUNA       Nilma Andrade
% ORIENTADOR  Prof. �zio da Rocha Araujo
% -------------------------------------------------------------------------
% DESCRICAO
% Faz transforma��o de unidades
% -------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA
% tetarad betarad teta beta CPespessura
% VARI�VEIS DE SA�DA
% tetarad betarad teta beta CPespessura
% -------------------------------------------------------------------------
% Criada      04-Agosto-2011              NILMA ANDRADE
% Modificada 
% -------------------------------------------------------------------------
% 1-DEFINICAO DAS VARI�VEIS GLOBAIS
global tetarad betarad teta beta CPespessura;

tetarad=pi*teta/180;        %Transforma��o de graus para radianos
betarad=pi*beta/180;        %Transforma��o de graus para radianos
CPespessura=CPespessura/100;%Transforma��o de cm para m

%teta                       �ngulo de inclina��o das fissuras
%beta                       �ngulo de inclina��o dos estribos
%CPespessura                Espessura do contrapiso




