function ELEMENTOS = assignsections(ELEMENTOS, PILAR, secao, ESTRUTURAL)
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
% Rotina para inserir os valores da geometria dos elementos estruturais na
% struture ELEMENTOS.

% -------------------------------------------------------------------------
% Criada      25-julho-2016              S�RGIO MARQUES
% -------------------------------------------------------------------------

% Altera��o dos valores da geometria da se��o transversal das vigas
% s=size(VIGA.elemento);
% numvigas=s(2);
s=size(PILAR.elemento);
numpilares=s(2);
vhpx=[1 3 5 7]; % <-- Vetor indicando quais elementos do vetor se��o dizem respeito a dimens�o da base do pilar;
vhpy=[2 4 6 8]; % <-- Vetor indicando quais elementos do vetor se��o dizem respeito a dimens�o da altura do pilar;
% VIGAbase=secao(1:numvigas)';
% VIGAaltura=secao(1+numvigas:2*numvigas)';
PILARhpx=secao(vhpx)';
PILARhpy=secao(vhpy)';

% for i=1:numvigas
%     ELEMENTOS.secao(VIGA.elemento(i),1)=VIGAbase(i);
%     ELEMENTOS.secao(VIGA.elemento(i),2)=VIGAaltura(i);
% end

% Altera��o dos valores da geometria da se��o transversal dos pilares
s=size(PILAR.elemento);
numpilares=s(2);
v=[2 7 8 9];    % <-- vetor contendo a "loca��o" dos pilares dentro do vetor ESTRUTURAL.D
s=size(v);
s=s(2);
for i=1:s
    d=ESTRUTURAL.D(v(i),:);
    dvec=[d(1):d(2)];
    ELEMENTOS.secao(dvec,1)=PILARhpx(i);
    ELEMENTOS.secao(dvec,2)=PILARhpy(i);
end




% s=size(ESTRUTURAL.D);
% s=s(1);
% for i=1:s
%     di=ESTRUTURAL.D(i,1);
%     df=ESTRUTURAL.D(i,2);
%     ELEMENTOS.secao([di:df],1)=secao(2*(i-1)+1);
%     ELEMENTOS.secao([di:df],2)=secao(2*(i-1)+2);
% end
