function [PILAR]=column3(PILAR, j)
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
% Rotina para cálculo da ordenada do CG das barras.
% -------------------------------------------------------------------------
% MODIFICAÇÕES:         
%--------------------------------------------------------------------------
% VARIÁVEIS DE ENTRADA: --
% VARIÁVEIS DE SAÍDA:   PILARin: "structure" contendo as variáveis necessá-
% rias ao algoritmo de detalhamento do pilar - column.m 
%--------------------------------------------------------------------------
% CRIADA EM 21-fevereiro-2016
% -------------------------------------------------------------------------

% CÁLCULO DAS ORDENADAS DO CENTRO DE GRAVIDADE DAS BARRAS - centro de
% gravidade da seção transversal é tomado como sendo a origem do sistema
% Criação do vetor nulo "ys'
ys=zeros(1,PILAR.ncam);
% Distância entre CG das camadas extremas
PILAR.hutil(j)=PILAR.hv(j)-2*(PILAR.cob+PILAR.diamestribo+PILAR.diambarra/2);
% Quantidade de espaço entre barras
numespacos=PILAR.ncam-1;
% Espaçamento entre camadas de barras
espaco=PILAR.hutil(j)/numespacos;
% Coordenada da primeira camada de barras
ys(1)=-PILAR.hutil(j)/2;
% Coordenada das camadas adjacentes
for jj=2:PILAR.ncam
    ys(jj)=ys(jj-1)+espaco;
end
PILAR.ys=ys ;

% CÁLCULO DA ÁREA DE AÇO EM CADA CAMADA DE BARRA
% Número de barras por camada
nbcam=2*ones(1,PILAR.ncam);
nbcam(1)=PILAR.ncol;
nbcam(PILAR.ncam)=PILAR.ncol;
% Área de aço por camada
Asbarra=pi*(PILAR.diambarra)^2/4;
PILAR.As=Asbarra*nbcam;

PILAR.Astotal=sum(PILAR.As);


