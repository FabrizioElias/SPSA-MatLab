function [PORTICO]=soilprop(DADOS, PORTICO)
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
% Calcula os par�metros f�sicos do solo a ser empregado na an�lise
% estoc�stica
% -------------------------------------------------------------------------
% Criada      03-maio-2017                 S�RGIO MARQUES
% -------------------------------------------------------------------------

% C�lculo da matriz dos desvios padr�es para situa��o da ponte se alongando
SIGMAalong=DADOS.covSOLO*PORTICO.springs(:,1);
s=size(SIGMAalong);
s=s(1);
PORTICO.springsAlongV=zeros(s,DADOS.NMC);
% Matriz com o m�dulo de rea��o do solo
% Vetor com distribui��o normal
randonsoil=randn(1,DADOS.NMC);
for i=1:DADOS.NMC
    PORTICO.springsAlongV(:,i)=PORTICO.springs(:,1)+SIGMAalong*randonsoil(i);
end

% C�lculo da matriz dos desvios padr�es para situa��o da ponte encurtando
SIGMAencurt=DADOS.covSOLO*PORTICO.springs(:,3);
s=size(SIGMAencurt);
s=s(1);
PORTICO.springsEncurtV=zeros(s,DADOS.NMC);
% Matriz com o m�dulo de rea��o do solo
% Vetor com distribui��o normal
randonsoil=randn(1,DADOS.NMC);
for i=1:DADOS.NMC
    PORTICO.springsEncurtV(:,i)=PORTICO.springs(:,3)+SIGMAencurt*randonsoil(i);
end











% for i=1:s
%     if PORTICO.springs(i,1)~=0
%         A=zeros(1,3);
%         A(1,1)=PORTICO.springs(i,2);  % <-- Tipo de distribui��o
%         A(1,2)=PORTICO.springs(i,1);  % <-- Valor m�dio da distribui��o  
%         A(1,3)=SIGMA(i,1);            % <-- Desvio padr�o da distribui��o
%         [B]=pdf(A, DADOS);
%         PORTICO.springs(i,1)=B;
%         RANDON.normal=randn(1,DADOS.NMC)
%     end
% end    
