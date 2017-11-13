function [X0,Xmin,Xmax,Xsup,Xinf,VARPROJ] = Le_Parametros(DADOS)

% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIENCIAS
% PROGRAMA DE POS-GRADUACAO EM ENGENHARIA CIVIL        - AREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELECAO DE  MEDIA FIDELIDADE  PARA  ANALISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO.
% ALUNA       Nilma Andrade
% ORIENTADOR  Prof. Ezio da Rocha Araujo
% -------------------------------------------------------------------------
% DESCRICAO
% L� os valores iniciais das variaveis de controle.
% -------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: n�o h�
% VARI�VEIS DE SA�DA 
% X0: Vetor com os valores iniciais das vari�vies de projeto e seus limites
% RV: Vetor com os Reference Vector de todas as vigas
% Reference Vector: Vetor de refer�ncia para o FEAP
% -------------------------------------------------------------------------
% ADAPTACAO DA ROTINA DE DIEGO OLIVEIRA 27-Janeiro-2006
% Criada      04-Agosto-2011              NILMA ANDRADE
% Modificada  
% -------------------------------------------------------------------------
% 1-DEFINICAO DAS VARIAVEIS GLOBAIS
%
%global filepar1 filepar2 filepar3 filepar4 filepar5 filepar6;
%global Nvigas Npilares NvigasOT NpilaresOT LajesOT OTvigas OTpilares;
%global RV;

%FAB - Remo��o de vari�veis sem uso (msg em todas as 5 fun��es abaixo).
[fidinc1, ~] = fopen(DADOS.filepar1, 'r');%Abre o arquivo com valores iniciais de:bw e h (viga)
[fidinc2, ~] = fopen(DADOS.filepar2, 'r');%Abre o arquivo com valores iniciais de:hpx e hpy (pilar)
[fidinc3, ~] = fopen(DADOS.filepar3, 'r');%Abre o arquivo com valores iniciais de:hl (laje)
[fidinc4, ~] = fopen(DADOS.filepar4, 'r');%Abre o arquivo com o n�mero de vari�veis de projeto
[fidinc5, ~] = fopen(DADOS.filepar5, 'r');%Abre o arquivo com os n�meros das vari�veis de projeto
% [fidinc6, msg] = fopen(DADOS.filepar6, 'r');%Abre o arquivo com os n�meros dos vetores de refer�ncia 
                                      %Reference Vector (usados no FEAP)

%Nvigas:   N�mero de vigas   (dado de entrada, calculado na rotina InputDados)
%Npilares: N�mero de pilares (dado de entrada, calculado na rotina InputDados)
                                      
%2 - LEITURA DOS VALORES INICIAIS DE TODAS AS VARI�VEIS:
%Larguras e alturas de todas as vigas, dimens�es das se��es transversais dos
%pilares e espessura das lajes

%VIGA - Valores iniciais das larguras e alturas
%bwv e hv - se��o transversal da viga.
while ~feof(fidinc1)
        for k=1:7
            %FAB - Somente l�.
            fgets(fidinc1);
        end
        for i=1:DADOS.Npav
            X=fgets(fidinc1);
            Y=fgets(fidinc1);
            %FAB - Troca para fun��o mais r�pida.
            %aux1 = str2num(X);
            %aux2 = str2num(Y);
            aux1 = str2double(X);
            aux2 = str2double(Y);
            for j=1:DADOS.Nvigas/DADOS.Npav
                VIGA.bvIN(i,j)=aux1(j);
                VIGA.hvIN(i,j)=aux2(j);
            end
        end
end
%FAB - Prealoca��o de matriz.
bwvIN = zeros(DADOS.Nvigas, 1);
hvIN = zeros(DADOS.Nvigas, 1);
for i=1:DADOS.Nvigas
    bwvIN(i)= Xviga(i,1);
    hvIN(i) = Xviga(i,2);
end

%PILAR - Valores iniciais das dimens�es das se��es transversais
%hpx e hpy - se��o transversal do pilar.
while ~feof(fidinc2)
        for k=1:7
            %FAB - Somente l�.
            fgets(fidinc2);
        end
        %FAB - Remo��o de vari�vel sem uso (count).
        [Xpilar,~]=fscanf(fidinc2,'%f',[DADOS.Npilares inf]);
        %Xpilar:matriz.
        %N�mero de linhas de Xpilar  = Npilares
        %N�mero de colunas de Xpilar = 2
        break
end
%FAB - Prealoca��o de matriz.
hpxIN = zeros(DADOS.Npilares,1);
hpyIN = zeros(DADOS.Npilares,1);
for i=1:DADOS.Npilares
    hpxIN(i)=Xpilar(i,1);
    hpyIN(i)=Xpilar(i,2);
end

%LAJE - Valores iniciais da espessura das lajes
%hl  - espessura da laje.
while ~feof(fidinc3)
        for k=1:7
            %FAB - Somente l�.
            fgets(fidinc3);
        end
        %FAB - Remo��o de vari�vel sem uso (count).
        [Xlaje,~]=fscanf(fidinc3,'%f');
        break
end
hlIN=Xlaje;

%3 - LEITURA DO N�MERO DE VARI�VEIS DE PROJETO
% NvigasOT        N�mero de vigas para a otimiza��o
% NpilaresOT      N�mero de pilares para a otimiza��o
% LajesOT         0: As lajes n�o ser�o otimizadas, 1: As lajes ser�o otimizadas

while ~feof(fidinc4)
        for k=1:7
            %FAB - Somente l�.
            fgets(fidinc4);
        end
        %FAB - Remo��o de vari�vel sem uso (count).
        [Xotimiz, ~]=fscanf(fidinc4,'%f',[3 inf]);
        break
end
VARPROJ.NvigasOT   = Xotimiz(1);
VARPROJ.NpilaresOT = Xotimiz(2);
VARPROJ.LajesOT    = Xotimiz(3);

%4 - LEITURA DOS N�MEROS DAS VARI�VEIS DE PROJETO
% OTvigas:   Vetor com os n�meros das vigas que entrar�o no processo de otimiza��o
% N�mero de elementos de OTvigas: NvigasOT
% OTpilares: Vetor com os n�meros dos pilares que entrar�o no processo de otimiza��o
% N�mero de elementos de OTpilares: NpilaresOT

while ~feof(fidinc5)  
        for k=1:7
            %FAB - Somente l�.
            fgets(fidinc5);
        end
        if VARPROJ.NvigasOT~=0
        %FAB - Remo��o de vari�vel sem uso (count).
            [Xotv,~]=fscanf(fidinc5,'%f',[1,VARPROJ.NvigasOT]);
        else
            %FAB - Somente l�.
            fgets(fidinc5);   
        end
        if VARPROJ.NpilaresOT~=0
        %FAB - Remo��o de vari�vel sem uso (count).
            [Xotp,~]=fscanf(fidinc5,'%f',[1,VARPROJ.NpilaresOT]);
        end
        break
end
for i=1:VARPROJ.NvigasOT
    VARPROJ.OTvigas(i)= Xotv(i);
end
for i=1:VARPROJ.NpilaresOT
    VARPROJ.OTpilares(i)= Xotp(i);
end

%5 - DEFINI��O DO VETOR COM OS VALORES INICIAIS DAS VARI�VEIS DE PROJETO
%Os valores iniciais de todas as vari�veis (inclusive das vari�veis de projeto)
%est�o nos arquivos:
%bh_inicialV.txt     Arquivo com inicializa��o de bw e h (viga)
%bh_inicialP.txt     Arquivo com inicializ. de hpx e hpy (pilar)
%h_inicialL.txt      Arquivo com inicializa��o de hl     (laje)

%Os valores iniciais de todas as vari�veis (inclusive das vari�veis de projeto)
%foram lidos no item 2 desta fun��o.

%FAB - Prealoca��o de matrizes.
b = zeros(VARPROJ.NvigasOT,1);
h = zeros(VARPROJ.NvigasOT,1);
for i=1:VARPROJ.NvigasOT
    b(i) = bwvIN(VARPROJ.OTvigas(i));
    h(i) = hvIN(VARPROJ.OTvigas(i));
end
if VARPROJ.NvigasOT ~= 0
%X0vigas: Vetor com os valores iniciais das vari�veis de projeto para as vigas
%Em X0vigas os primeiros valores s�o os "b" e depois os "h"
    X0vigas=[b h];
else
    X0vigas=[];
end

%FAB - Prealoca��o de matrizes.
hpilarx = zeros(VARPROJ.NpilaresOT,1);
hpilary = zeros(VARPROJ.NpilaresOT,1);
for i=1:VARPROJ.NpilaresOT
    hpilarx(i) = hpxIN(VARPROJ.OTpilares(i));
    hpilary(i) = hpyIN(VARPROJ.OTpilares(i));
end
if VARPROJ.NpilaresOT ~= 0
%X0pilares: Vetor com os valores iniciais das vari�veis de projeto para os pilares
%Em X0pilares os primeiros valores s�o os "hpx" e depois os "hpy"
    X0pilares=[hpilarx hpilary];
else
    X0pilares=[];
end

%Montagem do vetor X0(vetor com os valores iniciais das vari�veis de projeto)
switch VARPROJ.LajesOT
       case 0%As lajes n�o ser�o otimizadas           
        X0=[X0vigas X0pilares];    
       case 1%As lajes ser�o otimizadas               
        X0=[X0vigas X0pilares hlIN];    
end
%Ordem dos elementos de X0:
%1)VIGAS:   primeiro os "b" e depois os "h"
%2)PILARES: primeiro os "hpx" e depois os "hpy"
%3)LAJES:   se as lajes est�o sendo otimizadas, o �ltimo elemento de XO � hl

%N�mero de elementos de X0:
%1)Se as lajes n�o estiverem sendo otimizadas: 2xNvigasOT + 2xNpilaresOT
%2)Se as lajes estiverem sendo otimizadas:     2xNvigasOT + 2xNpilaresOT + 1

%6 - LIMITES DAS VARI�VEIS DE PROJETO

%6.1 - LIMITES M�NIMOS
%Limites m�nimos para vigas
bmin = linspace(12,12,VARPROJ.NvigasOT);
hmin = linspace(30,30,VARPROJ.NvigasOT);
%XminV: Vetor com os valores m�nimos das vari�veis de projeto para as vigas
%Em XminV os primeiros valores s�o os "b m�nimos" e depois os "h m�nimos"
if VARPROJ.NvigasOT ~= 0
    XminV=[bmin hmin];
else
    XminV=[];
end

%Limites m�nimos para pilares
hpxmin = linspace(20,20,VARPROJ.NpilaresOT);
hpymin = linspace(20,20,VARPROJ.NpilaresOT);
%XminP: Vetor com os valores m�nimos das vari�veis de projeto para os pilares
%Em XminP os primeiros valores s�o os "hpx m�nimos" e depois os "hpy m�nimos"
if VARPROJ.NpilaresOT ~= 0
    XminP=[hpxmin hpymin];
else
    XminP=[];
end

%Limite m�nimo para as lajes
if VARPROJ.LajesOT ~= 0
    XminL=8;
else
    XminL=[];
end

%Montagem do vetor Xmin
switch VARPROJ.LajesOT
       case 0%As lajes n�o ser�o otimizadas           
        Xmin=[XminV XminP];
       case 1%As lajes ser�o otimizadas               
        Xmin=[XminV XminP XminL]; 
end
%N�mero de elementos de Xmin:
%1)Se as lajes n�o estiverem sendo otimizadas: 2xNvigasOT + 2xNpilaresOT
%2)Se as lajes estiverem sendo otimizadas:     2xNvigasOT + 2xNpilaresOT + 1

%6.2 - LIMITES M�XIMOS
%Limites m�ximos para vigas
bmax = linspace(30,30,VARPROJ.NvigasOT);
hmax = linspace(90,90,VARPROJ.NvigasOT);
%XmaxV: Vetor com os valores m�ximos das vari�veis de projeto para as vigas
%Em XmaxV os primeiros valores s�o os "b m�ximos" e depois os "h m�ximos"
if VARPROJ.NvigasOT ~= 0
    XmaxV=[bmax hmax];
else
    XmaxV=[]; 
end

%Limites m�ximos para pilares
hpxmax = linspace(100,100,VARPROJ.NpilaresOT);
hpymax = linspace(100,100,VARPROJ.NpilaresOT);
%XmaxP: Vetor com os valores m�ximos das vari�veis de projeto para os pilares
%Em XmaxP os primeiros valores s�o os "hpx m�ximos" e depois os "hpy m�ximos"
if VARPROJ.NpilaresOT ~= 0
    XmaxP=[hpxmax hpymax];
else
    XmaxP=[];
end

%Limite m�ximo para as lajes
if VARPROJ.LajesOT ~= 0
    XmaxL=20;
else
    XmaxL=[];
end

%Montagem do vetor Xmax
switch VARPROJ.LajesOT
       case 0%As lajes n�o ser�o otimizadas           
        Xmax=[XmaxV XmaxP];
       case 1%As lajes ser�o otimizadas               
        Xmax=[XmaxV XmaxP XmaxL]; 
end
%N�mero de elementos de Xmax:
%1)Se as lajes n�o estiverem sendo otimizadas: 2xNvigasOT + 2xNpilaresOT
%2)Se as lajes estiverem sendo otimizadas:     2xNvigasOT + 2xNpilaresOT + 1

%6.3 - LIMITES INFERIORES
%Limites inferiores para vigas
binf = linspace(12,12,VARPROJ.NvigasOT);
hinf = linspace(30,30,VARPROJ.NvigasOT);
%XinfV: Vetor com os valores inferiores das vari�veis de projeto para as vigas
%Em XinfV os primeiros valores s�o os "b inferiores" e depois os "h inferiores"
if VARPROJ.NvigasOT ~= 0
    XinfV=[binf hinf];
else
    XinfV=[];
end

%Limites inferiores para pilares
hpxinf = linspace(20,20,VARPROJ.NpilaresOT);
hpyinf = linspace(20,20,VARPROJ.NpilaresOT);
%XinfP: Vetor com os valores inferiores das vari�veis de projeto para os pilares
%Em XinfP os primeiros valores s�o os "hpx inferiores" e depois os "hpy inferiores"
if VARPROJ.NpilaresOT ~= 0
    XinfP=[hpxinf hpyinf];
else
    XinfP=[];
end

%Limite inferior para as lajes
if VARPROJ.LajesOT ~= 0
    XinfL=8;
else
    XinfL=[];
end

%Montagem do vetor Xinf
switch VARPROJ.LajesOT
       case 0%As lajes n�o ser�o otimizadas           
        Xinf=[XinfV XinfP];
       case 1%As lajes ser�o otimizadas               
        Xinf=[XinfV XinfP XinfL]; 
end
Xinf=Xinf';%Os valores inferiores est�o em um vetor coluna
%N�mero de elementos de Xinf:
%1)Se as lajes n�o estiverem sendo otimizadas: 2xNvigasOT + 2xNpilaresOT
%2)Se as lajes estiverem sendo otimizadas:     2xNvigasOT + 2xNpilaresOT + 1

%6.4 - LIMITES SUPERIORES
%Limites superiores para vigas
bsup = linspace(30,30,VARPROJ.NvigasOT);
hsup = linspace(90,90,VARPROJ.NvigasOT);
%XsupV: Vetor com os valores superiores das vari�veis de projeto para as vigas
%Em XsupV os primeiros valores s�o os "b superiores" e depois os "h superiores"
if VARPROJ.NvigasOT
    XsupV=[bsup hsup];
else
    XsupV=[];
end

%Limites superiores para pilares
hpxsup = linspace(100,100,VARPROJ.NpilaresOT);
hpysup = linspace(100,100,VARPROJ.NpilaresOT);
%XsupP: Vetor com os valores superiores das vari�veis de projeto para os pilares
%Em XsupP os primeiros valores s�o os "hpx superiores" e depois os "hpy superiores"
if VARPROJ.NpilaresOT ~= 0
    XsupP=[hpxsup hpysup];
else
    XsupP=[];
end

%Limite superior para as lajes
if VARPROJ.LajesOT ~= 0
    XsupL=20;
else
    XsupL=[];
end

%Montagem do vetor Xsup
switch VARPROJ.LajesOT
       case 0%As lajes n�o ser�o otimizadas           
        Xsup=[XsupV XsupP];
       case 1%As lajes ser�o otimizadas               
        Xsup=[XsupV XsupP XsupL]; 
end
Xsup=Xsup';%Os valores superiores est�o em um vetor coluna
%N�mero de elementos de Xsup:
%1)Se as lajes n�o estiverem sendo otimizadas: 2xNvigasOT + 2xNpilaresOT
%2)Se as lajes estiverem sendo otimizadas:     2xNvigasOT + 2xNpilaresOT + 1

% %7 - LEITURA DOS VETORES Reference Vector DE CADA VIGA
% 
% % O vetor Reference Vector � usado pelo Feap para definir a dire��o da viga.
% % Viga na dire��o x:Reference Vector = (0 0 1)= caso 1
% % Viga na dire��o y:Reference Vector = (1 0 0)= caso 2
% while ~feof(fidinc6)
%         for k=1:7
%         lixo=fgets(fidinc6);
%         end
%         [RV,count]=fscanf(fidinc6,'%f',[Nvigas inf]);
%         %N�mero de elementos de RV  = Nvigas
%         break
% end

fclose(fidinc1);
fclose(fidinc2);
fclose(fidinc3);
fclose(fidinc4);
fclose(fidinc5);
% fclose(fidinc6);









