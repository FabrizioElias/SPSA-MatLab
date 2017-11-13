function [Astrac, Ascomp]=beam0(momento, VIGAin, sec, bitola)
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
% Rotina para dimensionamento � flex�o da se��o da viga. Ao final do
% processamento da rotina, a �rea de a�o � determinada.
% -------------------------------------------------------------------------
% MODIFICA��ES:         
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: momento, VIGAin, sec, bitola
% VARI�VEIS DE SA�DA:   Astrac, Ascomp - �rea de a�o tracionada e
% comprimida, respectivamente.
%--------------------------------------------------------------------------
% CRIADA EM 18-agosto-2015
% -------------------------------------------------------------------------
% DIMENSIONAMENTO � FLEX�O
% Determina��o do momento adimensional e alongamento da armadura
momento=abs(momento);
mi=momento/(VIGAin.b*VIGAin.dinf(bitola, sec)^2*VIGAin.sigmafcd);       % momento adimensional
%FAB - Remo��o de vari�vel sem uso.
%epsy=VIGAin.fyd/VIGAin.Es;                                      % def. espec�fica da armadura
qsilim=0.45;
milim=0.8*qsilim*(1-0.4*qsilim);                                % momento adimensional limite

% Determina��o da �rea de a�o da armadura de tra��o
delta=VIGAin.dsup/VIGAin.dinf(sec);
qsi=1.25*(1-(1-2*mi)^0.5);
if mi<=milim
    Astrac=0.8*qsi*VIGAin.b*VIGAin.dinf(bitola, sec)*VIGAin.sigmafcd/VIGAin.fyd;
    Ascomp=0;
else
    Astrac=(VIGAin.b*VIGAin.dinf(bitola, sec)*VIGAin.sigmafcd/VIGAin.fyd*(0.8*qsilim+(mi-milim)/(1-delta)));
    Ascomp=VIGAin.b*VIGAin.dinf(bitola, sec)*VIGAin.sigmafcd*(mi-milim)/((1-delta)*VIGAin.fyd);   
end

% Compara��o com a armadura m�nima
Astrac=max(Astrac,VIGAin.Astracmin);
  
end