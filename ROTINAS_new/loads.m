function [PORTICO]=loads(DADOS, PORTICO)
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
if PORTICO.qntelemcargadisty~=0
    C=[PORTICO.cargadistyPDF' PORTICO.cargadisty' PORTICO.cargadistyParEst1' PORTICO.cargadistyParEst2'];
    s=size(C);
    s=s(1);
    for i=1:s
        A=C(i,:);
        [B]=pdf(A, DADOS);
        PORTICO.cargadistyV(1,i,:)=B;
    end
end

% Cargas ditribuídas - direção x local
if PORTICO.qntelemcargadistx~=0
    C=[PORTICO.cargadistxPDF' PORTICO.cargadistx' PORTICO. cargadistxParEst1' PORTICO. cargadistxParEst2'];
    s=size(C);
    s=s(1);
    for i=1:s
        A=C(i,:);
        [B]=pdf(A, DADOS);
        for j=1:DADOS.NMC
            PORTICO.cargadistxV(1,i,j)=B(j);
        end 
    end
end

% FALTA FAZER A AMOSTRAAGEM PARA AS CARGAS CONCENTRADAS E CARGAS NODAIS
    