function [tagELU]=column5(PILARout, tagELU)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIÊNCIAS
% PROGRAMA DE PÓS-GRADUAÇÃO EM ENGENHARIA CIVIL        - ÁREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELEÇÃO DE  MÉDIA FIDELIDADE  PARA  ANÁLISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO.
% ALUNO       Sérgio José Priori Jovino Marques Filho
% ORIENTADOR  Prof. Ézio da Rocha Araújo
% -------------------------------------------------------------------------
% DESCRIÇÃO
% Rotina para dcálculo dos esforços resitentes da seção de concreto armado
% -------------------------------------------------------------------------
% MODIFICAÇÕES:         
%--------------------------------------------------------------------------
% VARIÁVEIS DE ENTRADA: --
% VARIÁVEIS DE SAÍDA:   PILARin: "structure" contendo as variáveis necessá-
% rias ao algoritmo de detalhamento do pilar - column.m 
%--------------------------------------------------------------------------
% CRIADA EM 21-fevereiro-2016
% -------------------------------------------------------------------------

x=PILARout.Md;

% RETA R1 - pontos (Mn(1);Pn(1)) e (Mn(2);Pn(2))
ya=PILARout.Pn(1);
yb=PILARout.Pn(2);
xa=PILARout.Mn(1);
xb=PILARout.Mn(2);
a1=(ya-yb)/(xa-xb);
b1=ya-a1*xa;
y1=a1*x+b1;

% RETA R2 - pontos (Mn(2);Pn(2)) e (Mn(3);Pn(3))
ya=PILARout.Pn(2);
yb=PILARout.Pn(3);
xa=PILARout.Mn(2);
xb=PILARout.Mn(3);
a2=(ya-yb)/(xa-xb);
b2=ya-a1*xa;
y2=a2*x+b2;

% RETA R3 - pontos (Mn(3);Pn(3)) e (Mn(4);Pn(4))
ya=PILARout.Pn(3);
yb=PILARout.Pn(4);
xa=PILARout.Mn(3);
xb=PILARout.Mn(4);
a3=(ya-yb)/(xa-xb);
b3=ya-a3*xa;
y3=a3*x+b3;

% RETA R4 - pontos (Mn(4);Pn(4)) e (Mn(5);Pn(5))
ya=PILARout.Pn(4);
yb=PILARout.Pn(5);
xa=PILARout.Mn(4);
xb=PILARout.Mn(5);
a4=(ya-yb)/(xa-xb);
b4=ya-a4*xa;
y4=a4*x+b4;

if PILARout.Nmax<y1 && PILARout.Nmax<y2 && PILARout.Nmax>y3 && PILARout.Nmax>y4
    tagELU=1;
end