function [PORTICO, ELEMENTOS, PAR, VIGA, PILAR, FLUXOCAIXA]=Le_Dados(DADOS)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIENCIAS
% PROGRAMA DE POS-GRADUA�AO EM ENGENHARIA CIVIL        - AREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELECAO DE  MEDIA FIDELIDADE  PARA  ANALISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO.
% ALUNO       S�rgio Jos� Priori Jovino Marques Filho
% ORIENTADOR  Prof. Ezio da Rocha Araujo
% -------------------------------------------------------------------------
% DESCRICAO
% L� o arquivo de entrada 'P1OTtpl.tpl' (template). Esse arquivo tanto pode
% funcionar como arquivo de entrada do FEAP quanto usar os dados para gerar
% carregar a rotina 'PorticoPlano' que resolve p�rticos planos usando o
% MATLAB.

% Nessa rotina ser�o processadas as informa��es referentes apenas ao
% p�rtico (geometria, conectividade e condi��es de contorno).
% -------------------------------------------------------------------------
% MODIFICA��ES - S�rgio Marques
% 1. Essa rotina foi alterada de forma que o comprimento dos elementos s�o
% calculados com base nas coordenadas dos n�s e na matriz de conectividade.
% Diferente do que acontecia, o arquivo 'plOTcomp.txt' ser� gerado nessa
% rotina e n�o mais lido.
% 2. Vari�veis globais foram substitu�das por "STRUCTURES"

%--------------------------------------------------------------------------
%VARI�VEIS DE ENTRADA: DADOS (structure)
%VARI�VEIS DE SA�DA: PORTICO (structure): contem as coordenadas dos n�s,
%condi��es de contorno, conectividades e carregamentos impostos ao p�rtico
% -------------------------------------------------------------------------
% ADAPTA��O DA ROTINA DE DIEGO OLIVEIRA 30-Janeiro-2006
% Modificada      04-Agosto-2011              NILMA ANDRADE
% Modificada      13-Janeiro-2015             S�RGIO MARQUES 
% -------------------------------------------------------------------------

% 1 - LEITURA DO N�MERO DE N�S E N�MERO DE ELEMENTOS DO P�RTICO
% L� o arquivo de dados 'P1OTtpl.tpl':
fiddados=fopen(DADOS.filetpl,'r');    %Abre o arquivo 'P1OTtpl.tpl'
%L� a primeira linha do arquivo de dados do Feap
%FAB - Remo��o de vari�vel sem uso (str=).
fgets(fiddados); 
%L� a segunda linha do arquivo de dados do arquivo e armazena no vetor A os
% dois primeiros n�meros:n�mero de n�s e n�mero de elementos.
A=fscanf(fiddados,'%e',2);
PORTICO.nnos=A(1);                      %N�mero de n�s do p�rtico
PORTICO.nelem=A(2);                     %N�mero de elementos do p�rtico plano

% 2 - LEITURA DO ARQUIVO CONTENDO TODOS OS DADOS DO P�RTICO PLANO
%Abre o arquivo PortINPUT.txt
fidinput=fopen(DADOS.filein,'r');
while ~feof(fidinput)
% 2.1 - LEITURA DAS COORDENADAS DOS N�S
    for k=1:3
        %FAB - Somente l�.
        fgets(fidinput);
    end
    % Armazena em uma matriz coluna todos os dados referentes �s
    % coordenadas dos n�s.
    B=fscanf(fidinput, '%e',5*PORTICO.nnos);
    % Rotina para organizar a matriz B em estruturas contendo as
    % coordenadas dos n�s do p�rtico
    [PORTICO]=coord(B,PORTICO);
     
% 2.2 - LEITURA DOS MATERIAIS DE CADA ELEMENTO, N�S INICIAL E FINAL E MATRIZ
% DE CONECTIVIDADE DO P�RTICO
    for k=1:3
        %FAB - Somente l�.
        fgets(fidinput);
    end
    % Armazena em uma matriz coluna todos os dados referentes aos elementos
    % do p�rtico
    C=fscanf(fidinput,'%e',6*PORTICO.nelem);
    % Rotina para organizar a matriz C na estrurtura PORTICO contendo o
    % material de cada elemento, seu n� inicial e n� final e matriz de
    % conectividade
    [PORTICO]=elements(C,PORTICO);
    
% % 2.3 - C�LCULO DO COMPRIMENTO DOS ELEMENTOS
%     [PORTICO]=comp(PORTICO);
    
% 2.4 - C�LCULO DO �NGULO DOS ELEMENTOS
%     [PORTICO]=angular(PORTICO);
        
% 2.5 - MOTAGEM DA MATRIZ COM AS CONDI��ES DE CONTORNO DOS ELEMENTOS
    for k=1:3
        %FAB - Somente l�.
        fgets(fidinput);
    end
    % Armazena em uma matriz coluna as restri��es dos n�s especificados
    D=fscanf(fidinput,'%e');
    % Rotina para determina��o das condi��es de contorno do n�s
    [PORTICO]=bound(D,PORTICO);
    
% 2.6 - MOTAGEM DA MATRIZ COM AS CONSTANTES DE MOLA - TRANS. Y
    for k=1:2
        %FAB - Somente l�.
        fgets(fidinput);
    end
    % Armazena em uma matriz coluna as constantes de mola dos elementos
    DD=fscanf(fidinput,'%e');
    % Rotina para determina��o das condi��es de contorno do n�s
    [PORTICO]=spring(DD,PORTICO);
     
% 2.7 - MONTAGEM DA MATRIZ COM OS ESFOR�OS NODAIS APLICADO SEGUNDO �S DIRE��ES
    for k=1:2
        %FAB - Somente l�.
        fgets(fidinput);
    end
    E=fscanf(fidinput,'%e');
    % Rotina para determina��o dos carrregamentos nodais
    [PORTICO]=nloads(E,PORTICO);
    
% 2.8 - MATRIZ COM OS CARREGAMENTOS DISTRIBU�DOS - SISTEMA LOCAL
    for k=1:2
        %FAB - Somente l�.
        fgets(fidinput);
    end
    F=fscanf(fidinput,'%e');  
    % Rotina para determina��o das cargas distribu�das aplicadas �s barras
    [PORTICO]=distloads(F,PORTICO);

% 2.9 - MATRIZ COM AS CARGAS CONCENTRADAS NOS ELEMENTOS
    for k=1:2
        %FAB - Somente l�.
        fgets(fidinput);
    end
    G=fscanf(fidinput,'%e');
    %FAB - Remo��o de vari�vel sem uso.
    %s=size(G);
    % Rotina para determina��o das cargas concentradas aplicadas �s barras
    [PORTICO]=concloads(G,PORTICO);
    
% 2.10 - MATRIZ COM A VARIA��O DE TEMPERATURA NOS ELEMENTOS
    for k=1:2
        %FAB - Somente l�.
        fgets(fidinput);
    end
    GG=fscanf(fidinput,'%e');
    %FAB - Remo��o de vari�vel sem uso.
    %s=size(GG);
    % Rotina para determina��o das cargas concentradas aplicadas �s barras
    [PORTICO]=temp(GG,PORTICO);
    
% 2.11 - LEITURA DAS PROPRIEDADES GEOM�TRICAS DA SE��O DOS ELEMENTOS
    % L� elementos de concreto
    for k=1:2
        %FAB - Somente l�.
        fgets(fidinput);
    end
    H=fscanf(fidinput,'%e');
    % L� elementos de a�o
    for k=1:2
        %FAB - Somente l�.
        fgets(fidinput);
    end
    HH=fscanf(fidinput,'%e');
    % Rotina para determina��o das dimens�es das se��es transversais dos
    % elementos
    [ELEMENTOS]=section(H, HH, PORTICO);
end
    fclose(fiddados);  %Fecha o arquivo template
    fclose(fidinput);  %Fecha o arquivo com os inputs do p�rtico

% 3 - LEITURA DOS PAR�METROS ESTAT�TISCO DAS PROPRIEDADES F�SICAS DO
% CONCRETO
fidparconc=fopen(DADOS.fileparconc,'r');
while ~feof (fidparconc)
    for k=1:2
        %FAB - Somente l�.
        fgets(fidparconc);
    end
    % Armazena em uma matriz coluna todos os dados referentes �s
    % propriedades do concreto
    var=fscanf(fidparconc,'%f');
end
% Fecha o arquivo de dados  referente aos par�metros do concreto
fclose(fidparconc);
% Escreve na estrutura PAR as propriedades e par�metros de distribui��o do
% conCreto.
% Resist�ncia � compress�o
PAR.CONC.RESCOMP.type=var(1);
PAR.CONC.RESCOMP.parest1=var(2);
PAR.CONC.RESCOMP.parest2=var(3);
% Delta Resist�ncia � compress�o
PAR.CONC.DELTARESCOMP.type=var(4);
PAR.CONC.DELTARESCOMP.parest1=var(5);
PAR.CONC.DELTARESCOMP.parest2=var(6);
% Par�metro alfaE, incide no c�lculo do m�dulo de elasticidade modelo FIB.
PAR.CONC.alfaE.type=var(7);
PAR.CONC.alfaE.parest1=var(8);
PAR.CONC.alfaE.parest2=var(9);
% Par�metro Ec0, incide no c�lculo do m�dulo de elasticidade modelo FIB.
PAR.CONC.Ec0.type=var(10);
PAR.CONC.Ec0.parest1=var(11);
PAR.CONC.Ec0.parest2=var(12);
% Peso espec�fico do concreto
PAR.CONC.PESOESP.type=var(13);
PAR.CONC.PESOESP.parest1=var(14);
PAR.CONC.PESOESP.parest2=var(15);
% M�dulo de Elasticidade tangente
PAR.CONC.Eci.type=var(16);
PAR.CONC.Eci.parest1=var(17);
PAR.CONC.Eci.parest2=var(18);
% M�dulo de Elasticidade secante
PAR.CONC.Ecs.type=var(19);
PAR.CONC.Ecs.parest1=var(20);
PAR.CONC.Ecs.parest2=var(21);
% Coeficiente de Poisson
PAR.CONC.POISSON.type=var(22);
PAR.CONC.POISSON.parest1=var(23);
PAR.CONC.POISSON.parest2=var(24);
% Coeficiente de Flu�ncia
PAR.CONC.PHI.type=var(25);
PAR.CONC.PHI.parest1=var(26);
PAR.CONC.PHI.parest2=var(27);
% Coeficiente de t�rmico
PAR.CONC.ALFATEMP.type=var(28);
PAR.CONC.ALFATEMP.parest1=var(29);
PAR.CONC.ALFATEMP.parest2=var(30);

% 4 - LEITURA DOS COEFICIENTES PARA C�LCULO DOS PAR�METROS DEPENDETES DO
% TEMPO - RETRA��O E FL�NCIA
fidparconcTD=fopen(DADOS.fileparconcTD,'r');
while ~feof (fidparconc)
    for k=1:3
        %FAB - Somente l�.
        fgets(fidparconc);
    end
    % Armazena em uma matriz coluna todos os dados referentes �s
    % propriedades do concreto
    var=fscanf(fidparconc,'%f');
end
% Fecha o arquivo de dados  referente aos par�metros do concreto
fclose(fidparconcTD);
% Escreve na estrutura PAR as propriedades e par�metros de distribui��o do
% cocnreto.
% Resist�ncia � compress�o
PAR.CONCTD.t0=var(1);
PAR.CONCTD.alfa=var(2);
PAR.CONCTD.deltati=var(3);
PAR.CONCTD.Tdeltati=var(4);
PAR.CONCTD.RH=var(5);
PAR.CONCTD.ts=var(6);
PAR.CONCTD.alfas=var(7);
PAR.CONCTD.alfas1=var(8);
PAR.CONCTD.alfas2=var(9);
PAR.CONCTD.betasc=var(10);
PAR.CONCTD.t=var(11);

% 5 - LEITURA DOS PAR�METROS ESTAT�TISCO DAS PROPRIEDADES F�SICAS DO
% A�O PARA CONCRETO ARMADO
fidparaco=fopen(DADOS.fileparaco,'r');
while ~feof (fidparaco)
    for k=1:2
        %FAB - Somente l�.
        fgets(fidparaco);
    end
    % Armazena em uma matriz coluna todos os dados referentes �s
    % coordenadas dos n�s.
    var=fscanf(fidparaco,'%f');
end
% Resist�ncia � tra��o armaduras longitudinais
PAR.ACO.RESTRAC.type=var(1);
PAR.ACO.RESTRAC.parest1=var(2);
PAR.ACO.RESTRAC.parest2=var(3);
% Peso Espec�fico do a�o
PAR.ACO.PESOESP.type=var(4);
PAR.ACO.PESOESP.parest1=var(5);
PAR.ACO.PESOESP.parest2=var(6);
% M�dulo de Elasticidade
PAR.ACO.Es.type=var(7);
PAR.ACO.Es.parest1=var(8);
PAR.ACO.Es.parest2=var(9);

% 6 - LEITURA DOS PAR�METROS ESTAT�TISCO DAS PROPRIEDADES F�SICAS DO
% A�O DO ESTAQUEAMENTO
fidparsteel=fopen(DADOS.fileparsteel,'r');
while ~feof (fidparsteel)
    for k=1:2
        %FAB - Somente l�.
        fgets(fidparsteel);
    end
    % Armazena em uma matriz coluna todos os dados referentes �s
    % coordenadas dos n�s.
    var=fscanf(fidparsteel,'%f');
end
% Resist�ncia � tra��o armaduras longitudinais
PAR.STEEL.RESTRAC.type=var(1);
PAR.STEEL.RESTRAC.parest1=var(2);
PAR.STEEL.RESTRAC.parest2=var(3);
% Peso Espec�fico do a�o
PAR.STEEL.PESOESP.type=var(4);
PAR.STEEL.PESOESP.parest1=var(5);
PAR.STEEL.PESOESP.parest2=var(6);
% M�dulo de Elasticidade
PAR.STEEL.Es.type=var(7);
PAR.STEEL.Es.parest1=var(8);
PAR.STEEL.Es.parest2=var(9);

% 7 - LEITURA DOS PAR�METROS ESTAT�TISCO DAS VARI�VEIS DE CARATER ECON�MICO
fidpareco=fopen(DADOS.filepareco,'r');
while ~feof (fidpareco)
    for k=1:2
        %FAB - Somente l�.
        fgets(fidpareco);
    end
    % Armazena em uma matriz coluna todos os dados referentes �s
    % propriedades do concreto
    var=fscanf(fidpareco,'%f');
end
% Fecha o arquivo de dados  referente aos par�metros do concreto
fclose(fidparconc);
% Escreve na estrutura PROP as propriedades e par�metros de distribui��o do
% cocnreto.
% Resist�ncia � compress�o
PAR.ECO.ACO.type=var(1);
PAR.ECO.ACO.parest1=var(2);
PAR.ECO.ACO.parest2=var(3);
% Peso espec�fico do concreto
PAR.ECO.CONC.type=var(4);
PAR.ECO.CONC.parest1=var(5);
PAR.ECO.CONC.parest2=var(6);
% M�dulo de Elasticidade tangente
PAR.ECO.FORMA.type=var(7);
PAR.ECO.FORMA.parest1=var(8);
PAR.ECO.FORMA.parest2=var(9);
% M�dulo de Elasticidade secante
PAR.ECO.TXATRAT.type=var(10);
PAR.ECO.TXATRAT.parest1=var(11);
PAR.ECO.TXATRAT.parest2=var(12);

% 8 - LEITURA DO FLUXO DE CAIXA
fidfluxocaixa=fopen(DADOS.filefluxocaixa,'r');
while ~feof (fidfluxocaixa)
    for k=1:2
        %FAB - Somente l�.
        fgets(fidparconc);
    end
    % Armazena em uma matriz coluna todos os dados referentes �s
    % propriedades do concreto
    var=fscanf(fidparconc,'%f');
end
% Fecha o arquivo de dados  referente aos par�metros do concreto
fclose(fidparconc);
% Escreve na estrutura PAR as propriedades e par�metros de distribui��o do
% cocnreto.
% Resist�ncia � compress�o
FLUXOCAIXA.disttype=var(1);
var(1)=[];  % remove o elemento 1
FLUXOCAIXA.despesas=var(1:2:end,:); % extrai os elementos impares (despesas)
FLUXOCAIXA.receitas=var(2:2:end,:); % extrai os elementos pares (receitas)     

% 9 - LEITURA DAS BITOLAS COMERCIAIS A SEREM EMPREGADAS EM CADA ELEMENTO
% ESTRUTURAL DE COCNRETO ARMADO
% L� o arquivo de dados 'arranjovigalong.txt' - Barras longitudinais
fidtablong=fopen(DADOS.filetabflex,'r');    %Abre o arquivo 'arranjoviga.txt'
 for i=1:2
     %FAB - Somente l�.
     fgets(fidtablong);               % L� as linhas de coment�rios
 end
a=fscanf(fidtablong, '%e')';
s=size(a);
n=s(2);
VIGA.TABELALONG(1,:)=a(1:n);
% L� o arquivo de dados 'arranjovigalong.txt' - Barras transversais
fidtabtrans=fopen(DADOS.filetabtrans,'r');    %Abre o arquivo 'arranjoviga.txt'
 for i=1:2
     %FAB - Somente l�.
     fgets(fidtabtrans);               % L� as linhas de coment�rios
 end
a=fscanf(fidtabtrans, '%e')';
s=size(a);
n=s(2);
VIGA.TABELATRANS(1,:)=a(1:n);
% L� o arquivo de dados 'arranjopilarlong.txt' - Barras longitudinais
fidtablongpil=fopen(DADOS.filetablong,'r');    %Abre o arquivo 'arranjopilarlong.txt'
 for i=1:2
     %FAB - Somente l�.
     fgets(fidtablongpil);               % L� as linhas de coment�rios
 end
a=fscanf(fidtablongpil, '%e')';
s=size(a);
n=s(2);
PILAR.TABELALONG(1,:)=a(1:n);