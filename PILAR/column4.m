function [PILARout]=column4(PILARin, PILARout)
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

epsonyd=PILARin.fyd/PILARin.Es;
epsonCu=0.0035;
d=-(PILARout.ys-PILARin.h/2);

% PONTO 1 - COMPRESSÃO AXIAL UNIFORME
Rs=0;
% Cálculo da profundidade da LN - a LN encontra-se no infinito

% Cálculo das deformações específicas e tensão nas barras - uma vez que 
% toda a seção encontra-se comprimida com o velor de epson igual ao 
% encurtamento máximo admissível do concreto tem-se que epsonSi=epsonCu. 
% Como na compressão a deformação específica de escoamento do aço é igual 
% ao encurtamento específico do concreto, temos que todo o aço escontra-se 
% plastificado.
fs=PILARin.fyd*ones(1,PILARin.ncam);
% Cálculo da resultante de compressão no concreto
Rc=PILARin.sigmacd*(PILARin.b*PILARin.h-PILARin.Astotal); % <-- Descontada a área de aço
% Cálculo da resultante de compressão nas barras
for i=1:PILARin.ncam
    %Rs(i)=fs(i).*PILARin.As(i);
    Rs=Rs+fs(i).*PILARin.As(i);
end
% Esforço normal resistente
PILARout.Pn(1)=Rc+Rs;
PILARout.Mn(1)=0;

% PONTO 2 - INÍCIO DA FISSURAÇÃO DO CONCRETO
%FAB - Remoção de prealocação sem utilidade.
%Aneg=zeros(1,PILARin.ncam);
%Rs=zeros(1,PILARin.ncam);
epsonS=zeros(1,PILARin.ncam);
fs=zeros(1,PILARin.ncam);
% Cálculo da profundidade da LN - a LN encontra-se na base da seção
% transversal de concreto, assim x=h.
x=PILARin.h;
% Aqui será criada uma variavel chamada RsYs, que será a soma da força
% resultante na camada i multiplicada pela coordenada da camada "i". Isso
% foi feito para evitar o comando "sum", vide linha XX comentada que estava
% tomando muito tempo no processamento.
sumRs=0;
RsYs=0;
Aneg=0;
% Cálculo das deformações específicas, tensões e resultates nas barras de
% aço

for i=1:PILARin.ncam
    epsonS(i)=epsonCu*(PILARin.h-d(i))/PILARin.h;
    if epsonS(i)<=-epsonyd
        fs(i)=-PILARin.fyd;
    elseif epsonS(i)>=epsonyd
        fs(i)=PILARin.fyd;
    else
        fs(i)=epsonS(i)*PILARin.Es;
    end
    Rs=fs(i)*PILARin.As(i);
    RsYs=RsYs+Rs*PILARout.ys(i);
    sumRs=sumRs+Rs;
    % A variável Aneg representa uma área negativa que será compuatda caso
    % a camada de barra esteja localizada na zona de compressão do
    % concrento. Essa "área negativa" irá ser somada à área de concreto
    % evitando que a tensão de compressão seja computada duas vezes.
    if d(i)<0.8*x
        Aneg=Aneg-PILARin.As(i);
    end
end
% Cálculo da resultante de compressão no concreto
Rc=0.8*x*PILARin.sigmacd*PILARin.b+Aneg*PILARin.sigmacd;
% Cálculo dos esforços resistentes
PILARout.Pn(2)=Rc+sumRs;
%PILARout.Mn(2)=Rc*(PILARin.h/2-0.8*x/2)+sum(Rs.*PILARout.ys);
PILARout.Mn(2)=Rc*(PILARin.h/2-0.8*x/2)+RsYs;

% PONTO 3 - CAMADA DE BARRA JUNTO À SEÇÃO MENOS COMPRIMIDA DO CONCRETO
% INICIA A PLASTIFICAÇÃO - epsonS(1)=epsonyd
sumRs=0;
RsYs=0;
Aneg=0;
epsonS=zeros(1,PILARin.ncam);
fs=zeros(1,PILARin.ncam);
% Cálculo da profundidade da LN - a LN encontra-se dentro da seção de
% concreto
x=epsonCu/(epsonyd+epsonCu)*d(1);
% Cálculo das deformações específicas, tensões e resultates nas barras de
% aço
for i=1:PILARin.ncam
    epsonS(i)=(x-d(i))/x*epsonCu;
    if epsonS(i)<=-epsonyd
        fs(i)=-PILARin.fyd;
    elseif epsonS(i)>=epsonyd
        fs(i)=PILARin.fyd;
    else
        fs(i)=epsonS(i)*PILARin.Es;
    end
    Rs=fs(i)*PILARin.As(i);
    RsYs=RsYs+Rs*PILARout.ys(i);
    sumRs=sumRs+Rs;
    % A variável Aneg representa uma área negativa que será compuatda caso
    % a camada de barra esteja localizada na zona de compressão do
    % concrento. Essa "área negativa" irá ser somada à área de concreto
    % evitando que a tensão de compressão seja computada duas vezes.
    if d(i)<0.8*x
        Aneg=Aneg-PILARin.As(i);
    end
end
% Cálculo da resultante de compressão no concreto
Rc=0.8*x*PILARin.sigmacd*PILARin.b+Aneg*PILARin.sigmacd;
% Cálculo dos esforços resistentes
PILARout.Pn(3)=Rc+sumRs;
PILARout.Mn(3)=Rc*(PILARin.h/2-0.8*x/2)+RsYs;

% PONTO 4 - CAMADA DE BARRA JUNTO À SEÇÃO MENOS COMPRIMIDA DO CONCRETO
% INICIA A PLASTIFICAÇÃO - epsonS(1)=0.1%
sumRs=0;
RsYs=0;
Aneg=0;
epsonS=zeros(1,PILARin.ncam);
fs=zeros(1,PILARin.ncam);
% Cálculo da profundidade da LN - a LN encontra-se dentro da seção de
% concreto
x=epsonCu/(0.01+epsonCu)*d(1);
% Cálculo das deformações específicas, tensões e resultates nas barras de
% aço
for i=1:PILARin.ncam
    epsonS(i)=(x-d(i))/x*epsonCu;
    if epsonS(i)<=-epsonyd
        fs(i)=-PILARin.fyd;
    elseif epsonS(i)>=epsonyd
        fs(i)=PILARin.fyd;
    else
        fs(i)=epsonS(i)*PILARin.Es;
    end
    Rs=fs(i)*PILARin.As(i);
    RsYs=RsYs+Rs*PILARout.ys(i);
    sumRs=sumRs+Rs;
    % A variável Aneg representa uma área negativa que será compuatda caso
    % a camada de barra esteja localizada na zona de compressão do
    % concrento. Essa "área negativa" irá ser somada à área de concreto
    % evitando que a tensão de compressão seja computada duas vezes.
    if d(i)<0.8*x
        Aneg=Aneg-PILARin.As(i);
    end
end
% Cálculo da resultante de compressão no concreto
Rc=0.8*x*PILARin.sigmacd*PILARin.b+Aneg*PILARin.sigmacd;
% Cálculo dos esforços resistentes
PILARout.Pn(4)=Rc+sumRs;
PILARout.Mn(4)=Rc*(PILARin.h/2-0.8*x/2)+RsYs;

% PONTO 5 - TRAÇÃO UNIFORME 
% Apenas as barras de aço resistem aos esforços solicitantes (tração) não
% havendo contribuição do concreto

PILARout.Pn(5)=-PILARin.Astotal*PILARin.fyd;
PILARout.Mn(5)=0;
