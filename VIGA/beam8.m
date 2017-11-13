function [MCOORD]=beam8(VIGAin)
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
% Rotina para ajustar os valores do MF, calculados 
% -------------------------------------------------------------------------
% MODIFICA��ES:         
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: VIGAout
% VARI�VEIS DE SA�DA:   VIGAout: structure contendo os dados de sa�da da
% viga
%--------------------------------------------------------------------------
% CRIADA EM 27-janeiro-2016
% -------------------------------------------------------------------------

% Cria��o da matriz nula COORD
COORD=zeros(VIGAin.numsecoestrechopos+1,2);

s=size(VIGAin.POS);
s=s(2);
x=zeros(1,s);
 for i=1:s
    x(i)=i*VIGAin.compelem(1,1);
 end

% 1 PASSO:
% C�lculo dos coeficientes da curva
coef=polyfit(x,VIGAin.POS,2);

% 2 PASSO
% C�lculo das ra�zes da par�bola, coordenadas em x onde o DMF ser� nulo.
r=roots(coef);
COORD(1,:)=r;

% 3 PASSO
% Cria um vetor com 100 elementos igualmente espa�ados onde os valores
% extremos s�o r(1) e r(2).
xx=linspace(r(2), r(1));
% C�lcula o valor do MF � partir da par�bola ajustada nos 100 pontos
% anteriormente definidos
ff=polyval(coef,xx);
% C�lcula o valor do MF m�ximo dentre os 100 anteriormente calculados
Mmax=max(ff);

% 4 PASSO
% A vari�vel a � a quantidade de arranjos de armaduras diferentes
% existir�o, considerou-se 5 por conveni�ncia
a=Mmax/VIGAin.numsecoestrechopos;
M=zeros(1,VIGAin.numsecoestrechopos);
for i=1:VIGAin.numsecoestrechopos
    M(i)=a*i; % <-- Vetor contendo os valores do MF que ter�o a armadura calculada 
end

% 5 PASSO
% Calcula os valores de x para cada valor do MF especificado em MM
for i=1:VIGAin.numsecoestrechopos
    COEF=coef;
    COEF(3)=coef(3)-M(i);
    r=roots(COEF);
    COORD(i+1,:)=r;
end
COORD(VIGAin.numsecoestrechopos+1,:)=[]; % <-- elimina a �ltima linha
COORD=fliplr(COORD); % <-- colunas s�o "trocadas"de posi��o.

% 6 PASSO
% Calcula o comprimento do trecho de MF negativo
s=size(VIGAin.NEG);
Lneg=VIGAin.compelem*(s(2)-1); % <--subtrai-se "1" pois a se��o onde o MF muda de sinal se sobrep�es
% C�lcula a abscissa m�xima onde o MF pode ser positivo
Xmax=VIGAin.COMPRIMENTO-Lneg;
% Ordena os valores do MF por ordem crescente
MCOORD=fliplr(([M' COORD])')';
% Substitui��o da abscissa m�xima 
for i=1:VIGAin.numsecoestrechopos
    if  MCOORD(i,3)>Xmax
        MCOORD(i,3)=Xmax;
    end
end

