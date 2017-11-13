function [PORTICO]=soilprop(DADOS, PORTICO)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIENCIAS
% PROGRAMA DE POS-GRADUACAO EM ENGENHARIA CIVIL        - AREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELECAO DE  MEDIA FIDELIDADE  PARA  ANALISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO
% ALUNA       Sérgio José Priori Jovino Marques Filho
% ORIENTADOR  Prof. Ezio da Rocha Araujo
% -------------------------------------------------------------------------
% DESCRICAO
% Calcula os parâmetros físicos do solo a ser empregado na análise
% estocástica
% -------------------------------------------------------------------------
% Criada      03-maio-2017                 SÉRGIO MARQUES
% -------------------------------------------------------------------------

% Cálculo da matriz dos desvios padrões para situação da ponte se alongando
SIGMAalong=DADOS.covSOLO*PORTICO.springs(:,1);
s=size(SIGMAalong);
s=s(1);
PORTICO.springsAlongV=zeros(s,DADOS.NMC);
% Matriz com o módulo de reação do solo
% Vetor com distribuição normal
randonsoil=randn(1,DADOS.NMC);
for i=1:DADOS.NMC
    PORTICO.springsAlongV(:,i)=PORTICO.springs(:,1)+SIGMAalong*randonsoil(i);
end

% Cálculo da matriz dos desvios padrões para situação da ponte encurtando
SIGMAencurt=DADOS.covSOLO*PORTICO.springs(:,3);
s=size(SIGMAencurt);
s=s(1);
PORTICO.springsEncurtV=zeros(s,DADOS.NMC);
% Matriz com o módulo de reação do solo
% Vetor com distribuição normal
randonsoil=randn(1,DADOS.NMC);
for i=1:DADOS.NMC
    PORTICO.springsEncurtV(:,i)=PORTICO.springs(:,3)+SIGMAencurt*randonsoil(i);
end











% for i=1:s
%     if PORTICO.springs(i,1)~=0
%         A=zeros(1,3);
%         A(1,1)=PORTICO.springs(i,2);  % <-- Tipo de distribuição
%         A(1,2)=PORTICO.springs(i,1);  % <-- Valor médio da distribuição  
%         A(1,3)=SIGMA(i,1);            % <-- Desvio padrão da distribuição
%         [B]=pdf(A, DADOS);
%         PORTICO.springs(i,1)=B;
%         RANDON.normal=randn(1,DADOS.NMC)
%     end
% end    
