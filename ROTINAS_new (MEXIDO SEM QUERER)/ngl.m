function [ngle]=ngl(PORTICO)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCI�NCIAS
% PROGRAMA DE P�S-GRADUA��O EM ENGENHARIA CIVIL        - �REA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELE��O DE  M�DIA FIDELIDADE  PARA  AN�LISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO.
% ALUNA       S�rgio Jos� Priori Jovino Marques Filho
% ORIENTADOR  Prof. �zio da Rocha Ara�jo
% -------------------------------------------------------------------------
% DESCRI��O
% Processa o p�rtico plano a partir dos dados de entrada 
% -------------------------------------------------------------------------
% MODIFICA��ES:         Modificada em 16/05/2015
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: PORTICO
% VARI�VEIS DE SA�DA:   ngle: n�mero de graus de liberdade da estrutura
%--------------------------------------------------------------------------
% CRIADA EM 13-Janeiro-2015
% -------------------------------------------------------------------------

global m

% 1.2 - Leitura das condi��es de contorno do p�rtico
id=zeros(PORTICO.nnos,3);
v=[1 2 4];  % Esse vetor faz com que a rotina leia apenas os graus de liberdade referentes a um p�ritco plano,
            % ou seja dx, dy e rot z. Lembrando que as condi��es de
            % contorno s�o inseridas como se o p�rtico fosse espacial de
            % forma a termos compatibilidade nas entradas do FEAP e da
            % rotina PorticoPlano.m
AUX=PORTICO.restricao;
AUX=AUX(:,v);
for i=1:PORTICO.qntnosrestritos
    id(PORTICO.nosrestritos(i),:)=AUX(i,:);
end

% 2 - MONTAGEM DO SISTEMA DE EQUA��ES
% 2.1 - Reorganiza��o da matriz id (por que?)
ngl=0;
for i=1:PORTICO.nnos
    for j=1:3
        n=id(i,j);
        if n>=1
            id(i,j)=0; 
        else
            ngl=ngl+1;
            id(i,j)=ngl;
        end
    end
end

% 2.2 - Montagem da matriz gdle (n�o entendi!!!)
for i=1:PORTICO.nelem
    for j=1:3
        gdle(i,j)=id(PORTICO.conec(i,1),j);
        gdle(i,j+3)=id(PORTICO.conec(i,2),j);
    end
end
%2.2.1 - N�mero de graus de liberdade da estrutura
v=max(gdle);
ngle=max(v);
