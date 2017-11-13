function  MontafileS(~, ~, DADOS)

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
% Monta arquivo de simulacao do feap
% Lê o arquivo "GABARITO".tpl. Troca as variáveis "geometria" e "carga"
% pelos valores calculados em Calc_geom.m e Calc_carga.m. Monta o arquivo
% de SIMULAÇÃO com os novos valores das geometrias e cargas. Este arquivo
% é o arquivo de entrada para o FEAP.
% -------------------------------------------------------------------------
% ADAPTACAO DA ROTINA DE DIEGO OLIVEIRA 27-Janeiro-2006
% Criada      04-Agosto-2011              NILMA ANDRADE
% Modificada  
% -------------------------------------------------------------------------
% 1 - DEFINICAO DAS VARIAVEIS GLOBAIS
%global filetpl filesim;

 % 2 - MONTAGEM DO ARQUIVO DE SIMULACAO
[fidtpl,~] = fopen(DADOS.filetpl, 'r'); %Abre o arquivo template para ser lido
[fidsim,~] = fopen(DADOS.filesim, 'w'); %Abre o arquivo de simulação para escrever nele
     
%O loop abaixo serve para o elemento Frame3D. Ele substitui tanto as cargas
%nas barras (vigas e lajes:coordenada z),no comando BODY forces do Feap
%como também as geometrias no comando CROSs SECTion do Feap.  

while ~feof(fidtpl)  %Loop até o final do arquivo template
    str=fgets(fidtpl);   %Lê uma linha do arquivo template e a atribui à variável str

    %Procura o caractere &carga() e atribui sua posição à variável dolar.
    dolar1=strfind(str,'&cargaA'); %VIGAS:peso próprio + parede
    dolar2=strfind(str,'&cargaB'); %PILAR1:Peso próprio
    dolar3=strfind(str,'&cargaC'); %PILAR2:Peso próprio
    dolar4=strfind(str,'&cargaD'); %PILAR2:Carga de vento(sentido contrário ao eixo x)

    %Procura o caractere &geometria() e atribui sua posição à variável dolar:
    dolar101=strfind(str,'&geometriaA'); %VIGA1   - MATERIAL 1 
    dolar102=strfind(str,'&geometriaB'); %PILAR 1 - MATERIAL 2
    dolar103=strfind(str,'&geometriaC'); %PILAR 2 - MATERIAL 3

    %CARGAS
    if ~isempty(dolar1)                  %Se encontrar dolar1 entra no loop if
        ins = sprintf('%d\t',cargaA);        %Atribui carga1 à variável ins
        %Monta uma nova linha onde foi encontrado "carga...".
        %Da posicao 1 até (ldolar1-1),a linha permanece. Depois acrescenta-se
        %a variavel ins na linha:
        str=[str(1:dolar1-1),ins];
    end

    if ~isempty(dolar2)                  
        ins = sprintf('%d\t',cargaB);
        str=[str(1:dolar2-1),ins];
    end

    if ~isempty(dolar3)                  
        ins = sprintf('%d\t',cargaC);
        str=[str(1:dolar3-1),ins];	
    end

    if ~isempty(dolar4)                  
        ins = sprintf('%d\t',cargaD); 
        str=[str(1:dolar4-1),ins,str(dolar4+7:end)];
    end

    %GEOMETRIAS
    if ~isempty(dolar101)          %Se encontrar dolar101 entra no loop if
        ins = sprintf('%d\t',geometriaA);%Atribui o vetor geometria1 à variável ins
        %Monta uma nova linha onde foi encontrado "geometria...".
        %Da posicao 1 até (dolar100-1),a linha permanece.Depois acrescenta-se
        %a variavel ins na linha:
        str=[str(1:dolar101-1),ins];
    end

    if ~isempty(dolar102)           
        ins = sprintf('%d\t',geometriaB);
        str=[str(1:dolar102-1),ins];
    end

    if ~isempty(dolar103)           
        ins = sprintf('%d\t',geometriaC);
        str=[str(1:dolar103-1),ins];
    end

    fprintf(fidsim,'%s\t',str); %Imprime a linha já com a modificação
end

fclose(fidtpl);
fclose(fidsim);
