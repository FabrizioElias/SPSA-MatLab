function [ELEMENTOS]=geometricalprop(DADOS, ELEMENTOS, PORTICO)
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
% Calcula os par�metros geom�tricos da se��o transversal dos elmentos.
% -------------------------------------------------------------------------
% Criada      26-abril-2016                 S�RGIO MARQUES
% -------------------------------------------------------------------------

ELEMENTOS.secaoV=zeros(PORTICO.nelem,4,DADOS.NMC);
ELEMENTOS.AV=zeros(PORTICO.nelem,1,DADOS.NMC);
ELEMENTOS.IV=zeros(PORTICO.nelem,1,DADOS.NMC);

if DADOS.op_exec==0
    ELEMENTOS.AV=ELEMENTOS.A;
    ELEMENTOS.IV=ELEMENTOS.I;
else
    for i=1:PORTICO.nelem
        norm=randn(1,DADOS.NMC);
        secao=ELEMENTOS.secao(i,:);
        %     secao=ELEMENTOS.secaoINICIAL(i,:);
        a=ELEMENTOS.dp(i,:);

        for j=1:DADOS.NMC
            ELEMENTOS.secaoV(i,1,j)=secao(1,1)+a(1,1)*norm(j);  % tw - espessura da mesa
            ELEMENTOS.secaoV(i,2,j)=secao(1,2)+a(1,2)*norm(j);  % h - altura total
            ELEMENTOS.secaoV(i,3,j)=secao(1,3)+a(1,3)*norm(j);  % bf - largura da mesa
            ELEMENTOS.secaoV(i,4,j)=secao(1,4)+a(1,4)*norm(j);  % tf - espessura da mesa
            % PROPRIEDADES GEOM�TRICAS DA SE��O
            if PORTICO.elemestrutural(i)==1 || PORTICO.elemestrutural(i)==3
                ELEMENTOS.AV(i,1,j)=2*(ELEMENTOS.secaoV(i,3,j)*ELEMENTOS.secaoV(i,4,j))+ELEMENTOS.secaoV(i,1,j)*(ELEMENTOS.secaoV(i,2,j)-2*ELEMENTOS.secaoV(i,4,j));
                ELEMENTOS.IV(i,1,j)=2*(ELEMENTOS.secaoV(i,4,j)*ELEMENTOS.secaoV(i,3,j)^3/12)+(ELEMENTOS.secaoV(i,2,j)-2*ELEMENTOS.secaoV(i,4,j))*ELEMENTOS.secaoV(i,1,j)^3/12;
            % N�o calcula per�metro efetivo, n�o usa para nada
            elseif PORTICO.elemestrutural(i)==2 || PORTICO.elemestrutural(i)==4
                ELEMENTOS.AV(i,1,j)=ELEMENTOS.secaoV(i,1,j)*ELEMENTOS.secaoV(i,2,j);
                ELEMENTOS.IV(i,1,j)=ELEMENTOS.secaoV(i,1,j)*ELEMENTOS.secaoV(i,2,j)^3/12;
            % N�o calcula per�metro  efetivo, n�o usa para nada
            elseif PORTICO.elemestrutural(i)==5 || PORTICO.elemestrutural(i)==6 || PORTICO.elemestrutural(i)==7
                ELEMENTOS.AV(i,1,j)=ELEMENTOS.secaoV(i,1,j)*ELEMENTOS.secaoV(i,2,j);
                ELEMENTOS.IV(i,1,j)=ELEMENTOS.secaoV(i,1,j)*ELEMENTOS.secaoV(i,2,j)^3/12;
                ELEMENTOS.u(i,1,j)=9.37; % Dimens�o em mil�metro
            elseif PORTICO.elemestrutural(i)==8 || PORTICO.elemestrutural(i)==9
                ELEMENTOS.AV(i,1,j)=ELEMENTOS.secaoV(i,1,j)*ELEMENTOS.secaoV(i,2,j);
                ELEMENTOS.IV(i,1,j)=ELEMENTOS.secaoV(i,1,j)*ELEMENTOS.secaoV(i,2,j)^3/12;
            % N�o calcula per�metro  efetivo, n�o usa para nada
            end
        end
    end
end




    
    