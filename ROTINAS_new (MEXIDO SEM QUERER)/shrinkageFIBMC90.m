function [epsoncs, deltacs]=shrinkageFIBMC90(PAR, VIGA, PORTICO)
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
% segundo o MODEL CODE 90 - FIB.
% -------------------------------------------------------------------------
% Criada      03-janeiro-2017                 SÉRGIO MARQUES
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
    h0=2*(B*H)/((2*B+2*H));  % <-- Espessura fictícia
    
    % Cálculo da deformação de retração "notional"
    epsonsfcm=[160+ PAR.CONCTD.betasc*(90-fcm)]*10^-6;
    
    BETAsRH=1-(PAR.CONCTD.RH/100)^3;
    
    if PAR.CONCTD.RH>=40 && PAR.CONCTD.RH<99
        BETARH=-1.55*BETAsRH;
    elseif PAR.CONCTD.RH>=99 && PAR.CONCTD.RH<=100
        BETARH=0.25;
    else
        disp('ERRO - Umidade relativa do ar "out of range"')
    end
    
    EPSONCS0=epsonsfcm*BETARH;
    
    BETAsh=0.035*h0^2;
    
    BETAstst=((PAR.CONCTD.t- PAR.CONCTD.ts)/(BETAsh+(PAR.CONCTD.t- PAR.CONCTD.ts)))^0.5;

    % DEFORMAÇÃO ESPECÍFICA TOTAL DEVIDO À RETRAÇÃO DO CONCRETO
    epsoncs(i)=EPSONCS0*BETAstst;
    
    % DEFORMAÇÃO ABSOLUTA TOTAL DEVIDO À RETRAÇÃO DO CONCRETO
    L=PORTICO.comp(VIGA.elemento(i));
    deltacs(i)=epsoncs(i)*L;
end