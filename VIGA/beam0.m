function [Astrac, Ascomp]=beam0(momento, VIGAin, sec, bitola)
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
% Rotina para dimensionamento à flexão da seção da viga. Ao final do
% processamento da rotina, a área de aço é determinada.
% -------------------------------------------------------------------------
% MODIFICAÇÕES:         
%--------------------------------------------------------------------------
% VARIÁVEIS DE ENTRADA: momento, VIGAin, sec, bitola
% VARIÁVEIS DE SAÍDA:   Astrac, Ascomp - área de aço tracionada e
% comprimida, respectivamente.
%--------------------------------------------------------------------------
% CRIADA EM 18-agosto-2015
% -------------------------------------------------------------------------
% DIMENSIONAMENTO À FLEXÃO
% Determinação do momento adimensional e alongamento da armadura
momento=abs(momento);
mi=momento/(VIGAin.b*VIGAin.dinf(bitola, sec)^2*VIGAin.sigmafcd);       % momento adimensional
%FAB - Remoção de variável sem uso.
%epsy=VIGAin.fyd/VIGAin.Es;                                      % def. específica da armadura
qsilim=0.45;
milim=0.8*qsilim*(1-0.4*qsilim);                                % momento adimensional limite

% Determinação da área de aço da armadura de tração
delta=VIGAin.dsup/VIGAin.dinf(sec);
qsi=1.25*(1-(1-2*mi)^0.5);
if mi<=milim
    Astrac=0.8*qsi*VIGAin.b*VIGAin.dinf(bitola, sec)*VIGAin.sigmafcd/VIGAin.fyd;
    Ascomp=0;
else
    Astrac=(VIGAin.b*VIGAin.dinf(bitola, sec)*VIGAin.sigmafcd/VIGAin.fyd*(0.8*qsilim+(mi-milim)/(1-delta)));
    Ascomp=VIGAin.b*VIGAin.dinf(bitola, sec)*VIGAin.sigmafcd*(mi-milim)/((1-delta)*VIGAin.fyd);   
end

% Comparação com a armadura mínima
Astrac=max(Astrac,VIGAin.Astracmin);
  
end