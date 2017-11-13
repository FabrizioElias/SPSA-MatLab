function Trans_unid
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIENCIAS
% PROGRAMA DE POS-GRADUAÇAO EM ENGENHARIA CIVIL        - AREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELECAO DE  MEDIA FIDELIDADE  PARA  ANALISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO.
% ALUNA       Nilma Andrade
% ORIENTADOR  Prof. Ézio da Rocha Araujo
% -------------------------------------------------------------------------
% DESCRICAO
% Faz transformação de unidades
% -------------------------------------------------------------------------
% VARIÁVEIS DE ENTRADA
% tetarad betarad teta beta CPespessura
% VARIÁVEIS DE SAÍDA
% tetarad betarad teta beta CPespessura
% -------------------------------------------------------------------------
% Criada      04-Agosto-2011              NILMA ANDRADE
% Modificada 
% -------------------------------------------------------------------------
% 1-DEFINICAO DAS VARIÁVEIS GLOBAIS
global tetarad betarad teta beta CPespessura;

tetarad=pi*teta/180;        %Transformação de graus para radianos
betarad=pi*beta/180;        %Transformação de graus para radianos
CPespessura=CPespessura/100;%Transformação de cm para m

%teta                       Ângulo de inclinação das fissuras
%beta                       Ângulo de inclinação dos estribos
%CPespessura                Espessura do contrapiso




