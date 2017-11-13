function [al]=beam3(VIGAin, bitola)
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
% Rotina para cálculo da decalagem do DMF.
% -------------------------------------------------------------------------
% MODIFICAÇÕES:         
%--------------------------------------------------------------------------
% VARIÁVEIS DE ENTRADA: VIGAin, bitola
% VARIÁVEIS DE SAÍDA:   al
%--------------------------------------------------------------------------
% CRIADA EM 07-novembro-2015
% -------------------------------------------------------------------------

% Iremos utilizar o maior valor de de VIGAin.dinf de forma a garantir o
% maior valor de al.
dinf=max(VIGAin.dinf(bitola,:));

% Cálculo da força de tração que a armadura de tração deverá resistir
Vsdmax=max(abs(VIGAin.V));                 % Esforço cortante máximo ao longo da viga
Vc=0.6*VIGAin.fctd*VIGAin.b*dinf;   	   % Parcela do esforço cortante absorvido por mecanismos adicionais da treliça
alfa=VIGAin.alfa*pi/180;                   % Ângulo de inclinação dos estribos 
al=dinf*(Vsdmax*(1+cot(alfa))/(2*(Vsdmax-Vc))-cot(alfa));
if al>dinf
    al=dinf;
end
% Verificação da decalagem mínima
if VIGAin.alfa==90
    almin=0.5*dinf;
else
    almin=0.2*dinf;
end
% Verificação se a decalagem calculada é menor que a decalagem mínima
if al<=almin
    al=almin;
end