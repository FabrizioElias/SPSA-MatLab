function [YcgTrac, difTrac]=beam2(ARRANJOtrac, VIGAin)
% function [YcgTrac, YcgComp, difTrac, difComp, Dtrac, Dcomp]=beam2(ARRANJOtrac, ARRANJOcomp, VIGA, VIGAin)
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
% Rotina para distribuir as barras ao longo das camadas e determinar o CG
% do conjunto de barras. A vari�vel diftrac � a diferen�a entre a ordenada
% o CG das barras e o CG da camada de barra mais distante. Essa vari�vel
% serve para definir se a qnt de camadas de barras n�o � excessiva,
% conforme recomenda��o da norma ela n�o pode ser superior a 10% de h.
% -------------------------------------------------------------------------
% MODIFICA��ES:         
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: ARRANJOtrac, VIGAin
% VARI�VEIS DE SA�DA:   Ycgtrac - CG do conjunto de barras tracionadas
%                       diftrac - diferen�a entre as ordendas do CG do
%                       arranjo e do CG da barra mis distante
%--------------------------------------------------------------------------
% CRIADA EM 30-junho-2015
% -------------------------------------------------------------------------


% Determina��o da qnt de barras em uma camada - Armaduras de tra��o

shmin = max([0.02 1.2*VIGAin.diamagregado ARRANJOtrac(2)/1000]); % espa�amento horizontal m�nimo entre barras NBR 6118
nbtrac=floor((VIGAin.b-2*(VIGAin.cob+VIGAin.diamcort)+shmin)/(ARRANJOtrac(2)/1000+shmin)); % n�mero m�ximo de barras por camada
svmin=max([0.02 0.5*VIGAin.diamagregado ARRANJOtrac(2)/1000]); % Espa�amento vertical das barras

% Distribui��o das barras ao longo da altura da viga
qntbarrastrac=ARRANJOtrac(1);   % Quantidade total de barras em uma se��o
ncamtrac=ceil(qntbarrastrac/nbtrac);        % N�mero de camadas

% Vetor com o di�metro das barras - vari�vel auxiliar, serve apenas
% para ajudar a montar a matriz D
C=zeros(1,ncamtrac*nbtrac);
for i=1:ARRANJOtrac(1)
   C(1,i)=ARRANJOtrac(2);
end
if ARRANJOtrac(1)<qntbarrastrac
    for i=ARRANJOtrac(1)+1:qntbarrastrac
       C(1,i)=ARRANJOtrac(2);
    end
end

% Matriz contendo o di�metro das barras, a �ltima linha corresponde
% � primeira camada de barras (camada mais externa).
Dtrac=zeros(ncamtrac,nbtrac);     
K=ncamtrac;
KK=1;
for i=1:ncamtrac
   for ii=1:nbtrac
       Dtrac(K,ii)=C(KK);
       KK=KK+1;
   end
   K=K-1;
end
Dtrac=Dtrac./1000;

% C�lculo do cg das barras
% Matriz contendo a �rea das barras
A=(pi.*(Dtrac.^2)./4);

% Matriz contendo o Ycg de cada barra
c=size(Dtrac);
CG=zeros(c);

for i=1:c(2)
   CG(ncamtrac,i)=(VIGAin.cob+VIGAin.diamcort)+(Dtrac(ncamtrac,i)/2);
end

for i=1:ncamtrac-1
   for ii=1:c(2)
       CG(ncamtrac-i,ii)=CG(ncamtrac-i+1,ii)+Dtrac(ncamtrac-i+1,ii)/2+svmin+Dtrac(ncamtrac-i,ii)/2;
   end
end

% Centro de gravidade do conjunto de barras
YcgTrac=sum(sum(CG.*A))/sum(sum(A));

% Determina��o da dist�ncia entre o CG do conjunto de barras, Ycg, e
% o topo da barra mais distante do CG, Ytopo. Essa verifica��o � �til para
% verificar a limita��o da quatidade de camadas
Ytopo=max(Dtrac(1,:))/2+max(CG(1,:));
difTrac=Ytopo-YcgTrac;

end