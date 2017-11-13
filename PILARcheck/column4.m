function [PILAR]=column4(PILAR, j)
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

epsonyd=PILAR.fyd(j)/PILAR.Es(j);
epsonCu=0.0035;
d=-(PILAR.ys-PILAR.hv(j)/2);

% PONTO 1 - COMPRESSÃO AXIAL UNIFORME
Rs=0;
% Cálculo da profundidade da LN - a LN encontra-se no infinito

% Cálculo das deformações específicas e tensão nas barras - uma vez que 
% toda a seção encontra-se comprimida com o valor de epson igual ao 
% encurtamento máximo admissível do concreto tem-se que epsonSi=epsonCu. 
% Como na compressão a deformação específica de escoamento do aço é igual 
% ao encurtamento específico do concreto, temos que todo o aço escontra-se 
% plastificado.
fs=PILAR.fyd(j)*ones(1,PILAR.ncam);
% Cálculo da resultante de compressão no concreto
Rc=PILAR.sigmacd(j)*(PILAR.bv(j)*PILAR.hv(j)-PILAR.Astotal); % <-- Descontada a área de aço
% Cálculo da resultante de compressão nas barras
for i=1:PILAR.ncam
    %Rs(i)=fs(i).*PILARin.As(i);
    Rs=Rs+fs(i).*PILAR.As(i);
end
% Esforço normal resistente
PILAR.Pn(1)=Rc+Rs;
PILAR.Mn(1)=0;

% PONTO 2 - INÍCIO DA FISSURAÇÃO DO CONCRETO
Aneg=zeros(1,PILAR.ncam);
epsonS=zeros(1,PILAR.ncam);
fs=zeros(1,PILAR.ncam);
Rs=zeros(1,PILAR.ncam);
% Cálculo da profundidade da LN - a LN encontra-se na base da seção
% transversal de concreto, assim x=h.
x=PILAR.h;
% Aqui será criada uma variavel chamada RsYs, que será a soma da força
% resultante na camada i multiplicada pela coordenada da camada "i". Isso
% foi feito para evitar o comando "sum", vide linha XX comentada que estava
% tomando muito tempo no processamento.
sumRs=0;
RsYs=0;
Aneg=0;
% Cálculo das deformações específicas, tensões e resultates nas barras de
% aço

for i=1:PILAR.ncam
    epsonS(i)=epsonCu*(PILAR.h-d(i))/PILAR.h;
    if epsonS(i)<=-epsonyd
        fs(i)=-PILAR.fyd(j);
    elseif epsonS(i)>=epsonyd
        fs(i)=PILAR.fyd(j);
    else
        fs(i)=epsonS(i)*PILAR.Es(j);
    end
    Rs=fs(i)*PILAR.As(i);
    RsYs=RsYs+Rs*PILAR.ys(i);
    sumRs=sumRs+Rs;
    % A variável Aneg representa uma área negativa que será compuatda caso
    % a camada de barra esteja localizada na zona de compressão do
    % concrento. Essa "área negativa" irá ser somada à área de concreto
    % evitando que a tensão de compressão seja computada duas vezes.
    if d(i)<0.8*x
        Aneg=Aneg-PILAR.As(i);
    end
end
% Cálculo da resultante de compressão no concreto
Rc=0.8*x*PILAR.sigmacd(j)*PILAR.bv(j)+Aneg*PILAR.sigmacd(j);
% Cálculo dos esforços resistentes
PILAR.Pn(2)=Rc+sumRs;
%PILARout.Mn(2)=Rc*(PILARin.h/2-0.8*x/2)+sum(Rs.*PILARout.ys);
PILAR.Mn(2)=Rc*(PILAR.hv(j)/2-0.8*x/2)+RsYs;

% PONTO 3 - CAMADA DE BARRA JUNTO À SEÇÃO MENOS COMPRIMIDA DO CONCRETO
% INICIA A PLASTIFICAÇÃO - epsonS(1)=epsonyd
sumRs=0;
RsYs=0;
Aneg=0;
epsonS=zeros(1,PILAR.ncam);
fs=zeros(1,PILAR.ncam);
% Cálculo da profundidade da LN - a LN encontra-se dentro da seção de
% concreto
x=epsonCu/(epsonyd+epsonCu)*d(1);
% Cálculo das deformações específicas, tensões e resultates nas barras de
% aço
for i=1:PILAR.ncam
    epsonS(i)=(x-d(i))/x*epsonCu;
    if epsonS(i)<=-epsonyd
        fs(i)=-PILAR.fyd(j);
    elseif epsonS(i)>=epsonyd
        fs(i)=PILAR.fyd(j);
    else
        fs(i)=epsonS(i)*PILAR.Es(j);
    end
    Rs=fs(i)*PILAR.As(i);
    RsYs=RsYs+Rs*PILAR.ys(i);
    sumRs=sumRs+Rs;
    % A variável Aneg representa uma área negativa que será compuatda caso
    % a camada de barra esteja localizada na zona de compressão do
    % concrento. Essa "área negativa" irá ser somada à área de concreto
    % evitando que a tensão de compressão seja computada duas vezes.
    if d(i)<0.8*x
        Aneg=Aneg-PILAR.As(i);
    end
end
% Cálculo da resultante de compressão no concreto
Rc=0.8*x*PILAR.sigmacd(j)*PILAR.bv(j)+Aneg*PILAR.sigmacd(j);
% Cálculo dos esforços resistentes
PILAR.Pn(3)=Rc+sumRs;
PILAR.Mn(3)=Rc*(PILAR.hv(j)/2-0.8*x/2)+RsYs;

% PONTO 4 - CAMADA DE BARRA JUNTO À SEÇÃO MENOS COMPRIMIDA DO CONCRETO
% INICIA A PLASTIFICAÇÃO - epsonS(1)=0.1%
sumRs=0;
RsYs=0;
Aneg=0;
epsonS=zeros(1,PILAR.ncam);
fs=zeros(1,PILAR.ncam);
% Cálculo da profundidade da LN - a LN encontra-se dentro da seção de
% concreto
x=epsonCu/(0.01+epsonCu)*d(1);
% Cálculo das deformações específicas, tensões e resultates nas barras de
% aço
for i=1:PILAR.ncam
    epsonS(i)=(x-d(i))/x*epsonCu;
    if epsonS(i)<=-epsonyd
        fs(i)=-PILAR.fyd(j);
    elseif epsonS(i)>=epsonyd
        fs(i)=PILAR.fyd(j);
    else
        fs(i)=epsonS(i)*PILAR.Es(j);
    end
    Rs=fs(i)*PILAR.As(i);
    RsYs=RsYs+Rs*PILAR.ys(i);
    sumRs=sumRs+Rs;
    % A variável Aneg representa uma área negativa que será compuatda caso
    % a camada de barra esteja localizada na zona de compressão do
    % concrento. Essa "área negativa" irá ser somada à área de concreto
    % evitando que a tensão de compressão seja computada duas vezes.
    if d(i)<0.8*x
        Aneg=Aneg-PILAR.As(i);
    end
end
% Cálculo da resultante de compressão no concreto
Rc=0.8*x*PILAR.sigmacd(j)*PILAR.bv(j)+Aneg*PILAR.sigmacd(j);
% Cálculo dos esforços resistentes
PILAR.Pn(4)=Rc+sumRs;
PILAR.Mn(4)=Rc*(PILAR.hv(j)/2-0.8*x/2)+RsYs;

% PONTO 5 - TRAÇÃO UNIFORME 
% Apenas as barras de aço resistem aos esforços solicitantes (tração) não
% havendo contribuição do concreto

PILAR.Pn(5)=-PILAR.Astotal*PILAR.fyd(j);
PILAR.Mn(5)=0;

% CÁLCULO DO ESFORÇO NORMAL(NI) E MOMENTO FLETOR (MI) ADIMENSIONAIS
PILAR.NIn=PILAR.Pn./(PILAR.fcd(j)*PILAR.bv(j)*PILAR.hv(j));
PILAR.MIn=PILAR.Mn./(PILAR.bv(j)*PILAR.hutil(j)^2*PILAR.fcd(j));
