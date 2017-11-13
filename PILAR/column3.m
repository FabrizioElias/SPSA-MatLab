function [PILARout]=column3(PILARin, PILARout, diamestribo)
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
% Rotina para resolução do sistema e determinação dos valores de epson0 e k
% no "passo"seguinte.
% -------------------------------------------------------------------------
% MODIFICAÇÕES:         
%--------------------------------------------------------------------------
% VARIÁVEIS DE ENTRADA: --
% VARIÁVEIS DE SAÍDA:   PILARin: "structure" contendo as variáveis necessá-
% rias ao algoritmo de detalhamento do pilar - column.m 
%--------------------------------------------------------------------------
% CRIADA EM 21-fevereiro-2016
% -------------------------------------------------------------------------

% Criação do vetor nulo "ys'
ys=zeros(1,PILARin.ncam);

% Distância entre CG das camadas extremas
hutil=PILARin.h-2*(PILARin.cob+diamestribo+PILARin.diambarra/2);

% Quantidade de espaço entre barras
numespacos=PILARin.ncam-1;

% Espaçamento entre camadas de barras
espaco=hutil/numespacos;

% Coordenada da primeira camada de barras
ys(1)=-hutil/2;

% Coordenada das camadas adjacentes
for jj=2:PILARin.ncam
    ys(jj)=ys(jj-1)+espaco;
end
PILARout.ys=ys ;
