function [phi]=creepcoefFIBMC2010(PAR, fcm, VIGA, ELEMENTOS, DADOS)
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

% TODOS OS VALORES SER�O CALCULADOS EM MPa, CONFORME FORMUL��O DO FIB E
% POSTERIORMETE SER� FEITA A TRANSFORMA��O DE UNIDADE NECESS�RIA

% C�LCULO DE ALGUNS PAR�METROS B�SICOS
% Efeito da temperatura na maturidade do concreto
t0t=PAR.CONCTD.deltati*exp(13.65-4000/(273+PAR.CONCTD.Tdeltati));
% Idade de carregamento ajustada -  para levar em conta o efeito do tipo do
% cimento, par�metro alfa depende do tipo do cimento
t0adj=t0t*(9/(2+t0t^1.2)+1)^PAR.CONCTD.alfa;

% Quantidade de vigas existentes no p�rtico
s=size(VIGA.elemento);
numvigas=s(2);
phi=zeros(numvigas, DADOS.NMC);
for i=1:numvigas
    per=ELEMENTOS.u(VIGA.elemento(i))*1000;     % Multiplica��o por 1000 e
    area=ELEMENTOS.AV(VIGA.elemento(i))*1000000;% 1000000 para transformar de m p mm e m2 p mm2
    % Espessura fict�cia
    h=2*area/per;
    
    % Outros par�metros - ser�o utilizados apenas no calculo da flu�ncia
    % por secagem
    gamat0=1/(2.3+3.5/(t0adj^(1/2)));
    alfafcm=(35./(PAR.CONC.fccV./1000)).^0.5;    % <-- Divis�o por mil para transformar de kN/m2 para MPa
    betah=min(1.5*h+250*alfafcm,1500*alfafcm);

    % BASIC CREEP COEFFICIENT - PHIbc
    % C�lculo do BETAbcfcm
    BETAbcfcm=1.8./(PAR.CONC.fccV./1000).^0.7;   % <-- Divis�o por mil para transformar de kN/m2 para MPa
    % C�lculo do BETAbct0t
    BETAbct0t=log((30/t0adj+0.035)^2*(PAR.CONCTD.t-PAR.CONCTD.t0)+1);
    PHIbc=BETAbcfcm*BETAbct0t;

    % DRYING CREEP COEFFICIENT - PHIdc
    % C�lculo do BETAdcfcm
    BETAdcfcm=412./((PAR.CONC.fccV./1000).^1.4);
    % C�lculo do BETAdcrh
    BETAdcrh=(1-PAR.CONCTD.RH/100)/((0.1*h/100)^(1/3));
    % C�lculo do BETAdct0
    BETAdct0=1/(0.1+t0adj^0.2);
    % C�lculo do BETAdct0t
    BETAdct0t=((PAR.CONCTD.t-PAR.CONCTD.t0)./(betah+(PAR.CONCTD.t-PAR.CONCTD.t0))).^gamat0;
    PHIdc=((BETAdcrh*BETAdct0).*BETAdcfcm).*BETAdct0t;

    % COEFICIENTE DE FLU�NCIA FINAL
    phi(i,:)=PHIbc+PHIdc;
end