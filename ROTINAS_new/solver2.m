function [esf]=solver2(KEST, F, fe, PORTICO, gdle, KELEM, ROT)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCI�NCIAS
% PROGRAMA DE P�S-GRADUA��O EM ENGENHARIA CIVIL        - �REA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELE��O DE  M�DIA FgdleIDELIDADE  PARA  AN�LISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO.
% ALUNA       S�rgio Jos� Priori Jovino Marques Filho
% ORIENTADOR  Prof. �zio da Rocha Ara�jo
% -------------------------------------------------------------------------
% DESCRI��O
% Processa o p�rtico plano a partir dos dados de entrada 
% -------------------------------------------------------------------------
% MODIFICA��ES:         Modificada em 16/05/2015
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: PORTICO, ELEMENTOS, DADOS
% VARI�VEIS DE SA�DA:   esf: esfor�os nodais obtidos � partir do m�todo dos
%                       deslocamentos
%--------------------------------------------------------------------------
% CRIADA EM 13-Janeiro-2015
% -------------------------------------------------------------------------

% 3 - RESOLU��O DO SISTEMA DE EQUA��ES
x=KEST^(-1)*F';

% 4 - DETERMINA��O DOS ESFOR�OS INTERNOS
% 4.1 - Extra��o dos deslocamentos nas extremidades dos elementos

xg = zeros(6,PORTICO.nelem);
for n=1:6
    for i=1:PORTICO.nelem
        k=gdle(i,n);
        if k>0
            xg(n,i)=x(k);
        end
    end
end

% 4.2 - Esfor�os finais em cada elemento
esf=zeros(6,PORTICO.nelem);
for i=1:PORTICO.nelem
    esf(:,i)=fe(:,i)+KELEM(:,:,i)*ROT(:,:,i)'*xg(:,i);
end