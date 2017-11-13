function [Oleo_Produzido,Agua_Produzida,Agua_Injetada,tempo]=leitura_vpl(arq)
% LEITURA_VPL: devolve output file com as curvas de producao do ECLIPSE.
% --------------------------------------------------------------------------
% [Oleo_Produzido,Agua_Produzida,Agua_Injetada]=leitura_vpl(arq)
%
% arq             -  arquivo de dados                                  (in)
% Oleo_Produzido  -  producao de oleo                                  (out)
% Agua_Produzida  -  producao de agua                                  (out)
% Agua_Injetada   -  injecao de agua                                   (out)
% tempo           -  escala de tempo                                   (out)
% --------------------------------------------------------------------------
% -------------------------------------------------------------------------
% OTIMIZACAO DINAMICA DAS VAZOES DE PRODUCAO E INJECAO EM POCOS DE PETROLEO
% -------------------------------------------------------------------------
% Universidade Federal de Pernambuco
% Programa de Pos-Graduaçao Engenharia Civil / Estruturas
%
% Petrobras
% Centro de Pesquisas - CENPES
% 
% --------------------------------------------------------------------------
% Criado:        08-Nov-2005      Diego Oliveira
%
% Moficaçao:     
% --------------------------------------------------------------------------

if(nargin==0)
    file = input('Entre com Arquivo de Dados: ');
else
    file = arq;
end
[fid, msg] = fopen(file, 'r');
if (fid == -1)
  error(msg);
end
lido=fgetl(fid);
pos_old=ftell(fid);
cont=0;
while (~strcmp(lido,'FWPT (SM3)'))
    lido=fgetl(fid);
    if ((~strcmp(lido,''))&(~strcmp(lido,'FWPT (SM3)')))
        cont=cont+1;
        %leitura
        [tempo_op(cont),data_op(cont),Oleo_Produzido(cont)]=strread(lido,'%f%s%f');
    end
end
cont_op=cont;
cont=0;
while (~strcmp(lido,'FWIT (SM3)'))
    lido=fgetl(fid);
    if ((~strcmp(lido,''))&(~strcmp(lido,'FWIT (SM3)')))
        cont=cont+1;
        %leitura
        [tempo_wp(cont),data_wp(cont),Agua_Produzida(cont)]=strread(lido,'%f%s%f');
    end
end
cont_wp=cont;
cont=0;
while (~feof(fid))
    lido=fgetl(fid);
    if (~strcmp(lido,''))
        cont=cont+1;
        %leitura
        [tempo_wi(cont),data_wi(cont),Agua_Injetada(cont)]=strread(lido,'%f%s%f');
    end
end
cont_wi=cont;
fclose(fid);
tempo=tempo_op;
% Testes de ERROS
if (cont_op~=cont_wp)&(cont_op~=cont_wi)&(cont_wp~=cont_wi)
    error('dimensoes sao diferentes!');
end