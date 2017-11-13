function [PAR]=parconcTD(DADOS, PAR)
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
% Função irá ler os parâmetros do concreto dependentes do tempo
% -------------------------------------------------------------------------
% Criada      20-abril-2017                 SÉRGIO MARQUES
% -------------------------------------------------------------------------

fidparconcTD=fopen(DADOS.fileparconcTD,'r');
while ~feof (fidparconcTD)
    for k=1:3
        lixo=fgets(fidparconcTD);
    end
    % Armazena em uma matriz coluna todos os dados referentes às
    % propriedades do concreto
    var=fscanf(fidparconcTD,'%f');
end
% Fecha o arquivo de dados  referente aos parâmetros do concreto
fclose(fidparconcTD);
% Escreve na estrutura PAR as propriedades e parâmetros de distribuição do
% cocnreto.
% Resistência à compressão
PAR.CONCTD.t0=var(1);
PAR.CONCTD.alfa=var(2);
PAR.CONCTD.deltati=var(3);
PAR.CONCTD.Tdeltati=var(4);
PAR.CONCTD.RH=var(5);
PAR.CONCTD.ts=var(6);
PAR.CONCTD.alfas=var(7);
PAR.CONCTD.alfas1=var(8);
PAR.CONCTD.alfas2=var(9);
PAR.CONCTD.betasc=var(10);
PAR.CONCTD.t=var(11);