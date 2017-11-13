function [PILAR]=column5(PILAR, DADOS, i, j)
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

%-------------------------------------------------------------------------%
% PERCEBE-SE QUE O CÁLCULO DOS PONTOS DO DIAGRAMA DE ITERAÇÃO SÓ PRECISA
% SER FEITO UMA ÚNICA VEZ, OU SEJA, ELE PODE SAIR DE DENTRO DO LOOP i=1:12.
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
    % As condições indicadas no "if" acima, se satisfeitas, indicam que a
    % que a seção não sofre ruptura. tagELU=1 -> seção rompe
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
    disp('Esforço normal fora do domínio')
end
PILAR.DELTAM(i,j)=Mr-abs(PILAR.Md);
    