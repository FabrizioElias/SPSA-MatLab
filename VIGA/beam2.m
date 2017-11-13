function [YcgTrac, difTrac]=beam2(ARRANJOtrac, VIGAin)
% function [YcgTrac, YcgComp, difTrac, difComp, Dtrac, Dcomp]=beam2(ARRANJOtrac, ARRANJOcomp, VIGA, VIGAin)
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
% Rotina para distribuir as barras ao longo das camadas e determinar o CG
% do conjunto de barras. A variável diftrac é a diferença entre a ordenada
% o CG das barras e o CG da camada de barra mais distante. Essa variável
% serve para definir se a qnt de camadas de barras não é excessiva,
% conforme recomendação da norma ela não pode ser superior a 10% de h.
% -------------------------------------------------------------------------
% MODIFICAÇÕES:         
%--------------------------------------------------------------------------
% VARIÁVEIS DE ENTRADA: ARRANJOtrac, VIGAin
% VARIÁVEIS DE SAÍDA:   Ycgtrac - CG do conjunto de barras tracionadas
%                       diftrac - diferença entre as ordendas do CG do
%                       arranjo e do CG da barra mis distante
%--------------------------------------------------------------------------
% CRIADA EM 30-junho-2015
% -------------------------------------------------------------------------


% Determinação da qnt de barras em uma camada - Armaduras de tração

shmin = max([0.02 1.2*VIGAin.diamagregado ARRANJOtrac(2)/1000]); % espaçamento horizontal mínimo entre barras NBR 6118
nbtrac=floor((VIGAin.b-2*(VIGAin.cob+VIGAin.diamcort)+shmin)/(ARRANJOtrac(2)/1000+shmin)); % número máximo de barras por camada
svmin=max([0.02 0.5*VIGAin.diamagregado ARRANJOtrac(2)/1000]); % Espaçamento vertical das barras

% Distribuição das barras ao longo da altura da viga
qntbarrastrac=ARRANJOtrac(1);   % Quantidade total de barras em uma seção
ncamtrac=ceil(qntbarrastrac/nbtrac);        % Número de camadas

% Vetor com o diâmetro das barras - variável auxiliar, serve apenas
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

% Matriz contendo o diâmetro das barras, a última linha corresponde
% à primeira camada de barras (camada mais externa).
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

% Cálculo do cg das barras
% Matriz contendo a área das barras
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

% Determinação da distância entre o CG do conjunto de barras, Ycg, e
% o topo da barra mais distante do CG, Ytopo. Essa verificação é útil para
% verificar a limitação da quatidade de camadas
Ytopo=max(Dtrac(1,:))/2+max(CG(1,:));
difTrac=Ytopo-YcgTrac;

end