%FAB - Otimização da assinatura da função.
%function ELEMENTOS = assignsections(ELEMENTOS, PILAR, VIGA, secao, ESTRUTURAL)
function ELEMENTOS = assignsections(ELEMENTOS, ~, ~, secao, ESTRUTURAL)
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
% Rotina para inserir os valores da geometria dos elementos estruturais na
% struture ELEMENTOS.

% -------------------------------------------------------------------------
% Criada      25-julho-2016              SÉRGIO MARQUES
% -------------------------------------------------------------------------

s=size(ESTRUTURAL.D);
s=s(1);
for i=1:s
    di=ESTRUTURAL.D(i,1);
    df=ESTRUTURAL.D(i,2);
    %FAB - Troca de [di:df] po di:df.
    ELEMENTOS.secao(di:df,1)=secao(2*(i-1)+1);
    ELEMENTOS.secao(di:df,2)=secao(2*(i-1)+2);
end



% % Alteração dos valores da geometria da seção transversal das vigas
% s=size(VIGA.elemento);
% numvigas=s(2);
% s=size(PILAR.elemento);
% numpilares=s(2);
% VIGAbase=secao(1:numvigas)';
% VIGAaltura=secao(1+numvigas:2*numvigas)';
% PILARhpx=secao(2*numvigas+1:2*numvigas+numpilares)';
% PILARhpy=secao(2*numvigas+numpilares+1:2*(numvigas+numpilares))';
% 
% for i=1:numvigas
%     ELEMENTOS.secao(VIGA.elemento(i),1)=VIGAbase(i);
%     ELEMENTOS.secao(VIGA.elemento(i),2)=VIGAaltura(i);
% end
% 
% % Alteração dos valores da geometria da seção transversal dos pilares
% s=size(PILAR.elemento);
% numpilares=s(2);
% for i=1:numpilares
%     ELEMENTOS.secao(PILAR.elemento(i),1)=PILARhpx(i);
%     ELEMENTOS.secao(PILAR.elemento(i),2)=PILARhpy(i);
% end