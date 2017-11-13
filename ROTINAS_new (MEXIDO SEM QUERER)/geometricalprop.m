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

% Os vetores ELEMENTOS.AV e ELEMENTOS.IV servem para armazenar os valores
% aleatórios das área e momento de inércia. Caso o esteja sendo efetuada
% uma análise determnística, esse vetor será preenchido com os valores
% fornecidos na entrada de dados.

if DADOS.op_exec==0
    ELEMENTOS.AV=ELEMENTOS.A;
    ELEMENTOS.IV=ELEMENTOS.I;
else
    ELEMENTOS.AV=zeros(PORTICO.nelem,1,DADOS.NMC);
    ELEMENTOS.IV=zeros(PORTICO.nelem,1,DADOS.NMC);
    for i=1:PORTICO.nelem
        norm=randn(1,DADOS.NMC);
        area=ELEMENTOS.A(i,:);
        inercia=ELEMENTOS.I(i,:);
        a=ELEMENTOS.dp(i,:);
        for j=1:DADOS.NMC
            ELEMENTOS.AV(i,1,j)=area+a(1,1)*norm(j);
            ELEMENTOS.IV(i,1,j)=inercia+a(1,2)*norm(j);
        end
    end
end


    
    