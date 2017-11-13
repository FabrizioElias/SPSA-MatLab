function [CARGASOLO]=loadsGAMB(DADOS, PORTICO)
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
% Rotina para fazer a amostragem dos carregamentos atuante nos elementos
% estruturais.
% -------------------------------------------------------------------------
% Criada      27-maio-2016                 SÉRGIO MARQUES
% -------------------------------------------------------------------------

% Cargas ditribuídas - direção y local
if PORTICO.qntdircarregadas~=0
    C=[PORTICO.carganodalPDF' PORTICO.carganodal'  PORTICO.carganodalParEst1'];
    s=size(C);
    s=s(1);
    for i=1:s
        A=C(i,:);
        [B]=pdfLOAD(C, DADOS, s);
        CARGASOLO=B;
    end
end

