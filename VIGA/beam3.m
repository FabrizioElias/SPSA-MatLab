function [al]=beam3(VIGAin, bitola)
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
% Rotina para c�lculo da decalagem do DMF.
% -------------------------------------------------------------------------
% MODIFICA��ES:         
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: VIGAin, bitola
% VARI�VEIS DE SA�DA:   al
%--------------------------------------------------------------------------
% CRIADA EM 07-novembro-2015
% -------------------------------------------------------------------------

% Iremos utilizar o maior valor de de VIGAin.dinf de forma a garantir o
% maior valor de al.
dinf=max(VIGAin.dinf(bitola,:));

% C�lculo da for�a de tra��o que a armadura de tra��o dever� resistir
Vsdmax=max(abs(VIGAin.V));                 % Esfor�o cortante m�ximo ao longo da viga
Vc=0.6*VIGAin.fctd*VIGAin.b*dinf;   	   % Parcela do esfor�o cortante absorvido por mecanismos adicionais da treli�a
alfa=VIGAin.alfa*pi/180;                   % �ngulo de inclina��o dos estribos 
al=dinf*(Vsdmax*(1+cot(alfa))/(2*(Vsdmax-Vc))-cot(alfa));
if al>dinf
    al=dinf;
end
% Verifica��o da decalagem m�nima
if VIGAin.alfa==90
    almin=0.5*dinf;
else
    almin=0.2*dinf;
end
% Verifica��o se a decalagem calculada � menor que a decalagem m�nima
if al<=almin
    al=almin;
end