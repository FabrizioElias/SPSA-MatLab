function [esf]=solver2(KEST, F, fe, PORTICO, gdle, KELEM, ROT)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIÊNCIAS
% PROGRAMA DE PÓS-GRADUAÇÃO EM ENGENHARIA CIVIL        - ÁREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELEÇÃO DE  MÉDIA FgdleIDELIDADE  PARA  ANÁLISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO.
% ALUNA       Sérgio José Priori Jovino Marques Filho
% ORIENTADOR  Prof. Ézio da Rocha Araújo
% -------------------------------------------------------------------------
% DESCRIÇÃO
% Processa o pórtico plano a partir dos dados de entrada 
% -------------------------------------------------------------------------
% MODIFICAÇÕES:         Modificada em 16/05/2015
%--------------------------------------------------------------------------
% VARIÁVEIS DE ENTRADA: PORTICO, ELEMENTOS, DADOS
% VARIÁVEIS DE SAÍDA:   esf: esforços nodais obtidos à partir do método dos
%                       deslocamentos
%--------------------------------------------------------------------------
% CRIADA EM 13-Janeiro-2015
% -------------------------------------------------------------------------

% 3 - RESOLUÇÃO DO SISTEMA DE EQUAÇÕES
x=KEST^(-1)*F';

% 4 - DETERMINAÇÃO DOS ESFORÇOS INTERNOS
% 4.1 - Extração dos deslocamentos nas extremidades dos elementos

xg = zeros(6,PORTICO.nelem);
for n=1:6
    for i=1:PORTICO.nelem
        k=gdle(i,n);
        if k>0
            xg(n,i)=x(k);
        end
    end
end

% 4.2 - Esforços finais em cada elemento
esf=zeros(6,PORTICO.nelem);
for i=1:PORTICO.nelem
    esf(:,i)=fe(:,i)+KELEM(:,:,i)*ROT(:,:,i)'*xg(:,i);
end