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

%FAB - Vari�vel global m n�o � utilizada no c�digo.
%global m
%FAB - Utiliza��o de uma fun��o j� pronta para gera��o das distribui��es.
RANDOM = generaterandon(DADOS);
if A(1)==1
    % randn('state',100);
    %RANDOM.normal=randn(1,DADOS.NMC);
    B=A(2)+A(3).*RANDOM.normal;
elseif A(1)==2
    B=A(2)+A(3)*RANDOM.gamma;
elseif A(1)==3
    B=A(2)+A(3)*RANDOM.exponential;
elseif A(1)==4
    B=A(2)+A(3)*RANDOM.weibull;
elseif A(1)==5
    B=A(2)+A(3)*RANDOM.gumbel;
elseif A(1)==6
    B=A(2)+A(3)*RANDOM.lognormal;
else
    disp('Erro - Distribui��o n�o implementada.')
end
