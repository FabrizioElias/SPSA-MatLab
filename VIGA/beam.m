function VIGAresult=beam(PORTICO, ELEMENTOS, DADOS, CORTANTE, MOMENTO, NORMAL, VIGA, PAR, VIGAresult, ESTRUTURAL)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCI�NCIAS
% PROGRAMA DE P�S-GRADUA��O EM ENGENHARIA CIVIL        - �REA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELE��O DE  M�DIA FIDELIDADE  PARA  AN�LISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO.
% ALUNA       S�rgio Jos� Priori Jovino Marques Filho
% ORIENTADOR  Prof. �zio da Rocha Ara�jo
% -------------------------------------------------------------------------
% DESCRI��O
% Gerenciador que chama diversas subrotinas para o dimensionamento da vigas 
% -------------------------------------------------------------------------
% MODIFICA��ES:         
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: PORTICO, ELEMENTOS, DADOS, esf, CORTANTE MOMENTO
% VARI�VEIS DE SA�DA:   VIGA: structure contendo os dados da viga j�
% dimensionada
%--------------------------------------------------------------------------
% CRIADA EM 30-junho-2015
% -------------------------------------------------------------------------

global m;   

% C�lculo da qnt de vigas no p�rtico e do comprimento de cada uma
VIGA.elemento=ESTRUTURAL.ELEMVIGA;
s=size(VIGA.elemento);
s=s(2);
DADOS.Nvigas=s;
VIGAin.COMPRIMENTO=zeros(1,DADOS.Nvigas);
VIGAin.compelem=zeros(1,DADOS.Nvigas);
for i=1:DADOS.Nvigas
    % N�s inicail e final
    noi=PORTICO.conec(ESTRUTURAL.D(VIGA.elemento(1,i),1),1);
    nof=PORTICO.conec(ESTRUTURAL.D(VIGA.elemento(1,i),2),2);
    VIGAin.COMPRIMENTO(i)=PORTICO.x(nof)-PORTICO.x(noi);
    nelem=ESTRUTURAL.D(VIGA.elemento(1,i),2)-ESTRUTURAL.D(VIGA.elemento(1,i),1)+1;
    VIGAin.compelem(i)=VIGAin.COMPRIMENTO(i)/nelem;
end

% Cria��o de vetores nulos na "structure"VIGAresult, para armazenar os
% resultados da rotina beam.m. Esses resultados s�o:
% VIGAresult.PESOneg - matriz (NUMVIGASx2) com o peso da armadura negativa 
% de cada viga. Esse vetor possui duas colunas pois a viga pode ter MF
% negativo em um ou nas duas extremidades.
% VIGAresult.PESOnegTOTAL - escalar contendo o peso de armadura negativa de
% todas as vigas da estrutura
% VIGAresult.PESOpos - vetor com o peso de armadura positiva de cada viga
% VIGAresult.PESOposTOTAL - escalar com o peso de armadura positiva de 
% todas as vigas da estrutura
% VIGAresult.PESOestribos - peso da armadura transversal total de cada viga
% de estrutura
% VIGAresult.PESOestribosTOTAL - peso total dos estribos
% VIGAresult.PESOmontagem - peso da armadurade montagem de cada viga da
% estrutura
% VIGAresult.PESOmontagemTOTAL - peso total da armadura de montagem de toda
% a estrutura
% VIGAresult.PESOpele -peso da armadurade de pele de cada viga da estrutura
% VIGAresult.PESOpeleTOTAL-peso total da armadura de pele de toda estrutura
% VIGAresult.PESOcomp - peso da armadura de compress�o, caso de vigas
% duplamente armadas.
% VIGAresult.PESOcomp - peso da armadura de compress�o de toda a edifica��o
VIGAresult.PESOneg=zeros(DADOS.Nvigas,2);
VIGAresult.PESOnegTOTAL=0;
VIGAresult.PESOpos=zeros(1,DADOS.Nvigas);
VIGAresult.PESOposTOTAL=0;
VIGAresult.PESOestribos=zeros(1,DADOS.Nvigas);
VIGAresult.PESOestribosTOTAL=0;
VIGAresult.PESOmontagem=zeros(1,DADOS.Nvigas);
VIGAresult.PESOmontagemTOTAL=0;
VIGAresult.PESOpele=zeros(1,DADOS.Nvigas);
VIGAresult.PESOpeleTOTAL=0;
VIGAresult.PESOcomp=zeros(1,DADOS.Nvigas);
VIGAresult.PESOcompTOTAL=0;
VIGAresult.volconc=zeros(1,DADOS.Nvigas);
VIGAresult.volconcTOTAL=0;
VIGAresult.aforma=zeros(1,DADOS.Nvigas);
VIGAresult.aformaTOTAL=0;

% Criar rotina para extrair apenas as linhas com os esfor�os internos referentes �s vigas
for NUMVIGAS=1:DADOS.Nvigas 
    C=VIGAin.COMPRIMENTO;
    c=VIGAin.compelem;
    clear VIGAin
    VIGAin.COMPRIMENTO=C;
    VIGAin.compelem=c;
    disp(['Dimensionando viga ',num2str(NUMVIGAS),' de ',num2str(DADOS.Nvigas)])
    disp('----------------------------------------------------------------')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%------------------------ENTRADA DE DADOS---------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Esfor�os atuantes - valores caracter�sticos - A vari�vel
    % VIGA.elemento relaciona o n�mero do elemento no p�rtico original com
    % o n�mero da viga.
    VIGAin.M=MOMENTO.TOTAL{VIGA.elemento(1,NUMVIGAS),:};    
    VIGAin.V=CORTANTE.TOTAL{VIGA.elemento(1,NUMVIGAS),:};
    VIGAin.N=NORMAL.TOTAL{VIGA.elemento(1,NUMVIGAS),:};
    % Propriedades f�sicas dos materiais
    VIGAin.fcd=PAR.CONC.fccV(m);    % Dados em kN/m2
    VIGAin.sigmafcd=0.85*VIGAin.fcd;
    VIGAin.fctd=PAR.CONC.fctV(m);  
    VIGAin.fbd=PAR.CONC.fbdV(m);    % Dados em kN/m2
    VIGAin.Ec=PAR.CONC.EcsV(m);     % Dados em kN/m2
    VIGAin.fyd=PAR.ACO.fyV(m);      % Dados em kN/m2
    VIGAin.fywd=PAR.ACO.fywV(m);
    VIGAin.Es=PAR.ACO.EsV(m);       % Dados em kN/m2
    VIGAin.roaco=PAR.ACO.rosV(m);    % Peso espec�fico do a�o
    % Propriedades geom�tricas da se��o
    j=ESTRUTURAL.D(VIGA.elemento(NUMVIGAS),1);
    VIGAin.b=ELEMENTOS.secaoV(j,1,m);
    VIGAin.h=ELEMENTOS.secaoV(j,2,m);
    VIGAin.cob=DADOS.cobv;                  % cobrimento da armadura
    VIGAin.diamagregado=DADOS.diamagreg;    % di�metro do agregado   
    VIGAin.diamflex=DADOS.flexinicial;      % estimativa do di�metro inicial da armadura longitudinal
    VIGAin.diamcort=DADOS.transinicial;     % estimativa inicial do di�metro da armadura transversal
    VIGAin.dinfinicial=VIGAin.h-(VIGAin.cob+VIGAin.diamcort+VIGAin.diamflex/2);
    VIGAin.dsup=VIGAin.cob+VIGAin.diamcort+VIGAin.diamflex/2;
    % Outros dados das vigas
    VIGAin.teta=DADOS.teta;                 % �ngulo de inclina��o da biela de compress�o
    VIGAin.alfa=DADOS.alfa;                 % �ngulo de inclina��o do estribo
    VIGAin.Ltrecho=DADOS.Ltrecho;           % Comp. do trechos que ser� considerado o EC constante

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-DETERMINA��O PAR�METROS NECESS�RIOS AO DIMENSIONAMENTO � FLEX�O DA VIGA-%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % C�lculo da armadura longitudinal m�nima
    rescomp=[20000 25000 30000 35000 40000 45000 50000]'; % valores de fck kN/m2, adaptado
    ro=[.15 .15 .15 .164 .179 .194 .208]'; % <-- Alterado de acordo com a NBR6118:2014
    romin=interp1q(rescomp,ro,(VIGAin.fcd))/100;                                                  
    VIGAin.Astracmin=VIGAin.b*VIGAin.h*romin;
    
    % Quantidade de bitolas comerciais dispon�veis para o dimensionamento
    % da armadura longitudinal
    s=size(VIGA.TABELALONG);
    VIGAin.qntbitolaslong=s(2);
    
    % Quantidade de bitolas comerciais dispon�veis para o dimensionamento
    % da armadura transversal
    s=size(VIGA.TABELATRANS);
    VIGAin.qntbitolastrans=s(2);

    % REMOVE ZEROS - rotina pra remover os zeros existentes no final do
    % vetor que cont�m os MF e EC da viga.
    M=VIGAin.M;
    %M=beamRemoveZeros(M);
    VIGAin.MF=M;
    
    % Quantidade de se��es existentes ao longo de toda a viga
    s=size(VIGAin.MF);
    VIGAin.qntsecoes=s(2);
    
    % CONTADOR - rotina para determinar quantos trechos da viga possuem
    % momento fletor positivo (VIGAin.qnttrechospos) ou negativo,
    % (VIGAin.qnttrechosneg). A rotina ir�forncer tamb�m duas matrizes,
    % uma contendo os valores positovos do MF, VIGAin.POS, e outra os
    % valores negativos, VIGAin.NEG. 
    VIGAin=beamCountSec(VIGAin);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-----DIMENSIONAMENTO � FLEX�O E DETALHAMENTO DAS ARMADURAS POSITIVAS-----%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [VIGAresult, VIGAin]=beamPos(VIGAin, VIGA, VIGAresult, NUMVIGAS);
    VIGAresult.PESOposTOTAL=VIGAresult.PESOposTOTAL+VIGAresult.PESOpos(NUMVIGAS);
    VIGAresult.PESOcompTOTAL=VIGAresult.PESOcompTOTAL+VIGAresult.PESOcomp(NUMVIGAS);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-----DIMENSIONAMENTO � FLEX�O E DETALHAMENTO DAS ARMADURAS NEGATIVAS-----%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [VIGAresult]=beamNeg(VIGAin, VIGA, NUMVIGAS, VIGAresult);
    VIGAresult.PESOnegTOTAL=VIGAresult.PESOnegTOTAL+sum(VIGAresult.PESOneg(NUMVIGAS,:));
    VIGAresult.PESOmontagemTOTAL=VIGAresult.PESOmontagemTOTAL+VIGAresult.PESOmontagem(NUMVIGAS);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%------------------------C�LCULO DA ARMADURA DE PELE----------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% C�lculo da armadura de pele - beam13.m
    if VIGA.hvm>=.60
        [VIGAresult]=beam13(VIGA, VIGAin, VIGAresult, NUMVIGAS);
    else
        VIGAresult.PESOpele=0;
    end
    VIGAresult.PESOpeleTOTAL=VIGAresult.PESOpeleTOTAL+VIGAresult.PESOpele(NUMVIGAS);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--------------------C�LCULO DAS ARMADURAS TRANSVERSAIS-------------------%
%---------------------------------MODELO I--------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % C�lculo da taxa m�nima de armadura transversal
    VIGAin.rosw90min=0.2*VIGAin.fctd/VIGAin.fywd;
    % C�lculo da armadura de cisalhamento
    [VIGAresult, ARRANJOESTRIBO]=beam14(VIGA, VIGAin, VIGAresult,NUMVIGAS);
    % C�lculo do peso total da armadura transversal
    [VIGAresult]=beam15(ARRANJOESTRIBO, VIGAresult, VIGAin, NUMVIGAS);
    VIGAresult.PESOestribosTOTAL=VIGAresult.PESOestribosTOTAL+VIGAresult.PESOestribos(NUMVIGAS);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-----------C�LCULO DAS QUANTIDADES DE MATERIAL A SER UTILIZADO-----------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % C�lculo do volume de concreto
    VIGAresult.volconc(NUMVIGAS)=VIGAin.b*VIGAin.h*PORTICO.comp(VIGA.elemento(NUMVIGAS));
    VIGAresult.volconcTOTAL=VIGAresult.volconcTOTAL+VIGAresult.volconc(NUMVIGAS);
    
    % C�lculo da �rea de forma
    VIGAresult.aforma(NUMVIGAS)=(VIGAin.b+2*VIGAin.h)*PORTICO.comp(VIGA.elemento(NUMVIGAS));
    VIGAresult.aformaTOTAL=VIGAresult.aformaTOTAL+VIGAresult.aforma(NUMVIGAS);
    
end