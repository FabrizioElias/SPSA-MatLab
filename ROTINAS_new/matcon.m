function [A b] = matcon
% MATCON: Monta matriz das constraints.
% --------------------------------------------------------------------------
% [A b] = matcon
%
% A        -  Matriz                                                   (out)
% b        -  Vetor                                                    (out)
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
% Criado:        16-Mai-2006      Diego Oliveira
%
% Moficaçao:
% --------------------------------------------------------------------------
% Definicoes
% Opcoes
global op_PI;
% Dados e Controladores
global NPar;
global NWell_P;
global NWell_I;
global Ntempos;
global facmaxP facmaxI;
global op_otim;

if op_otim==2
    A=[];
    b=[];
    return
end
Ap =[ 1  1  1  1  1  1;...
      -1 -1 -1 -1 -1 -1];
Ai =[ 1  1  1  1;...
      -1 -1 -1 -1];
Api=[ 1  1  1  1  1  1  0  0  0  0;...
     -1 -1 -1 -1 -1 -1  0  0  0  0;...
      0  0  0  0  0  0  1  1  1  1;...
      0  0  0  0  0  0 -1 -1 -1 -1];
bp =[ 100; facmaxP-100];
bi =[ 100; facmaxI-100];
bpi=[ 100; facmaxP-100; 100; facmaxI-100];

A=zeros(Ntempos,NPar);
b=zeros(Ntempos,1);
switch op_PI
    case 1
        for jj=1:Ntempos
            rowi=2*jj-1;
            rowf=rowi+1;
            coli=1+(jj-1)*(NWell_P-1);
            colf=coli+(NWell_P-2);
            A(rowi:rowf,coli:colf)= Ap;
            b(rowi:rowf)          = bp;
        end
    case 2
        for jj=1:Ntempos
            rowi=2*jj-1;
            rowf=rowi+1;
            coli=1+(jj-1)*(NWell_I-1);
            colf=coli+(NWell_I-2);
            A(rowi:rowf,coli:colf)= Ai;
            b(rowi:rowf)          = bi;
        end
    case 3
        for jj=1:Ntempos
            rowi=4*jj-3;
            rowf=rowi+3;
            coli=1+(jj-1)*(NWell_P+NWell_I-2);
            colf=coli+(NWell_P+NWell_I-3);
            A(rowi:rowf,coli:colf)= Api;
            b(rowi:rowf)          = bpi;
        end
end
