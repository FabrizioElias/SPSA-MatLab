%FAB - Otimiza��o da assiantura do m�todo.
%function [lbnecVante, lbnecRe, Abarra]=beam9(VIGAin, AsCalculadoInf ,ARRANJOLONGinf, bitola, lbnecRe,...
%   lbnecVante, Abarra)
function [lbnecVante, lbnecRe, Abarra]=beam9(VIGAin, AsCalculadoInf ,ARRANJOLONGinf)
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
% Rotina para calcular o comprimento de ancoragem das barras positivas.
% Faz-se necess�ria uma nova rotina, diferente daquela utilizada para o
% c�lculodas ancoragens para barras negativas devido a pequenas diferen�as.
% -------------------------------------------------------------------------
% MODIFICA��ES:         
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: VIGAout
% VARI�VEIS DE SA�DA:   VIGAout: structure contendo os dados de sa�da da
% viga
%--------------------------------------------------------------------------
% CRIADA EM 26-janeiro-2016
% -------------------------------------------------------------------------

% �rea de a�o calculada
Ascalc=AsCalculadoInf;
% C�lculo do comprimento b�sico de ancoragem
lb=ARRANJOLONGinf(1, 2)*VIGAin.fyd/(4*VIGAin.fbd)/1000;
Abarra=pi*(ARRANJOLONGinf(1,2)*10^-3)^2/4;
Asef=ARRANJOLONGinf(1,1)*Abarra;  

% Ancoragem � vante - sem gancho
alfa1=1;
lbnecVante=alfa1*lb*max((Ascalc./Asef));

% Ancoragem � r� - aqui ser� considerado que a ancoragem � r� ser� feita
% utilizando ganchos. Assim, o comprimento de ancoragem final lbnecRe ser�
% calculado considerando o comprimento do gancho junto com o comprimento da
% curva. Vide Chsut, vol 1 p�g 215 a 217
alfa1=0.7;
diambarra=ARRANJOLONGinf(1,2)/1000;  % Divis�o por 1000 p/ trans. em metros
if diambarra<0.2
    diampino=5*diambarra;
else
    diampino=8*diambara;
end
Lre=max(alfa1*lb*(Ascalc./Asef));
% A vari�vel lbnecRe considera o raio da dobra do pino e o comprimento do
% gancho.
lbnecRe=Lre-(diampino/2+diambarra)+pi*(diampino/2+diambarra)/4+8*diambarra;