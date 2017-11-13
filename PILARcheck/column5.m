function [PILAR]=column5(PILAR, DADOS, i, j)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCI�NCIAS
% PROGRAMA DE P�S-GRADUA��O EM ENGENHARIA CIVIL        - �REA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELE��O DE  M�DIA FIDELIDADE  PARA  AN�LISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO.
% ALUNO       S�rgio Jos� Priori Jovino Marques Filho
% ORIENTADOR  Prof. �zio da Rocha Ara�jo
% -------------------------------------------------------------------------
% DESCRI��O
% Rotina para dc�lculo dos esfor�os resitentes da se��o de concreto armado
% -------------------------------------------------------------------------
% MODIFICA��ES:         
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: --
% VARI�VEIS DE SA�DA:   PILARin: "structure" contendo as vari�veis necess�-
% rias ao algoritmo de detalhamento do pilar - column.m 
%--------------------------------------------------------------------------
% CRIADA EM 21-fevereiro-2016
% -------------------------------------------------------------------------

%-------------------------------------------------------------------------%
% PERCEBE-SE QUE O C�LCULO DOS PONTOS DO DIAGRAMA DE ITERA��O S� PRECISA
% SER FEITO UMA �NICA VEZ, OU SEJA, ELE PODE SAIR DE DENTRO DO LOOP i=1:12.
% ISSO DEVE SER ARRUMADO DEPOIS QUE ACABAR A TESE!!!!!!!!!!!!!!!!!!!!!!!!!!
%-------------------------------------------------------------------------%

x=PILAR.Md;
% RETA R1 - pontos (Mn(1);Pn(1)) e (Mn(2);Pn(2))
ya=PILAR.Pn(1);
yb=PILAR.Pn(2);
xa=PILAR.Mn(1);
xb=PILAR.Mn(2);
a1=(ya-yb)/(xa-xb);
b1=ya-a1*xa;
y1=a1*x+b1;

% RETA R2 - pontos (Mn(2);Pn(2)) e (Mn(3);Pn(3))
ya=PILAR.Pn(2);
yb=PILAR.Pn(3);
xa=PILAR.Mn(2);
xb=PILAR.Mn(3);
a2=(ya-yb)/(xa-xb);
b2=ya-a2*xa;
y2=a2*x+b2;

% RETA R3 - pontos (Mn(3);Pn(3)) e (Mn(4);Pn(4))
ya=PILAR.Pn(3);
yb=PILAR.Pn(4);
xa=PILAR.Mn(3);
xb=PILAR.Mn(4);
a3=(ya-yb)/(xa-xb);
b3=ya-a3*xa;
y3=a3*x+b3;

% RETA R4 - pontos (Mn(4);Pn(4)) e (Mn(5);Pn(5))
ya=PILAR.Pn(4);
yb=PILAR.Pn(5);
xa=PILAR.Mn(4);
xb=PILAR.Mn(5);
a4=(ya-yb)/(xa-xb);
b4=ya-a4*xa;
y4=a4*x+b4;

if PILAR.Nd<y1 && PILAR.Nd<y2 && PILAR.Nd>y3 && PILAR.Nd>y4
    % As condi��es indicadas no "if" acima, se satisfeitas, indicam que a
    % que a se��o n�o sofre ruptura. tagELU=1 -> se��o rompe
    PILAR.tagELU(i,j)=0;
    disp('OK')
else
    PILAR.tagELU(i,j)=1;
    disp('FALHA')
end


if PILAR.Nd<=PILAR.Pn(1) & PILAR.Nd>PILAR.Pn(2)
    Pr=PILAR.Nd;
    Mr=(Pr-b1)/a1;
elseif PILAR.Nd<=PILAR.Pn(2) & PILAR.Nd>PILAR.Pn(3)
    Pr=PILAR.Nd;
    Mr=(Pr-b2)/a2;
elseif PILAR.Nd<=PILAR.Pn(3) & PILAR.Nd>PILAR.Pn(4)
    Pr=PILAR.Nd;
    Mr=(Pr-b3)/a3;
elseif PILAR.Nd<=PILAR.Pn(4) & PILAR.Nd>PILAR.Pn(5)
    Pr=PILAR.Nd;
    Mr=(Pr-b4)/a4;
else
    disp('Esfor�o normal fora do dom�nio')
end
PILAR.DELTAM(i,j)=Mr-abs(PILAR.Md);
    