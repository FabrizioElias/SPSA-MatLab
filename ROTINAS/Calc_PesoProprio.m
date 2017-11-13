%FAB - Otimização da assinatura do método.
%function [ELEMENTOS]=Calc_PesoProprio(PORTICO, ELEMENTOS, PAR, DADOS)
function [ELEMENTOS]=Calc_PesoProprio(PORTICO, ELEMENTOS, PAR)
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
% Calcula o peso próprio atuante nos elementos estruturais. Essa rotina foi
% retirada da rotina Calc_geom.
% -------------------------------------------------------------------------
% Criada      12-fevereiro-2017                 SÉRGIO MARQUES
% -------------------------------------------------------------------------

global m

for i=1:PORTICO.nelem
    if ELEMENTOS.material(i)==1
        ELEMENTOS.ro(i)=PAR.CONC.rocV(m);
    elseif ELEMENTOS.material(i)==2
        ELEMENTOS.ro(i)=PAR.STEEL.rosV(m);
    end
end
        
PP=ELEMENTOS.A.*ELEMENTOS.ro;
for i=1:PORTICO.nelem
    % Eixo x local fazendo um ângulo entre 0 e 90 graus com o eixo X global
    if PORTICO.teta(i)>=0 && PORTICO.teta(i)<(pi)/2
        ELEMENTOS.ppy(i)=-PP(i)*cos(PORTICO.teta(i));
        ELEMENTOS.ppx(i)=-PP(i)*sin(PORTICO.teta(i));
    end
    % Eixo x local fazendo um ângulo entre 90 e 180 com o eixo X global
    if PORTICO.teta(i)>=(pi)/2 && PORTICO.teta(i)<(pi)
        beta=PORTICO.teta(i)-(pi)/2;
        ELEMENTOS.ppy(i)=PP(i)*sin(beta);
        ELEMENTOS.ppx(i)=-PP(i)*cos(beta);
    end
    % Eixo x local fazendo um ângulo entre 180 e 270 com o eixo X global
    if PORTICO.teta(i)>=-(pi) && PORTICO.teta(i)<-(pi)/2
        teta=abs(PORTICO.teta(i));
        beta=teta-(pi)/2;
        ELEMENTOS.ppy(i)=PP(i)*sin(beta);
        ELEMENTOS.ppx(i)=PP(i)*cos(beta);
    end
    % Eixo x local fazendo um ângulo entre 270 e 360 com o eixo X global
    if PORTICO.teta(i)>=-(pi)/2 && PORTICO.teta(i)<0
        teta=abs(PORTICO.teta(i));
        ELEMENTOS.ppy(i)=PP(i)*sen(teta);
        ELEMENTOS.ppx(i)=-PP(i)*cos(teta);
    end
end