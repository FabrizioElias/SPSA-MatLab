function [ngle]=ngl(PORTICO)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIÊNCIAS
% PROGRAMA DE PÓS-GRADUAÇÃO EM ENGENHARIA CIVIL        - ÁREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELEÇÃO DE  MÉDIA FIDELIDADE  PARA  ANÁLISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO.
% ALUNA       Sérgio José Priori Jovino Marques Filho
% ORIENTADOR  Prof. Ézio da Rocha Araújo
% -------------------------------------------------------------------------
% DESCRIÇÃO
% Processa o pórtico plano a partir dos dados de entrada 
% -------------------------------------------------------------------------
% MODIFICAÇÕES:         Modificada em 16/05/2015
%--------------------------------------------------------------------------
% VARIÁVEIS DE ENTRADA: PORTICO
% VARIÁVEIS DE SAÍDA:   ngle: número de graus de liberdade da estrutura
%--------------------------------------------------------------------------
% CRIADA EM 13-Janeiro-2015
% -------------------------------------------------------------------------

global m

% 1.2 - Leitura das condições de contorno do pórtico
id=zeros(PORTICO.nnos,3);
v=[1 2 4];  % Esse vetor faz com que a rotina leia apenas os graus de liberdade referentes a um póritco plano,
            % ou seja dx, dy e rot z. Lembrando que as condições de
            % contorno são inseridas como se o pórtico fosse espacial de
            % forma a termos compatibilidade nas entradas do FEAP e da
            % rotina PorticoPlano.m
AUX=PORTICO.restricao;
AUX=AUX(:,v);
for i=1:PORTICO.qntnosrestritos
    id(PORTICO.nosrestritos(i),:)=AUX(i,:);
end

% 2 - MONTAGEM DO SISTEMA DE EQUAÇÕES
% 2.1 - Reorganização da matriz id (por que?)
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

% 2.2 - Montagem da matriz gdle (não entendi!!!)
for i=1:PORTICO.nelem
    for j=1:3
        gdle(i,j)=id(PORTICO.conec(i,1),j);
        gdle(i,j+3)=id(PORTICO.conec(i,2),j);
    end
end
%2.2.1 - Número de graus de liberdade da estrutura
v=max(gdle);
ngle=max(v);
