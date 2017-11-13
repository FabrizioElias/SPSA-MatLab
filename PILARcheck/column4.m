function [PILAR]=column4(PILAR, j)
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

epsonyd=PILAR.fyd(j)/PILAR.Es(j);
epsonCu=0.0035;
d=-(PILAR.ys-PILAR.hv(j)/2);

% PONTO 1 - COMPRESS�O AXIAL UNIFORME
Rs=0;
% C�lculo da profundidade da LN - a LN encontra-se no infinito

% C�lculo das deforma��es espec�ficas e tens�o nas barras - uma vez que 
% toda a se��o encontra-se comprimida com o valor de epson igual ao 
% encurtamento m�ximo admiss�vel do concreto tem-se que epsonSi=epsonCu. 
% Como na compress�o a deforma��o espec�fica de escoamento do a�o � igual 
% ao encurtamento espec�fico do concreto, temos que todo o a�o escontra-se 
% plastificado.
fs=PILAR.fyd(j)*ones(1,PILAR.ncam);
% C�lculo da resultante de compress�o no concreto
Rc=PILAR.sigmacd(j)*(PILAR.bv(j)*PILAR.hv(j)-PILAR.Astotal); % <-- Descontada a �rea de a�o
% C�lculo da resultante de compress�o nas barras
for i=1:PILAR.ncam
    %Rs(i)=fs(i).*PILARin.As(i);
    Rs=Rs+fs(i).*PILAR.As(i);
end
% Esfor�o normal resistente
PILAR.Pn(1)=Rc+Rs;
PILAR.Mn(1)=0;

% PONTO 2 - IN�CIO DA FISSURA��O DO CONCRETO
Aneg=zeros(1,PILAR.ncam);
epsonS=zeros(1,PILAR.ncam);
fs=zeros(1,PILAR.ncam);
Rs=zeros(1,PILAR.ncam);
% C�lculo da profundidade da LN - a LN encontra-se na base da se��o
% transversal de concreto, assim x=h.
x=PILAR.h;
% Aqui ser� criada uma variavel chamada RsYs, que ser� a soma da for�a
% resultante na camada i multiplicada pela coordenada da camada "i". Isso
% foi feito para evitar o comando "sum", vide linha XX comentada que estava
% tomando muito tempo no processamento.
sumRs=0;
RsYs=0;
Aneg=0;
% C�lculo das deforma��es espec�ficas, tens�es e resultates nas barras de
% a�o

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
    % A vari�vel Aneg representa uma �rea negativa que ser� compuatda caso
    % a camada de barra esteja localizada na zona de compress�o do
    % concrento. Essa "�rea negativa" ir� ser somada � �rea de concreto
    % evitando que a tens�o de compress�o seja computada duas vezes.
    if d(i)<0.8*x
        Aneg=Aneg-PILAR.As(i);
    end
end
% C�lculo da resultante de compress�o no concreto
Rc=0.8*x*PILAR.sigmacd(j)*PILAR.bv(j)+Aneg*PILAR.sigmacd(j);
% C�lculo dos esfor�os resistentes
PILAR.Pn(2)=Rc+sumRs;
%PILARout.Mn(2)=Rc*(PILARin.h/2-0.8*x/2)+sum(Rs.*PILARout.ys);
PILAR.Mn(2)=Rc*(PILAR.hv(j)/2-0.8*x/2)+RsYs;

% PONTO 3 - CAMADA DE BARRA JUNTO � SE��O MENOS COMPRIMIDA DO CONCRETO
% INICIA A PLASTIFICA��O - epsonS(1)=epsonyd
sumRs=0;
RsYs=0;
Aneg=0;
epsonS=zeros(1,PILAR.ncam);
fs=zeros(1,PILAR.ncam);
% C�lculo da profundidade da LN - a LN encontra-se dentro da se��o de
% concreto
x=epsonCu/(epsonyd+epsonCu)*d(1);
% C�lculo das deforma��es espec�ficas, tens�es e resultates nas barras de
% a�o
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
    % A vari�vel Aneg representa uma �rea negativa que ser� compuatda caso
    % a camada de barra esteja localizada na zona de compress�o do
    % concrento. Essa "�rea negativa" ir� ser somada � �rea de concreto
    % evitando que a tens�o de compress�o seja computada duas vezes.
    if d(i)<0.8*x
        Aneg=Aneg-PILAR.As(i);
    end
end
% C�lculo da resultante de compress�o no concreto
Rc=0.8*x*PILAR.sigmacd(j)*PILAR.bv(j)+Aneg*PILAR.sigmacd(j);
% C�lculo dos esfor�os resistentes
PILAR.Pn(3)=Rc+sumRs;
PILAR.Mn(3)=Rc*(PILAR.hv(j)/2-0.8*x/2)+RsYs;

% PONTO 4 - CAMADA DE BARRA JUNTO � SE��O MENOS COMPRIMIDA DO CONCRETO
% INICIA A PLASTIFICA��O - epsonS(1)=0.1%
sumRs=0;
RsYs=0;
Aneg=0;
epsonS=zeros(1,PILAR.ncam);
fs=zeros(1,PILAR.ncam);
% C�lculo da profundidade da LN - a LN encontra-se dentro da se��o de
% concreto
x=epsonCu/(0.01+epsonCu)*d(1);
% C�lculo das deforma��es espec�ficas, tens�es e resultates nas barras de
% a�o
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
    % A vari�vel Aneg representa uma �rea negativa que ser� compuatda caso
    % a camada de barra esteja localizada na zona de compress�o do
    % concrento. Essa "�rea negativa" ir� ser somada � �rea de concreto
    % evitando que a tens�o de compress�o seja computada duas vezes.
    if d(i)<0.8*x
        Aneg=Aneg-PILAR.As(i);
    end
end
% C�lculo da resultante de compress�o no concreto
Rc=0.8*x*PILAR.sigmacd(j)*PILAR.bv(j)+Aneg*PILAR.sigmacd(j);
% C�lculo dos esfor�os resistentes
PILAR.Pn(4)=Rc+sumRs;
PILAR.Mn(4)=Rc*(PILAR.hv(j)/2-0.8*x/2)+RsYs;

% PONTO 5 - TRA��O UNIFORME 
% Apenas as barras de a�o resistem aos esfor�os solicitantes (tra��o) n�o
% havendo contribui��o do concreto

PILAR.Pn(5)=-PILAR.Astotal*PILAR.fyd(j);
PILAR.Mn(5)=0;

% C�LCULO DO ESFOR�O NORMAL(NI) E MOMENTO FLETOR (MI) ADIMENSIONAIS
PILAR.NIn=PILAR.Pn./(PILAR.fcd(j)*PILAR.bv(j)*PILAR.hv(j));
PILAR.MIn=PILAR.Mn./(PILAR.bv(j)*PILAR.hutil(j)^2*PILAR.fcd(j));
