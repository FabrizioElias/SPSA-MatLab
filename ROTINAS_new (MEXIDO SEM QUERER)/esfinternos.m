function [cortante, momento, normal, transx, transz, rotacao]=esfinternos(PORTICO, ELEMENTOS, KEST, KELEM,...
        ROT, F, fe, gdle, CARREGAMENTO, D)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIÊNCIAS
% PROGRAMA DE PÓS-GRADUAÇÃO EM ENGENHARIA CIVIL        - ÁREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELEÇÃO DE  MÉDIA FIDELIDADE  PARA  ANÁLISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO.
% ALUNA       Sérgio José Priori Jovino Marques Filho
% ORIENTADOR  Prof. Ézio da Rocha Araújo
% -------------------------------------------------------------------------
% DESCRIÇÃO
% Rotina para cálculo do esforço normal nos elementos estruturais
% -------------------------------------------------------------------------
% MODIFICAÇÕES:         Modificada em 16/05/2015
%--------------------------------------------------------------------------
% VARIÁVEIS DE ENTRADA: PORTICO, ELEMENTOS, DADOS
% VARIÁVEIS DE SAÍDA:   esf: esforços nodais obtidos à partir do método dos
%                       deslocamentos
%                       CORTANTE, MOMENTO: esforços internos nos elementos
%                       do pórtico.
%--------------------------------------------------------------------------
% CRIADA EM 13-Janeiro-2015
% -------------------------------------------------------------------------

% Resolve o sistema de equações
[esf, xg]=solver(KEST, F, fe, PORTICO, gdle, KELEM, ROT);
s=size(D);
normal=cell(s(1),1);
cortante=cell(s(1),1);
momento=cell(s(1),1);
transx=cell(s(1),1);
transz=cell(s(1),1);
rotacao=cell(s(1),1);
% Calcula o esforço axial nas barras
N=axial(PORTICO, ELEMENTOS, esf, CARREGAMENTO);
for i=1:s(1)
    normal{i,:}=N(D(i,1):D(i,2),1)';
    tamanho=size(normal{i,:});
    normal{i}(1,tamanho(2)+1)=N(D(i,2),2);
end
% Calcula o esforço cortante nas barras
V=shear(PORTICO, ELEMENTOS, esf,CARREGAMENTO);
for i=1:s(1)
    cortante{i,:}=V(D(i,1):D(i,2),1)';
    tamanho=size(cortante{i,:});
    cortante{i}(1,tamanho(2)+1)=V(D(i,2),2);
end
% Calcula o momento fletor nas barras
M=bend(PORTICO, ELEMENTOS, esf,CARREGAMENTO);
for i=1:s(1)
    momento{i,:}=M(D(i,1):D(i,2),1)';
    tamanho=size( momento{i,:});
    momento{i}(1,tamanho(2)+1)=M(D(i,2),2);
end
% Armazena os deslocamentos em X 
for i=1:s(1)
    transx{i,:}=xg(1,D(i,1):D(i,2));
    tamanho=size(transx{i,:});
    transx{i}(1,tamanho(2)+1)=xg(4,D(i,2));
end
% Armazena os deslocamentos em Y
for i=1:s(1)
    transz{i,:}=xg(2,D(i,1):D(i,2));
    tamanho=size(transz{i,:});
    transz{i}(1,tamanho(2)+1)=xg(5,D(i,2));
end
% Armazena as rotações
for i=1:s(1)
    rotacao{i,:}=xg(3,D(i,1):D(i,2));
    tamanho=size(rotacao{i,:});
    rotacao{i}(1,tamanho(2)+1)=xg(6,D(i,2));
end
