function [epsoncs, deltacs]=shrinkageFIBMC2010(PAR, VIGA, PORTICO)
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
% Fun��o criada para determina��o da deforma��o espec�fica de retra��o
% segundo o MODEL CODE - FIB.
% -------------------------------------------------------------------------
% Criada      15-dezembro-2016                 S�RGIO MARQUES
% -------------------------------------------------------------------------

% TODOS OS VALORES SER�O CALCULADOS EM MPa, CONFORME FORMUL��O DO FIB E
% POSTERIORMETE SER� FEITA A TRANSFORMA��O DE UNIDADE NECESS�RIA

% % VARI�VEIS PROVIS�RIAS
% t=15000;
% b=0.2;
% h=0.6;
% fcm=38;
% h=2*(b*h*10^6)/((2*b+2*h)*10^3);

% Resist�ncia m�dia � compress�o do concreto
fcm=(PAR.CONC.RESCOMP.parest1+PAR.CONC.DELTARESCOMP.parest1)/1000;  % <-- Divis�o por 1000 para transofrmar de kN/m2 para MPA

s=size(VIGA.elemento);
numvigas=s(2);

% Aloca��o de espa�o para as vari�veis "epsoncs" e "deltacs"
epsoncs=zeros(1,numvigas);
deltacs=zeros(1,numvigas);

for i=1:numvigas
    % PAR�METROS GEOM�TRICOS
    H=VIGA.hvm(i)*10;       % <-- Multiplica��o por 10 para transofrmar de cm p mm
    B=VIGA.bvm(i)*10;       % <-- Multiplica��o por 10 para transofrmar de cm p mm
    h=2*(B*H)/((2*B+2*H));  % Espessura fict�cia
    
    % C�LCULO DA DEFORMA��O ESPEC�FICA DEVIDO � RETRA��O AUTOG�NA
    EPSONcas0=-PAR.CONCTD.alfas*((fcm/10)/(6+fcm/10))^2.5*10^-6;
    BETAast=1-exp(-0.2*(PAR.CONCTD.t^0.5));
    EPSONcast=EPSONcas0*BETAast;

    % C�LCULO DA DEFORMA��O ESPEC�FICA DEVIDO � RETRA��O POR SECAGEM
    EPSONcds0=((220+110*PAR.CONCTD.alfas1)*exp(-PAR.CONCTD.alfas2*fcm))*10^-6;
    BETArh=-1.55*(1-(PAR.CONCTD.RH/100)^3);
    BETAdstst=((PAR.CONCTD.t-PAR.CONCTD.ts)/(0.035*h^2+(PAR.CONCTD.t-PAR.CONCTD.ts)))^0.5;
    EPSONcdstst=EPSONcds0*BETArh*BETAdstst;

    % DEFORMA��O ESPEC�FICA TOTAL DEVIDO � RETRA��O DO CONCRETO
    epsoncs(i)=EPSONcast+EPSONcdstst;
    
    % DEFORMA��O ABSOLUTA TOTAL DEVIDO � RETRA��O DO CONCRETO
    L=PORTICO.comp(VIGA.elemento(i));
    deltacs(i)=epsoncs(i)*L;
end