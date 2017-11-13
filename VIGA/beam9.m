%FAB - Otimização da assiantura do método.
%function [lbnecVante, lbnecRe, Abarra]=beam9(VIGAin, AsCalculadoInf ,ARRANJOLONGinf, bitola, lbnecRe,...
%   lbnecVante, Abarra)
function [lbnecVante, lbnecRe, Abarra]=beam9(VIGAin, AsCalculadoInf ,ARRANJOLONGinf)
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
% Rotina para calcular o comprimento de ancoragem das barras positivas.
% Faz-se necessária uma nova rotina, diferente daquela utilizada para o
% cálculodas ancoragens para barras negativas devido a pequenas diferenças.
% -------------------------------------------------------------------------
% MODIFICAÇÕES:         
%--------------------------------------------------------------------------
% VARIÁVEIS DE ENTRADA: VIGAout
% VARIÁVEIS DE SAÍDA:   VIGAout: structure contendo os dados de saída da
% viga
%--------------------------------------------------------------------------
% CRIADA EM 26-janeiro-2016
% -------------------------------------------------------------------------

% Área de aço calculada
Ascalc=AsCalculadoInf;
% Cálculo do comprimento básico de ancoragem
lb=ARRANJOLONGinf(1, 2)*VIGAin.fyd/(4*VIGAin.fbd)/1000;
Abarra=pi*(ARRANJOLONGinf(1,2)*10^-3)^2/4;
Asef=ARRANJOLONGinf(1,1)*Abarra;  

% Ancoragem à vante - sem gancho
alfa1=1;
lbnecVante=alfa1*lb*max((Ascalc./Asef));

% Ancoragem à ré - aqui será considerado que a ancoragem à ré será feita
% utilizando ganchos. Assim, o comprimento de ancoragem final lbnecRe será
% calculado considerando o comprimento do gancho junto com o comprimento da
% curva. Vide Chsut, vol 1 pág 215 a 217
alfa1=0.7;
diambarra=ARRANJOLONGinf(1,2)/1000;  % Divisão por 1000 p/ trans. em metros
if diambarra<0.2
    diampino=5*diambarra;
else
    diampino=8*diambara;
end
Lre=max(alfa1*lb*(Ascalc./Asef));
% A variável lbnecRe considera o raio da dobra do pino e o comprimento do
% gancho.
lbnecRe=Lre-(diampino/2+diambarra)+pi*(diampino/2+diambarra)/4+8*diambarra;