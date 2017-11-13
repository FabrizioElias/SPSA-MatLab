function [phi]=creepcoefFIBMC90(PAR, fcm, VIGA, DADOS)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIENCIAS
% PROGRAMA DE POS-GRADUACAO EM ENGENHARIA CIVIL        - AREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELECAO DE  MEDIA FIDELIDADE  PARA  ANALISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO
% ALUNA       Sérgio José Priori Jovino Marques Filho
% ORIENTADOR  Prof. Ezio da Rocha Araujo
% -------------------------------------------------------------------------
% DESCRICAO
% Função criada para determinação do coeficiente de fluência segundo o
% MODEL CODE 2010 - FIB.
% -------------------------------------------------------------------------
% Criada      15-dezembro-2016                 SÉRGIO MARQUES
% -------------------------------------------------------------------------

% PARA QUE OS VALORES DE PHI SEJAM PLOTADOS NO INTERVALO DE TEMPO ENTRE 0 E
% t, ONDE t É DADO PELA VARIÁVEL PAR.CONCTD.t, RETIRA OS COMENTÁRIOS DOS
% TRECHOS ASSINALADOS COM %----...----%

% %-------------------------------------------------------------------------%
% t=linspace(0,PAR.CONCTD.t,16);
% %-------------------------------------------------------------------------%

% CÁLCULO DE ALGUNS PARÂMETROS BÁSICOS
% Idade de carregamento do concreto ajustada para levar em consideração o
% efeito da temperatura.
if DADOS.op_op_tempeffctes==0
    t0t=PAR.CONCTD.deltati;
else
    t0t=PAR.CONCTD.deltati*exp(13.65-4000/(273+PAR.CONCTD.Tdeltati));
end
% Idade de carregamento ajustada -  para levar em conta o efeito do tipo do
% cimento, parâmetro alfa depende do tipo do cimento
t0adj=t0t*(9/(2+t0t^1.2)+1)^PAR.CONCTD.alfa;

% Quantidade de vigas existentes no pórtico
s=size(VIGA.elemento);
numvigas=s(2);
phi=zeros(1,numvigas);
for i=1:numvigas
    H=VIGA.hvm(i)*10;      % <-- Multiplicação por 10 para transofrmar de cm p mm
    B=VIGA.bvm(i)*10;      % <-- Multiplicação por 10 para transofrmar de cm p mm
    % Espessura fictícia
    h=2*(B*H)/((2*B+2*H));
    % Outros parâmetros
    %FAB - ATENÇÃO! Remoção de 3 variáveis aparentemente sem uso.
    %gamat0=1/(2.3+3.5/(t0adj^(1/2)));
    %alfafcm=(35/(fcm/1000))^0.5;    % <-- Divisão por mil para transformar de kN/m2 para MPa
    %betah=min(1.5*h+250*alfafcm,1500*alfafcm);

    % NOTIONAL CREEP COEFFICIENT - PHI0
    % Cálculo do BETAbcfcm
    phiRH=1+(1-PAR.CONCTD.RH/100)/(0.1*(h^(1/3)));
    % Cálculo do BETAbct0t
    BETAfcm=16.8/((fcm/1000)^0.5);  % <-- Divisão por mil para transformar de kN/m2 para MPa
    % Cálculo do BETAt0
    BETAt0=1/(0.1+t0adj^0.2);
    % Cálculo do PHI0
    PHI0=phiRH*BETAfcm*BETAt0;
    
    % COEFICIENTE PARA LEVAR EM CONSIDERAÇÃO O DESENVOLVIMENTO DA FLUÊNCIA
    % EM FUNÇÃO DO TEMPO
    % Cálculo do BETAh
    BETAh=min(1.5*(1+(0.012*PAR.CONCTD.RH)^18)*h+250,1500);
    % Coeficiente BETAt0t para cosniderar o efeito da fluência no tempo "t"
    BETAt0t=((PAR.CONCTD.t-t0adj)/(BETAh+(PAR.CONCTD.t-t0adj)))^0.3;
% %-------------------------------------------------------------------------%
%     BETAt0t=(t-t0adj)./(BETAh+(t-t0adj)).^0.3;
%     phi=PHI0*BETAt0t;
%     plot(t,phi)
% %-------------------------------------------------------------------------%
    
    % COEFICIENTE DE FLUÊNCIA FINAL
    phi(i)=PHI0*BETAt0t;
end