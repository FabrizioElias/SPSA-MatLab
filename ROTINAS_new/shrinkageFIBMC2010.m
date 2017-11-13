function [epsoncs, deltacs]=shrinkageFIBMC2010(PAR, VIGA, PORTICO)
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
% Função criada para determinação da deformação específica de retração
% segundo o MODEL CODE - FIB.
% -------------------------------------------------------------------------
% Criada      15-dezembro-2016                 SÉRGIO MARQUES
% -------------------------------------------------------------------------

% TODOS OS VALORES SERÃO CALCULADOS EM MPa, CONFORME FORMULÇÃO DO FIB E
% POSTERIORMETE SERÁ FEITA A TRANSFORMAÇÃO DE UNIDADE NECESSÁRIA

% % VARIÁVEIS PROVISÓRIAS
% t=15000;
% b=0.2;
% h=0.6;
% fcm=38;
% h=2*(b*h*10^6)/((2*b+2*h)*10^3);

% Resistência média à compressão do concreto
fcm=(PAR.CONC.RESCOMP.parest1+PAR.CONC.DELTARESCOMP.parest1)/1000;  % <-- Divisão por 1000 para transofrmar de kN/m2 para MPA

s=size(VIGA.elemento);
numvigas=s(2);

% Alocação de espaço para as variáveis "epsoncs" e "deltacs"
epsoncs=zeros(1,numvigas);
deltacs=zeros(1,numvigas);

for i=1:numvigas
    % PARÂMETROS GEOMÉTRICOS
    H=VIGA.hvm(i)*10;       % <-- Multiplicação por 10 para transofrmar de cm p mm
    B=VIGA.bvm(i)*10;       % <-- Multiplicação por 10 para transofrmar de cm p mm
    h=2*(B*H)/((2*B+2*H));  % Espessura fictícia
    
    % CÁLCULO DA DEFORMAÇÃO ESPECÍFICA DEVIDO À RETRAÇÃO AUTOGÊNA
    EPSONcas0=-PAR.CONCTD.alfas*((fcm/10)/(6+fcm/10))^2.5*10^-6;
    BETAast=1-exp(-0.2*(PAR.CONCTD.t^0.5));
    EPSONcast=EPSONcas0*BETAast;

    % CÁLCULO DA DEFORMAÇÃO ESPECÍFICA DEVIDO À RETRAÇÃO POR SECAGEM
    EPSONcds0=((220+110*PAR.CONCTD.alfas1)*exp(-PAR.CONCTD.alfas2*fcm))*10^-6;
    BETArh=-1.55*(1-(PAR.CONCTD.RH/100)^3);
    BETAdstst=((PAR.CONCTD.t-PAR.CONCTD.ts)/(0.035*h^2+(PAR.CONCTD.t-PAR.CONCTD.ts)))^0.5;
    EPSONcdstst=EPSONcds0*BETArh*BETAdstst;

    % DEFORMAÇÃO ESPECÍFICA TOTAL DEVIDO À RETRAÇÃO DO CONCRETO
    epsoncs(i)=EPSONcast+EPSONcdstst;
    
    % DEFORMAÇÃO ABSOLUTA TOTAL DEVIDO À RETRAÇÃO DO CONCRETO
    L=PORTICO.comp(VIGA.elemento(i));
    deltacs(i)=epsoncs(i)*L;
end