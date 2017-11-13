function FC = monta_fc(Oleo_Produzido,Agua_Produzida,Agua_Injetada)
% MONTA_FC: Monta o fluxo de caixa da producao de petroleo.
% --------------------------------------------------------------------------
% monta_fc
%
% vpl   -  Valor Presente Liquido                                       (out)
% FC    -  fluxo de caixa em $                                          (in)
% tempo -  escala de tempo associada ao fluxo de caixa, dias            (in)
% tax   -  taxa de desconto em % ao dia                                 (in)
% --------------------------------------------------------------------------
% -------------------------------------------------------------------------
% OTIMIZACAO DINAMICA DAS VAZOES DE PRODUCAO E INJECAO EM POCOS DE PETROLEO
% -------------------------------------------------------------------------
% Universidade Federal de Pernambuco
% Programa de Pos-Graduaçao Engenharia Civil / Estruturas
%
% Petrobras
% Centro de Pesquisas - CENPES
% 
% --------------------------------------------------------------------------
% Criado:        08-Nov-2005      Diego Oliveira
%
% Moficaçao:     
% --------------------------------------------------------------------------

%Receita
rop=R_Oleo_Produzido; %receita liquida unitaria do oleo
%OPEX
%cop=C_Oleo_Produzido; %receita liquida unitaria do oleo
cap=C_Agua_Produzida; %custo unitaria da agua produzida
cai=C_Agua_Injetada;  %custo unitaria da agua injetada
%CAPEX
capex=outros_custos;

%Curvas de Producao e Injecao
op=Oleo_Produzido;
ap=Agua_Produzida;
ai=Agua_Injetada;

%Verificacao de Compatibilidade
n_op = length(Oleo_Produzido);
n_ap = length(Agua_Produzido);
n_ai = length(Agua_Injetada);
if (n_op~=n_ap~=n_ai)
    error('dimensoes das curvas de producao sao diferentes!');
else
    n=n_op;
end

%Montagem do Fluxo de Caixa
for i=1:n
    if i==1
        FC(i)=op*rop-(ap*cap+ai*cai+capex);
    end
    FC(i)=op*rop-(ap*cap+ai*cai);
end