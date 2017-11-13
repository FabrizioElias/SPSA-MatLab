function [phi]=creepcoefFIBMC90(PAR, fcm, VIGA, DADOS)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIENCIAS
% PROGRAMA DE POS-GRADUACAO EM ENGENHARIA CIVIL        - AREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELECAO DE  MEDIA FIDELIDADE  PARA  ANALISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO
% ALUNA       S�rgio Jos� Priori Jovino Marques Filho
% ORIENTADOR  Prof. Ezio da Rocha Araujo
% -------------------------------------------------------------------------
% DESCRICAO
% Fun��o criada para determina��o do coeficiente de flu�ncia segundo o
% MODEL CODE 2010 - FIB.
% -------------------------------------------------------------------------
% Criada      15-dezembro-2016                 S�RGIO MARQUES
% -------------------------------------------------------------------------

% PARA QUE OS VALORES DE PHI SEJAM PLOTADOS NO INTERVALO DE TEMPO ENTRE 0 E
% t, ONDE t � DADO PELA VARI�VEL PAR.CONCTD.t, RETIRA OS COMENT�RIOS DOS
% TRECHOS ASSINALADOS COM %----...----%

% %-------------------------------------------------------------------------%
% t=linspace(0,PAR.CONCTD.t,16);
% %-------------------------------------------------------------------------%

% C�LCULO DE ALGUNS PAR�METROS B�SICOS
% Idade de carregamento do concreto ajustada para levar em considera��o o
% efeito da temperatura.
if DADOS.op_op_tempeffctes==0
    t0t=PAR.CONCTD.deltati;
else
    t0t=PAR.CONCTD.deltati*exp(13.65-4000/(273+PAR.CONCTD.Tdeltati));
end
% Idade de carregamento ajustada -  para levar em conta o efeito do tipo do
% cimento, par�metro alfa depende do tipo do cimento
t0adj=t0t*(9/(2+t0t^1.2)+1)^PAR.CONCTD.alfa;

% Quantidade de vigas existentes no p�rtico
s=size(VIGA.elemento);
numvigas=s(2);
phi=zeros(1,numvigas);
for i=1:numvigas
    H=VIGA.hvm(i)*10;      % <-- Multiplica��o por 10 para transofrmar de cm p mm
    B=VIGA.bvm(i)*10;      % <-- Multiplica��o por 10 para transofrmar de cm p mm
    % Espessura fict�cia
    h=2*(B*H)/((2*B+2*H));
    % Outros par�metros
    %FAB - ATEN��O! Remo��o de 3 vari�veis aparentemente sem uso.
    %gamat0=1/(2.3+3.5/(t0adj^(1/2)));
    %alfafcm=(35/(fcm/1000))^0.5;    % <-- Divis�o por mil para transformar de kN/m2 para MPa
    %betah=min(1.5*h+250*alfafcm,1500*alfafcm);

    % NOTIONAL CREEP COEFFICIENT - PHI0
    % C�lculo do BETAbcfcm
    phiRH=1+(1-PAR.CONCTD.RH/100)/(0.1*(h^(1/3)));
    % C�lculo do BETAbct0t
    BETAfcm=16.8/((fcm/1000)^0.5);  % <-- Divis�o por mil para transformar de kN/m2 para MPa
    % C�lculo do BETAt0
    BETAt0=1/(0.1+t0adj^0.2);
    % C�lculo do PHI0
    PHI0=phiRH*BETAfcm*BETAt0;
    
    % COEFICIENTE PARA LEVAR EM CONSIDERA��O O DESENVOLVIMENTO DA FLU�NCIA
    % EM FUN��O DO TEMPO
    % C�lculo do BETAh
    BETAh=min(1.5*(1+(0.012*PAR.CONCTD.RH)^18)*h+250,1500);
    % Coeficiente BETAt0t para cosniderar o efeito da flu�ncia no tempo "t"
    BETAt0t=((PAR.CONCTD.t-t0adj)/(BETAh+(PAR.CONCTD.t-t0adj)))^0.3;
% %-------------------------------------------------------------------------%
%     BETAt0t=(t-t0adj)./(BETAh+(t-t0adj)).^0.3;
%     phi=PHI0*BETAt0t;
%     plot(t,phi)
% %-------------------------------------------------------------------------%
    
    % COEFICIENTE DE FLU�NCIA FINAL
    phi(i)=PHI0*BETAt0t;
end