function [PAR]=economicpar(PAR, DADOS)
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
% Calcula os parâmetros econôimcos a serem utilizados na otimização.
% Assume-se uma distribuição Gaussiana
% -------------------------------------------------------------------------
% Criada      15-abril-2016                 SÉRGIO MARQUES
% -------------------------------------------------------------------------

A=zeros(1,3);
A(1,1)=PAR.ECO.FORMA.type;
A(1,2)=PAR.ECO.FORMA.parest1;
A(1,3)=PAR.ECO.FORMA.parest2;
[B]=pdf(A, DADOS);
PAR.ECO.Custo_forV=B;   %R$/m2

A(1,1)=PAR.ECO.CONC.type;
A(1,2)=PAR.ECO.CONC.parest1;
A(1,3)=PAR.ECO.CONC.parest2;
[B]=pdf(A, DADOS);
PAR.ECO.Custo_concV=B;  %R$/m3

A(1,1)=PAR.ECO.ACO.type;
A(1,2)=PAR.ECO.ACO.parest1;
A(1,3)=PAR.ECO.ACO.parest2;
[B]=pdf(A, DADOS);
PAR.ECO.Custo_acoV=B;   %R$/kg

A(1,1)=PAR.ECO.TXATRAT.type;
A(1,2)=PAR.ECO.TXATRAT.parest1;
A(1,3)=PAR.ECO.TXATRAT.parest2;
PAR.ECO.txatrat=B;