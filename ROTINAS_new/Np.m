function np = Np
% NP: CALCULO DO OLEO PRODUZIDO ACUMULADO
% --------------------------------------------------------------------------
% np = NP
%
% np    -  Oleo produzido acumulad                                     (out)
% --------------------------------------------------------------------------
% -------------------------------------------------------------------------
% OTIMIZACAO DINAMICA DAS VAZOES DE PRODUCAO E INJECAO EM POCOS DE PETROLEO
% -------------------------------------------------------------------------
% Universidade Federal de Pernambuco
% Programa de Pos-Graduaçao Engenharia Civil / Estruturas
%
% Petrobras
% Centro de Pesquisas - CENPES
% 
% --------------------------------------------------------------------------
% Criado:        27-Jan-2006      Diego Oliveira
%
% Moficaçao:     
%                
% --------------------------------------------------------------------------

global Oleo_Produzido_Ac;

%Producoes Acumuladas
op_ac = Oleo_Produzido_Ac;

n=length(op_ac);

np=op_ac(n);

disp(['Np= ',num2str(np)])