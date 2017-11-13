function [ARRANJOLONGsup]=beam4(VIGA, VIGAin, al, trecho, ARRANJOLONGsup, bitola)
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
% Rotina para verificar a quantidade de armadura m�inima junto ao apoio
% -------------------------------------------------------------------------
% MODIFICA��ES:         
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: VIGAout
% VARI�VEIS DE SA�DA:   VIGAout: structure contendo os dados de sa�da da
% viga
%--------------------------------------------------------------------------
% CRIADA EM 29-janeiro-2016
% -------------------------------------------------------------------------

% Iremos utilizar o menor valor de de VIGAin.dinf de forma a garantir o
% maior valor de Rst.
dinf=max(VIGAin.dinf(bitola,:));

% Deterimna se o apoio da viga e o esquerdo ou direito. Se trecho=1, apoio
% esquerdo, se trecho=2, apoio esquerdo.
if trecho==1
    a=1;
else
    a=VIGAin.qntsecoes;
end

% Determina��o do esfor�o normal atuante - s� deve-se considerar esfor�os
% de tra��o
if VIGAin.N(a)>0
    N=VIGAin.N(a);
else
    N=0;
end

% C�lculo da for�a de tra��o que dever� ser resistida pela armadura de
% tra��o.
Rst=al(bitola)/dinf*abs(VIGAin.V(a))+N;

% C�lculo da armadura necess�ria para resitir � for�a de tra��o no apoio
Asrst=Rst/VIGAin.fyd;

% Determina��o da quantidade de barras no apoio
Abarra=pi*(VIGA.TABELALONG(bitola)/1000)^2/4;
nbarras=ceil(Asrst/Abarra);
ArmMinApoio(bitola,1)=nbarras;
ArmMinApoio(bitola,2)=VIGA.TABELALONG(bitola);

% C�lculo da �rea de a�o efetiva no apoio
Asefapoio=ARRANJOLONGsup(1,1,bitola)*Abarra;

% Verifica��o se a qnt de barras no apoio atende a qnt m�nima. Caso n�o 
% atenda, haver� a substitui��o.
if Asefapoio<Asrst
    nbarras=ceil(Asrst/Abarra);
    ARRANJOLONGsup(1,1,bitola)=nbarras;
end