function [VIGA, PILAR, DADOS]=ClassificaElem(DADOS, PORTICO, ELEMENTOS, VIGA, PILAR)
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
% Nessa rotina os elementos, que encontravam-se em uma unica matriz 
% (ELEMENTOS.secao) são classificados em vigas ou pilares, conforme o 
% ângulo que cada um faz com a horizontal (PORTICO.teta).
% -------------------------------------------------------------------------
% Criada      15-abril-2016                 SÉRGIO MARQUES
% Modificada  12-fevereiro-2017             SÉRGIO MARQES
% -------------------------------------------------------------------------
% MODIFICAÇÃO
% Rotina classifica apenas os elementos de cocnreto armado. Os elementos
% metálicos, estaueamento, não são classificados.
% Inicializa contadores
viga=1;
pilar=1;

for i=1:PORTICO.nelem
    if ELEMENTOS.material(i)==1
        if PORTICO.teta(i)==0
            VIGA.elemento(viga)=i;  % Armazena o número do elemento do pórtico original
            VIGA.A(viga)=ELEMENTOS.A(i,1);
            VIGA.I(viga)=ELEMENTOS.I(i,1);
            VIGA.sigma_A(viga)=ELEMENTOS.dp(i,1);
            VIGA.sigma_I(viga)=ELEMENTOS.dp(i,2);
            viga=viga+1;
        else
            PILAR.elemento(pilar)=i;  % Armazena o número do elemento do pórtico original
            PILAR.A(pilar)=ELEMENTOS.A(i,1);
            PILAR.I(pilar)=ELEMENTOS.I(i,1);
            PILAR.sigma_A(pilar)=ELEMENTOS.dp(i,1);
            PILAR.sigma_I(pilar)=ELEMENTOS.dp(i,2);
            pilar=pilar+1;
        end
    end
end
% Cálculo da quantidade de vigas
DADOS.Nvigas=viga-1;
% Cálculo da quantidade de pilares
DADOS.Npilares=pilar-1;