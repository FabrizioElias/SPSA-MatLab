function [VIGA, PILAR, DADOS]=Classifica_elem(DADOS, PORTICO, ELEMENTOS, VIGA, PILAR)
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
% Nessa rotina os elementos, que encontravam-se em uma unica matriz 
% (ELEMENTOS.secao) s�o classificados em vigas ou pilares, conforme o 
% �ngulo que cada um faz com a horizontal (PORTICO.teta).
% -------------------------------------------------------------------------
% Criada      15-abril-2016                 S�RGIO MARQUES
% Modificada  12-fevereiro-2017             S�RGIO MARQES
% -------------------------------------------------------------------------
% MODIFICA��O
% Rotina classifica apenas os elementos de cocnreto armado. Os elementos
% met�licos, estaueamento, n�o s�o classificados.
% Inicializa contadores
viga=1;
pilar=1;

for i=1:PORTICO.nelem
    if ELEMENTOS.material(i)==1
        if PORTICO.teta(i)==0
            VIGA.elemento(viga)=i;  % Armazena o n�mero do elemento do p�rtico original
            VIGA.bvm(viga)=ELEMENTOS.secao(i,1);
            VIGA.hvm(viga)=ELEMENTOS.secao(i,2);
            VIGA.sigma_bv(viga)=ELEMENTOS.dp(i,1);
            VIGA.sigma_hv(viga)=ELEMENTOS.dp(i,2);
            viga=viga+1;
        else
            PILAR.elemento(pilar)=i;  % Armazena o n�mero do elemento do p�rtico original
            PILAR.hpxm(pilar)=ELEMENTOS.secao(i,1);
            PILAR.hpym(pilar)=ELEMENTOS.secao(i,2);
            PILAR.sigma_hpx(pilar)=ELEMENTOS.dp(i,1);
            PILAR.sigma_hpy(pilar)=ELEMENTOS.dp(i,2);
            pilar=pilar+1;
        end
    end
end
% C�lculo da quantidade de vigas
DADOS.Nvigas=viga-1;
% C�lculo da quantidade de pilares
DADOS.Npilares=pilar-1;