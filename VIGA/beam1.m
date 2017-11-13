function [ARRANJOtrac, ARRANJOcomp]=beam1(Astrac, Ascomp, VIGA, posbitolatrac, posbitolacomp)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIÊNCIAS
% PROGRAMA DE PÓS-GRADUAÇÃO EM ENGENHARIA CIVIL        - ÁREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELEÇÃO DE  MÉDIA FIDELIDADE  PARA  ANÁLISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO.
% ALUNO       Sérgio José Priori Jovino Marques Filho
% ORIENTADOR  Prof. Ézio da Rocha Araújo
% -------------------------------------------------------------------------
% DESCRIÇÃO
% Rotina para definir a quantidade de barras e a bitola das barras de aço
% na seção das vigas, arranjo das barras. O algoritmo define o arranjo das 
% das armaduras(VIGA.TABELALONG).
% -------------------------------------------------------------------------
% MODIFICAÇÕES:         
%--------------------------------------------------------------------------
% VARIÁVEIS DE ENTRADA: Astrac, Ascomp, VIGA, posbitolatrac, posbitolacomp
% VARIÁVEIS DE SAÍDA:   ARRANJOtrac, ARRANJOcomp - arranjo das barras
% tracionadas e comprimidas, respectivamente.
%--------------------------------------------------------------------------
% CRIADA EM 30-junho-2015
% -------------------------------------------------------------------------

% Determinação do arranjo das armaduras de tração
bitola=VIGA.TABELALONG(posbitolatrac);     % bitola das barras que irão compor o arranjo
Abarra=pi*(bitola*10^-3)^2/4;
nbarrastrac=ceil(Astrac/Abarra);         % quantidade de barras no arranjo de traçcão

ARRANJOtrac(1)=nbarrastrac;
ARRANJOtrac(2)=bitola;

bitola=VIGA.TABELALONG(posbitolacomp);     % bitola das barras que irão compor o arranjo
Abarra=pi*(bitola*10^-3)^2/4;
nbarrascomp=ceil(Ascomp/Abarra);         % quantidade de barras no arranjo de traçcão

ARRANJOcomp(1)=nbarrascomp;
ARRANJOcomp(2)=bitola;

end