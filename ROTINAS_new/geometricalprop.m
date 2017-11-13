function [ELEMENTOS]=geometricalprop(DADOS, ELEMENTOS, PORTICO)
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
% Calcula os parâmetros geométricos da seção transversal dos elmentos.
% -------------------------------------------------------------------------
% Criada      26-abril-2016                 SÉRGIO MARQUES
% -------------------------------------------------------------------------

ELEMENTOS.secaoV=zeros(PORTICO.nelem,4,DADOS.NMC);
for i=1:PORTICO.nelem
    norm=randn(1,DADOS.NMC);
    secao=ELEMENTOS.secao(i,:);
%     secao=ELEMENTOS.secaoINICIAL(i,:);
    a=ELEMENTOS.dp(i,:);

    for j=1:DADOS.NMC
        ELEMENTOS.secaoV(i,1,j)=secao(1,1)+a(1,1)*norm(j);
        ELEMENTOS.secaoV(i,2,j)=secao(1,2)+a(1,2)*norm(j);
        ELEMENTOS.secaoV(i,3,j)=secao(1,3)+a(1,3)*norm(j);
        ELEMENTOS.secaoV(i,4,j)=secao(1,4)+a(1,4)*norm(j);
    end
end


    
    