function flag = checkbarrier(X)
% CHECKBARRIER: Verifica se X atende a regiao viável.
% --------------------------------------------------------------------------
% flag = checkbarrier(X)
%
% flag     -  flag da regiao viável                                    (out)
%             (0 - atende ; 1 - nao atende)
%
% X        -  parametros                                                (in)
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
% Criado:        16-Mai-2006      Diego Oliveira
%
% Moficaçao:
% --------------------------------------------------------------------------
% Definicoes
% Opcoes
global op_PI;
% Dados e Controladores
global NPar;
global NWell_P;
global NWell_I;
global Ntempos;
global Xmin Xmax;
global facmin facmaxP facmaxI;

flag=0;
minX=min(X,Xmin);
maxX=max(X,Xmax);
%-------------------------------------
% Limites
%-------------------------------------
for k=1:NPar
    if (minX(k)<Xmin) | (maxX(k)>Xmax)
        flag=1;
        break;
    end;
end
%-------------------------------------
% Soma < 100
%-------------------------------------
for k=0:(Ntempos-1)
  if flag==1;break;end;
  %Produtores
  if op_PI==1
    inicio=1+k*(NWell_P-1);
    final =inicio+(NWell_P-2);
    soma=sum(X(inicio:final));
    if soma>100 | soma<(100-facmaxP)
        flag=1;
        break;
    end;
  end
  %Injetores
  if op_PI==2
    inicio=1+k*(NWell_I-1);
    final =inicio+(NWell_I-2);
    soma=sum(X(inicio:final));
    if soma>100 | soma<(100-facmaxI)
        flag=1;
        break;
    end;
  end
  %Produtores e Injetores
  if op_PI==3
    inicio=1+k*(NWell_P-1+NWell_I-1);
    final =inicio+(NWell_P-2);
    soma=sum(X(inicio:final));
    if soma>100 | soma<(100-facmaxP)
        flag=1;
        break;
    end;
    inicio=final+1;
    final =inicio+(NWell_I-2);
    soma=sum(X(inicio:final));
    if soma>100 | soma<(100-facmaxI)
        flag=1;
        break;
    end;
  end
end
