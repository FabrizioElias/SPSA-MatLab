function [MCOORD]=beam8(VIGAin)
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
% Rotina para ajustar os valores do MF, calculados 
% -------------------------------------------------------------------------
% MODIFICAÇÕES:         
%--------------------------------------------------------------------------
% VARIÁVEIS DE ENTRADA: VIGAout
% VARIÁVEIS DE SAÍDA:   VIGAout: structure contendo os dados de saída da
% viga
%--------------------------------------------------------------------------
% CRIADA EM 27-janeiro-2016
% -------------------------------------------------------------------------

% Criação da matriz nula COORD
COORD=zeros(VIGAin.numsecoestrechopos+1,2);

s=size(VIGAin.POS);
s=s(2);
x=zeros(1,s);
 for i=1:s
    x(i)=i*VIGAin.compelem(1,1);
 end

% 1 PASSO:
% Cálculo dos coeficientes da curva
coef=polyfit(x,VIGAin.POS,2);

% 2 PASSO
% Cálculo das raízes da parábola, coordenadas em x onde o DMF será nulo.
r=roots(coef);
COORD(1,:)=r;

% 3 PASSO
% Cria um vetor com 100 elementos igualmente espaçados onde os valores
% extremos são r(1) e r(2).
xx=linspace(r(2), r(1));
% Cálcula o valor do MF à partir da parábola ajustada nos 100 pontos
% anteriormente definidos
ff=polyval(coef,xx);
% Cálcula o valor do MF máximo dentre os 100 anteriormente calculados
Mmax=max(ff);

% 4 PASSO
% A variável a é a quantidade de arranjos de armaduras diferentes
% existirão, considerou-se 5 por conveniência
a=Mmax/VIGAin.numsecoestrechopos;
M=zeros(1,VIGAin.numsecoestrechopos);
for i=1:VIGAin.numsecoestrechopos
    M(i)=a*i; % <-- Vetor contendo os valores do MF que terão a armadura calculada 
end

% 5 PASSO
% Calcula os valores de x para cada valor do MF especificado em MM
for i=1:VIGAin.numsecoestrechopos
    COEF=coef;
    COEF(3)=coef(3)-M(i);
    r=roots(COEF);
    COORD(i+1,:)=r;
end
COORD(VIGAin.numsecoestrechopos+1,:)=[]; % <-- elimina a última linha
COORD=fliplr(COORD); % <-- colunas são "trocadas"de posição.

% 6 PASSO
% Calcula o comprimento do trecho de MF negativo
s=size(VIGAin.NEG);
Lneg=VIGAin.compelem*(s(2)-1); % <--subtrai-se "1" pois a seção onde o MF muda de sinal se sobrepões
% Cálcula a abscissa máxima onde o MF pode ser positivo
Xmax=VIGAin.COMPRIMENTO-Lneg;
% Ordena os valores do MF por ordem crescente
MCOORD=fliplr(([M' COORD])')';
% Substituição da abscissa máxima 
for i=1:VIGAin.numsecoestrechopos
    if  MCOORD(i,3)>Xmax
        MCOORD(i,3)=Xmax;
    end
end

