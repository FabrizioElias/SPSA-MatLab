function [B]=pdf(A, DADOS)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIENCIAS
% PROGRAMA DE POS-GRADUACAO EM ENGENHARIA CIVIL        - AREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELECAO DE  MEDIA FIDELIDADE  PARA  ANALISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO
% ALUNA       S�rgio Jos� Priori Jovino Marques Filho
% ORIENTADOR  Prof. Ezio da Rocha Araujo
% -------------------------------------------------------------------------
% DESCRICAO
% Fun��o para amostrar o valor das vari�veis aleat�rias conforme o tipo de
% distribui��o de probabilidade
% -------------------------------------------------------------------------
% Criada      19-maio-2016                 S�RGIO MARQUES
% -------------------------------------------------------------------------
% Quantidade de n�s com restri��o

global m

if A(1)==1 || DADOS.op_exec==0
    % randn('state',100);
    RANDON.normal=randn(1,DADOS.NMC);
    B=A(2)+A(3).*RANDON.normal;
% DISTRIBUI��O LOGNORMAL EXCLUSIVAMENTE PARA AMOSTRAGEM DO CONCRETO SEGUNDO
% O JCSS
elseif A(1)==2 && DADOS.op_exec~=0
    med=A(2);
    n=A(3)^2;
    mu=log(med^2/((n+med^2)^0.5));
    sigma=(log(n/med^2+1))^0.5;
    pd=makedist('Lognormal','mu',mu,'sigma',sigma);
    fc0=random(pd,DADOS.NMC,1);
    % Fun��o alfa(t,tau) - Determin�stica
    alfa3=0.8;
    atau=0.04;
    tau=1095;
    t=20;
    alfa1=alfa3+(1-alfa3)*exp(-atau*tau);
    alfa2=0.6+0.12*log(t);
    alfa=alfa1*alfa2;
    % C�lculo par�metro lambda
    med=0.96;
    n=(0.005*med)^2;
    mu=log(med^2/((n+med^2)^0.5));
    sigma=(log(n/med^2+1))^0.5;
    pd=makedist('Lognormal','mu',mu,'sigma',sigma);
    lambda=random(pd,DADOS.NMC,1);
    % Resist�ncia � compress�o segundo o JCSS
    fclog=alfa*fc0.^lambda;
    B=fclog; 
elseif A(1)==3
    B=A(2)+A(3)*RANDON.exponential;
elseif A(1)==4
    B=A(2)+A(3)*RANDON.weibull;
elseif A(1)==5
    B=A(2)+A(3)*RANDON.gumbel;
elseif A(1)==6
    B=A(2)+A(3)*RANDON.lognormal;
else
    disp('Erro - distribui��o n�o implementada')
end
