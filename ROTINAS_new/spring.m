function [PORTICO]=spring(DD, PORTICO)
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
% Função para armazenar as constantes de mola de cada elemento de barra.
% -------------------------------------------------------------------------
% Criada      10-fevereiro-2017                 SÉRGIO MARQUES
% -------------------------------------------------------------------------
% Quantidade de nós com restrição
s=size(DD);
s=s(1);
% Quantidade de elementos conectados à molas de translação na dir. Y
elemspring=s/5;
% Criação matriz nula
PORTICO.springs=zeros(PORTICO.nnos,4);
for i=1:elemspring
    %PORTICO.springs(DD(5*(i-1)+1),1)=DD(5*(i-1)+1);
    PORTICO.springs(DD(5*(i-1)+1),1)=DD(5*(i-1)+2);
    PORTICO.springs(DD(5*(i-1)+1),2)=DD(5*(i-1)+3);
    PORTICO.springs(DD(5*(i-1)+1),3)=DD(5*(i-1)+4);
    PORTICO.springs(DD(5*(i-1)+1),4)=DD(5*(i-1)+5);
end
