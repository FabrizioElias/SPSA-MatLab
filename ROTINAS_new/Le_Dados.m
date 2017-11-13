function [PORTICO, ELEMENTOS, PAR, VIGA, PILAR, FLUXOCAIXA]=Le_Dados(DADOS)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIENCIAS
% PROGRAMA DE POS-GRADUAÇAO EM ENGENHARIA CIVIL        - AREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELECAO DE  MEDIA FIDELIDADE  PARA  ANALISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO.
% ALUNO       Sérgio José Priori Jovino Marques Filho
% ORIENTADOR  Prof. Ezio da Rocha Araujo
% -------------------------------------------------------------------------
% DESCRICAO
% Lê o arquivo de entrada 'P1OTtpl.tpl' (template). Esse arquivo tanto pode
% funcionar como arquivo de entrada do FEAP quanto usar os dados para gerar
% carregar a rotina 'PorticoPlano' que resolve pórticos planos usando o
% MATLAB.

% Nessa rotina serão processadas as informações referentes apenas ao
% pórtico (geometria, conectividade e condições de contorno).
% -------------------------------------------------------------------------
% MODIFICAÇÕES - Sérgio Marques
% 1. Essa rotina foi alterada de forma que o comprimento dos elementos são
% calculados com base nas coordenadas dos nós e na matriz de conectividade.
% Diferente do que acontecia, o arquivo 'plOTcomp.txt' será gerado nessa
% rotina e não mais lido.
% 2. Variáveis globais foram substituídas por "STRUCTURES"

%--------------------------------------------------------------------------
%VARIÁVEIS DE ENTRADA: DADOS (structure)
%VARIÁVEIS DE SAÍDA: PORTICO (structure): contem as coordenadas dos nós,
%condições de contorno, conectividades e carregamentos impostos ao pórtico
% -------------------------------------------------------------------------
% ADAPTAÇÃO DA ROTINA DE DIEGO OLIVEIRA 30-Janeiro-2006
% Modificada      04-Agosto-2011              NILMA ANDRADE
% Modificada      13-Janeiro-2015             SÉRGIO MARQUES 
% -------------------------------------------------------------------------

% 1 - LEITURA DO NÚMERO DE NÓS E NÚMERO DE ELEMENTOS DO PÓRTICO
% Lê o arquivo de dados 'P1OTtpl.tpl':
fiddados=fopen(DADOS.filetpl,'r');    %Abre o arquivo 'P1OTtpl.tpl'
%Lê a primeira linha do arquivo de dados do Feap
%FAB - Remoção de variável sem uso (str=).
fgets(fiddados); 
%Lê a segunda linha do arquivo de dados do arquivo e armazena no vetor A os
% dois primeiros números:número de nós e número de elementos.
A=fscanf(fiddados,'%e',2);
PORTICO.nnos=A(1);                      %Número de nós do pórtico
PORTICO.nelem=A(2);                     %Número de elementos do pórtico plano

% 2 - LEITURA DO ARQUIVO CONTENDO TODOS OS DADOS DO PÓRTICO PLANO
%Abre o arquivo PortINPUT.txt
fidinput=fopen(DADOS.filein,'r');
while ~feof(fidinput)
% 2.1 - LEITURA DAS COORDENADAS DOS NÓS
    for k=1:3
        %FAB - Somente lê.
        fgets(fidinput);
    end
    % Armazena em uma matriz coluna todos os dados referentes às
    % coordenadas dos nós.
    B=fscanf(fidinput, '%e',5*PORTICO.nnos);
    % Rotina para organizar a matriz B em estruturas contendo as
    % coordenadas dos nós do pórtico
    [PORTICO]=coord(B,PORTICO);
     
% 2.2 - LEITURA DOS MATERIAIS DE CADA ELEMENTO, NÓS INICIAL E FINAL E MATRIZ
% DE CONECTIVIDADE DO PÓRTICO
    for k=1:3
        %FAB - Somente lê.
        fgets(fidinput);
    end
    % Armazena em uma matriz coluna todos os dados referentes aos elementos
    % do pórtico
    C=fscanf(fidinput,'%e',6*PORTICO.nelem);
    % Rotina para organizar a matriz C na estrurtura PORTICO contendo o
    % material de cada elemento, seu nó inicial e nó final e matriz de
    % conectividade
    [PORTICO]=elements(C,PORTICO);
    
% % 2.3 - CÁLCULO DO COMPRIMENTO DOS ELEMENTOS
%     [PORTICO]=comp(PORTICO);
    
% 2.4 - CÁLCULO DO ÂNGULO DOS ELEMENTOS
%     [PORTICO]=angular(PORTICO);
        
% 2.5 - MOTAGEM DA MATRIZ COM AS CONDIÇÕES DE CONTORNO DOS ELEMENTOS
    for k=1:3
        %FAB - Somente lê.
        fgets(fidinput);
    end
    % Armazena em uma matriz coluna as restrições dos nós especificados
    D=fscanf(fidinput,'%e');
    % Rotina para determinação das condições de contorno do nós
    [PORTICO]=bound(D,PORTICO);
    
% 2.6 - MOTAGEM DA MATRIZ COM AS CONSTANTES DE MOLA - TRANS. Y
    for k=1:2
        %FAB - Somente lê.
        fgets(fidinput);
    end
    % Armazena em uma matriz coluna as constantes de mola dos elementos
    DD=fscanf(fidinput,'%e');
    % Rotina para determinação das condições de contorno do nós
    [PORTICO]=spring(DD,PORTICO);
     
% 2.7 - MONTAGEM DA MATRIZ COM OS ESFORÇOS NODAIS APLICADO SEGUNDO ÀS DIREÇÕES
    for k=1:2
        %FAB - Somente lê.
        fgets(fidinput);
    end
    E=fscanf(fidinput,'%e');
    % Rotina para determinação dos carrregamentos nodais
    [PORTICO]=nloads(E,PORTICO);
    
% 2.8 - MATRIZ COM OS CARREGAMENTOS DISTRIBUÍDOS - SISTEMA LOCAL
    for k=1:2
        %FAB - Somente lê.
        fgets(fidinput);
    end
    F=fscanf(fidinput,'%e');  
    % Rotina para determinação das cargas distribuídas aplicadas às barras
    [PORTICO]=distloads(F,PORTICO);

% 2.9 - MATRIZ COM AS CARGAS CONCENTRADAS NOS ELEMENTOS
    for k=1:2
        %FAB - Somente lê.
        fgets(fidinput);
    end
    G=fscanf(fidinput,'%e');
    %FAB - Remoção de variável sem uso.
    %s=size(G);
    % Rotina para determinação das cargas concentradas aplicadas às barras
    [PORTICO]=concloads(G,PORTICO);
    
% 2.10 - MATRIZ COM A VARIAÇÃO DE TEMPERATURA NOS ELEMENTOS
    for k=1:2
        %FAB - Somente lê.
        fgets(fidinput);
    end
    GG=fscanf(fidinput,'%e');
    %FAB - Remoção de variável sem uso.
    %s=size(GG);
    % Rotina para determinação das cargas concentradas aplicadas às barras
    [PORTICO]=temp(GG,PORTICO);
    
% 2.11 - LEITURA DAS PROPRIEDADES GEOMÉTRICAS DA SEÇÃO DOS ELEMENTOS
    % Lê elementos de concreto
    for k=1:2
        %FAB - Somente lê.
        fgets(fidinput);
    end
    H=fscanf(fidinput,'%e');
    % Lê elementos de aço
    for k=1:2
        %FAB - Somente lê.
        fgets(fidinput);
    end
    HH=fscanf(fidinput,'%e');
    % Rotina para determinação das dimensões das seções transversais dos
    % elementos
    [ELEMENTOS]=section(H, HH, PORTICO);
end
    fclose(fiddados);  %Fecha o arquivo template
    fclose(fidinput);  %Fecha o arquivo com os inputs do pórtico

% 3 - LEITURA DOS PARÂMETROS ESTATÍTISCO DAS PROPRIEDADES FÍSICAS DO
% CONCRETO
fidparconc=fopen(DADOS.fileparconc,'r');
while ~feof (fidparconc)
    for k=1:2
        %FAB - Somente lê.
        fgets(fidparconc);
    end
    % Armazena em uma matriz coluna todos os dados referentes às
    % propriedades do concreto
    var=fscanf(fidparconc,'%f');
end
% Fecha o arquivo de dados  referente aos parâmetros do concreto
fclose(fidparconc);
% Escreve na estrutura PAR as propriedades e parâmetros de distribuição do
% conCreto.
% Resistência à compressão
PAR.CONC.RESCOMP.type=var(1);
PAR.CONC.RESCOMP.parest1=var(2);
PAR.CONC.RESCOMP.parest2=var(3);
% Delta Resistência à compressão
PAR.CONC.DELTARESCOMP.type=var(4);
PAR.CONC.DELTARESCOMP.parest1=var(5);
PAR.CONC.DELTARESCOMP.parest2=var(6);
% Parâmetro alfaE, incide no cálculo do módulo de elasticidade modelo FIB.
PAR.CONC.alfaE.type=var(7);
PAR.CONC.alfaE.parest1=var(8);
PAR.CONC.alfaE.parest2=var(9);
% Parâmetro Ec0, incide no cálculo do módulo de elasticidade modelo FIB.
PAR.CONC.Ec0.type=var(10);
PAR.CONC.Ec0.parest1=var(11);
PAR.CONC.Ec0.parest2=var(12);
% Peso específico do concreto
PAR.CONC.PESOESP.type=var(13);
PAR.CONC.PESOESP.parest1=var(14);
PAR.CONC.PESOESP.parest2=var(15);
% Módulo de Elasticidade tangente
PAR.CONC.Eci.type=var(16);
PAR.CONC.Eci.parest1=var(17);
PAR.CONC.Eci.parest2=var(18);
% Módulo de Elasticidade secante
PAR.CONC.Ecs.type=var(19);
PAR.CONC.Ecs.parest1=var(20);
PAR.CONC.Ecs.parest2=var(21);
% Coeficiente de Poisson
PAR.CONC.POISSON.type=var(22);
PAR.CONC.POISSON.parest1=var(23);
PAR.CONC.POISSON.parest2=var(24);
% Coeficiente de Fluência
PAR.CONC.PHI.type=var(25);
PAR.CONC.PHI.parest1=var(26);
PAR.CONC.PHI.parest2=var(27);
% Coeficiente de térmico
PAR.CONC.ALFATEMP.type=var(28);
PAR.CONC.ALFATEMP.parest1=var(29);
PAR.CONC.ALFATEMP.parest2=var(30);

% 4 - LEITURA DOS COEFICIENTES PARA CÁLCULO DOS PARÂMETROS DEPENDETES DO
% TEMPO - RETRAÇÃO E FLÊNCIA
fidparconcTD=fopen(DADOS.fileparconcTD,'r');
while ~feof (fidparconc)
    for k=1:3
        %FAB - Somente lê.
        fgets(fidparconc);
    end
    % Armazena em uma matriz coluna todos os dados referentes às
    % propriedades do concreto
    var=fscanf(fidparconc,'%f');
end
% Fecha o arquivo de dados  referente aos parâmetros do concreto
fclose(fidparconcTD);
% Escreve na estrutura PAR as propriedades e parâmetros de distribuição do
% cocnreto.
% Resistência à compressão
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

% 5 - LEITURA DOS PARÂMETROS ESTATÍTISCO DAS PROPRIEDADES FÍSICAS DO
% AÇO PARA CONCRETO ARMADO
fidparaco=fopen(DADOS.fileparaco,'r');
while ~feof (fidparaco)
    for k=1:2
        %FAB - Somente lê.
        fgets(fidparaco);
    end
    % Armazena em uma matriz coluna todos os dados referentes às
    % coordenadas dos nós.
    var=fscanf(fidparaco,'%f');
end
% Resistência à tração armaduras longitudinais
PAR.ACO.RESTRAC.type=var(1);
PAR.ACO.RESTRAC.parest1=var(2);
PAR.ACO.RESTRAC.parest2=var(3);
% Peso Específico do aço
PAR.ACO.PESOESP.type=var(4);
PAR.ACO.PESOESP.parest1=var(5);
PAR.ACO.PESOESP.parest2=var(6);
% Módulo de Elasticidade
PAR.ACO.Es.type=var(7);
PAR.ACO.Es.parest1=var(8);
PAR.ACO.Es.parest2=var(9);

% 6 - LEITURA DOS PARÂMETROS ESTATÍTISCO DAS PROPRIEDADES FÍSICAS DO
% AÇO DO ESTAQUEAMENTO
fidparsteel=fopen(DADOS.fileparsteel,'r');
while ~feof (fidparsteel)
    for k=1:2
        %FAB - Somente lê.
        fgets(fidparsteel);
    end
    % Armazena em uma matriz coluna todos os dados referentes às
    % coordenadas dos nós.
    var=fscanf(fidparsteel,'%f');
end
% Resistência à tração armaduras longitudinais
PAR.STEEL.RESTRAC.type=var(1);
PAR.STEEL.RESTRAC.parest1=var(2);
PAR.STEEL.RESTRAC.parest2=var(3);
% Peso Específico do aço
PAR.STEEL.PESOESP.type=var(4);
PAR.STEEL.PESOESP.parest1=var(5);
PAR.STEEL.PESOESP.parest2=var(6);
% Módulo de Elasticidade
PAR.STEEL.Es.type=var(7);
PAR.STEEL.Es.parest1=var(8);
PAR.STEEL.Es.parest2=var(9);

% 7 - LEITURA DOS PARÂMETROS ESTATÍTISCO DAS VARIÁVEIS DE CARATER ECONÔMICO
fidpareco=fopen(DADOS.filepareco,'r');
while ~feof (fidpareco)
    for k=1:2
        %FAB - Somente lê.
        fgets(fidpareco);
    end
    % Armazena em uma matriz coluna todos os dados referentes às
    % propriedades do concreto
    var=fscanf(fidpareco,'%f');
end
% Fecha o arquivo de dados  referente aos parâmetros do concreto
fclose(fidparconc);
% Escreve na estrutura PROP as propriedades e parâmetros de distribuição do
% cocnreto.
% Resistência à compressão
PAR.ECO.ACO.type=var(1);
PAR.ECO.ACO.parest1=var(2);
PAR.ECO.ACO.parest2=var(3);
% Peso específico do concreto
PAR.ECO.CONC.type=var(4);
PAR.ECO.CONC.parest1=var(5);
PAR.ECO.CONC.parest2=var(6);
% Módulo de Elasticidade tangente
PAR.ECO.FORMA.type=var(7);
PAR.ECO.FORMA.parest1=var(8);
PAR.ECO.FORMA.parest2=var(9);
% Módulo de Elasticidade secante
PAR.ECO.TXATRAT.type=var(10);
PAR.ECO.TXATRAT.parest1=var(11);
PAR.ECO.TXATRAT.parest2=var(12);

% 8 - LEITURA DO FLUXO DE CAIXA
fidfluxocaixa=fopen(DADOS.filefluxocaixa,'r');
while ~feof (fidfluxocaixa)
    for k=1:2
        %FAB - Somente lê.
        fgets(fidparconc);
    end
    % Armazena em uma matriz coluna todos os dados referentes às
    % propriedades do concreto
    var=fscanf(fidparconc,'%f');
end
% Fecha o arquivo de dados  referente aos parâmetros do concreto
fclose(fidparconc);
% Escreve na estrutura PAR as propriedades e parâmetros de distribuição do
% cocnreto.
% Resistência à compressão
FLUXOCAIXA.disttype=var(1);
var(1)=[];  % remove o elemento 1
FLUXOCAIXA.despesas=var(1:2:end,:); % extrai os elementos impares (despesas)
FLUXOCAIXA.receitas=var(2:2:end,:); % extrai os elementos pares (receitas)     

% 9 - LEITURA DAS BITOLAS COMERCIAIS A SEREM EMPREGADAS EM CADA ELEMENTO
% ESTRUTURAL DE COCNRETO ARMADO
% Lê o arquivo de dados 'arranjovigalong.txt' - Barras longitudinais
fidtablong=fopen(DADOS.filetabflex,'r');    %Abre o arquivo 'arranjoviga.txt'
 for i=1:2
     %FAB - Somente lê.
     fgets(fidtablong);               % Lê as linhas de comentários
 end
a=fscanf(fidtablong, '%e')';
s=size(a);
n=s(2);
VIGA.TABELALONG(1,:)=a(1:n);
% Lê o arquivo de dados 'arranjovigalong.txt' - Barras transversais
fidtabtrans=fopen(DADOS.filetabtrans,'r');    %Abre o arquivo 'arranjoviga.txt'
 for i=1:2
     %FAB - Somente lê.
     fgets(fidtabtrans);               % Lê as linhas de comentários
 end
a=fscanf(fidtabtrans, '%e')';
s=size(a);
n=s(2);
VIGA.TABELATRANS(1,:)=a(1:n);
% Lê o arquivo de dados 'arranjopilarlong.txt' - Barras longitudinais
fidtablongpil=fopen(DADOS.filetablong,'r');    %Abre o arquivo 'arranjopilarlong.txt'
 for i=1:2
     %FAB - Somente lê.
     fgets(fidtablongpil);               % Lê as linhas de comentários
 end
a=fscanf(fidtablongpil, '%e')';
s=size(a);
n=s(2);
PILAR.TABELALONG(1,:)=a(1:n);