function [PILAR]=column5adim(PILAR, DADOS, i, j)
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
% Rotina para dcálculo dos esforços resitentes da seção de concreto armado,
% considerando os esforços adimensionais
% -------------------------------------------------------------------------
% MODIFICAÇÕES:         
%--------------------------------------------------------------------------
% VARIÁVEIS DE ENTRADA: --
% VARIÁVEIS DE SAÍDA:   PILARin: "structure" contendo as variáveis necessá-
% rias ao algoritmo de detalhamento do pilar - column.m 
%--------------------------------------------------------------------------
% CRIADA EM 01-agosto-2016
% -------------------------------------------------------------------------

%-------------------------------------------------------------------------%
% PERCEBE-SE QUE O CÁLCULO DOS PONTOS DO DIAGRAMA DE ITERAÇÃO SÓ PRECISA
% SER FEITO UMA ÚNICA VEZ, OU SEJA, ELE PODE SAIR DE DENTRO DO LOOP i=1:12.
% ISSO DEVE SER ARRUMADO DEPOIS QUE ACABAR A TESE!!!!!!!!!!!!!!!!!!!!!!!!!!
%-------------------------------------------------------------------------%

x=PILAR.MId;
% RETA R1 - pontos (Mn(1);Pn(1)) e (Mn(2);Pn(2))
ya=PILAR.NIn(1);
yb=PILAR.NIn(2);
xa=PILAR.MIn(1);
xb=PILAR.MIn(2);
a1=(ya-yb)/(xa-xb);
b1=ya-a1*xa;
y1=a1*x+b1;

% RETA R2 - pontos (Mn(2);Pn(2)) e (Mn(3);Pn(3))
ya=PILAR.NIn(2);
yb=PILAR.NIn(3);
xa=PILAR.MIn(2);
xb=PILAR.MIn(3);
a2=(ya-yb)/(xa-xb);
b2=ya-a2*xa;
y2=a2*x+b2;

% RETA R3 - pontos (Mn(3);Pn(3)) e (Mn(4);Pn(4))
ya=PILAR.NIn(3);
yb=PILAR.NIn(4);
xa=PILAR.MIn(3);
xb=PILAR.MIn(4);
a3=(ya-yb)/(xa-xb);
b3=ya-a3*xa;
y3=a3*x+b3;

% RETA R4 - pontos (Mn(4);Pn(4)) e (Mn(5);Pn(5))
ya=PILAR.NIn(4);
yb=PILAR.NIn(5);
xa=PILAR.MIn(4);
xb=PILAR.MIn(5);
a4=(ya-yb)/(xa-xb);
b4=ya-a4*xa;
y4=a4*x+b4;

if PILAR.NId<y1 && PILAR.NId<y2 && PILAR.NId>y3 && PILAR.NId>y4
    % As condições indicadas no "if" acima, se satisfeitas, indicam que a
    % que a seção não sofre ruptura. tagELU=1 -> seção rompe
    PILAR.tagELU(i,j)=0;
    disp('OK')
else
    PILAR.tagELU(i,j)=1;
    disp('FALHA')
end

% CÁLCULO DAS DISTÂNCIAS ENTRE OS PONTOS DO DIAGRAMA DE ITERAÇÃO E OS
% PONTOS CORRESPONDENTES AOS ESFORÇOS SOLICITANTES.
% Reta 1
d=zeros(4,100);
for k=1:4
    X=PILAR.MId;
    Y=PILAR.NId;
    x0=PILAR.MIn(k);
    xf=PILAR.MIn(k+1);
    x=linspace(x0,xf,100);
    y0=PILAR.NIn(k);
    yf=PILAR.NIn(k+1);
    y=linspace(y0,yf,100);
    for kk=1:100
        d(k,kk)=((X-x(kk))^2+(Y-y(kk))^2)^(1/2);
    end
end
PILAR.d(i,j)=min(min(d));
if PILAR.tagELU(i,j)==1
    PILAR.d(i,j)=-PILAR.d(i,j);
end

    


    