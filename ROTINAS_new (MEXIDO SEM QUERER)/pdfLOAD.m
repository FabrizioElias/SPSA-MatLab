function [B]=pdfLOAD(C, DADOS, s)
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
% APENAS DISTRIBUI��O NORMAL!!!!!!

global m
B=zeros(s,DADOS.NMC);
RANDnormal=randn(1,DADOS.NMC);
for i=1:DADOS.NMC
    B(:,i)=C(:,2)+C(:,3)*RANDnormal(i);
end

