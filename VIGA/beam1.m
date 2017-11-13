function [ARRANJOtrac, ARRANJOcomp]=beam1(Astrac, Ascomp, VIGA, posbitolatrac, posbitolacomp)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCI�NCIAS
% PROGRAMA DE P�S-GRADUA��O EM ENGENHARIA CIVIL        - �REA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELE��O DE  M�DIA FIDELIDADE  PARA  AN�LISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO.
% ALUNO       S�rgio Jos� Priori Jovino Marques Filho
% ORIENTADOR  Prof. �zio da Rocha Ara�jo
% -------------------------------------------------------------------------
% DESCRI��O
% Rotina para definir a quantidade de barras e a bitola das barras de a�o
% na se��o das vigas, arranjo das barras. O algoritmo define o arranjo das 
% das armaduras(VIGA.TABELALONG).
% -------------------------------------------------------------------------
% MODIFICA��ES:         
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: Astrac, Ascomp, VIGA, posbitolatrac, posbitolacomp
% VARI�VEIS DE SA�DA:   ARRANJOtrac, ARRANJOcomp - arranjo das barras
% tracionadas e comprimidas, respectivamente.
%--------------------------------------------------------------------------
% CRIADA EM 30-junho-2015
% -------------------------------------------------------------------------

% Determina��o do arranjo das armaduras de tra��o
bitola=VIGA.TABELALONG(posbitolatrac);     % bitola das barras que ir�o compor o arranjo
Abarra=pi*(bitola*10^-3)^2/4;
nbarrastrac=ceil(Astrac/Abarra);         % quantidade de barras no arranjo de tra�c�o

ARRANJOtrac(1)=nbarrastrac;
ARRANJOtrac(2)=bitola;

bitola=VIGA.TABELALONG(posbitolacomp);     % bitola das barras que ir�o compor o arranjo
Abarra=pi*(bitola*10^-3)^2/4;
nbarrascomp=ceil(Ascomp/Abarra);         % quantidade de barras no arranjo de tra�c�o

ARRANJOcomp(1)=nbarrascomp;
ARRANJOcomp(2)=bitola;

end