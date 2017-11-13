function DADOS=InputDados
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
% L� dados de entrada (do arquivo DADOS.in) e atribui estes valores �s vari�veis
% -------------------------------------------------------------------------
% MODIFICA��ES - S�rgio Marques
% 1. Vari�veis globais foram substitu�das por "STRUCTURES"
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: -
% VARI�VEIS DE SA�DA:   DADOS - contem todos os par�metros necess�rios ao
% processamento e otimiza��o do p�rtico que constam no cart�o de entrada
% (arquivo DADOS.in)
%--------------------------------------------------------------------------
% ADAPTA��O DA ROTINA DE DIEGO OLIVEIRA 30-Janeiro-2006
% Modificada      04-Agosto-2011              NILMA ANDRADE
% Modificada      13-Janeiro-2015             S�RGIO MARQUES
% -------------------------------------------------------------------------
% 1-DEFINICAO DAS VARI�VEIS GLOBAIS

% 2-LEITURA DO ARQUIVO DE ENTRADA DE DADOS E MONTAGEM DO ARQUIVO TEMPOR�RIO
% Abre,para leitura,o arquivo com os valores das vari�veis (DADOS.in)
% e tamb�m abre o arquivo temporario para registro.

% A vari�vel nomearq recebe o arquivo (DADOS.in) que cont�m os valores da variaveis:
nomearq = 'DADOS.in';
% Abre o arquivo de dados original (DADOS.in)para leitura:
[arq, msg] = fopen(nomearq, 'r');
if (arq == -1)
  error(msg);
end
% Abre o arquivo tempor�rio (dopping.tmp) para escrita:
[tmp, msg] = fopen('dopping.tmp', 'wt');
if (tmp == -1)
  error(msg);
end
% L� o arquivo (DADOS.in) com os dados  e os escreve (extraindo
% linhas em branco e coment�rios) no arquivo tempor�rio (dopping.tmp):
linha = fgets(arq);              % L� a primeira linha do arquivo de dados
while (linha ~= -1);
  linha = RetComent(linha);      % Elimina os coment�rios
  linha = deblank(linha);        % Elimina brancos do fim da linha
  %linha
  if (isempty(linha) == 0);
    fprintf(tmp, '%s\n', linha); % Escreve no arquivo tempor�rio
  end
  linha = fgets(arq);            % L� a pr�xima linha do arquivo de dados
end
fclose(tmp);
fclose(arq);

% 3-ATRIBUI��O DOS DADOS A SUAS RESPECTIVAS VARI�VEIS
ent = fopen('dopping.tmp', 'r');    %Abre o arquivo tempor�rio para leitura

aux = fscanf(ent,'%s',1); 
DADOS.NPar = str2num(aux);      % N�mero de par�metros a serem otimizados
%------------------------------------------------------------------ARQUIVOS
DADOS.filetpl = fscanf(ent,'%s',1);   % Arquivo Template
DADOS.filetplmc =fscanf(ent,'%s',1);  % Arquivo Template da opcao Monte Carlo
DADOS.filesim = fscanf(ent,'%s',1);   % Arquivo Simula��o
DADOS.fileinc1 = fscanf(ent,'%s',1);  % Arquivo Include
DADOS.fileinc2 = fscanf(ent,'%s',1);  % Arquivo Include
DADOS.fileout = fscanf(ent,'%s',1);   % Arquivo de Output
DADOS.filein = fscanf(ent, '%s',1);   % Arquivo de Input
DADOS.filetabflex = fscanf(ent, '%s',1);  % Arquivo contendo as bitolas comerciais a serem empregadas no modelo de viga
DADOS.filetabtrans = fscanf(ent, '%s',1); % Arquivo contendo as bitolas comerciais a serem empregadas no modelo de viga e pilar
DADOS.filetablong = fscanf(ent, '%s',1);  % Arquivo contendo as bitolas comerciais a serem empregadas no modelo de pilar
DADOS.fileparconc = fscanf(ent, '%s',1);    % Arquivo com os par�metros do concreto
DADOS.fileparconcTD = fscanf(ent, '%s',1);  % Arquivo com os coeficientes para c�cluclo dos para�metros dependentes do tempo
DADOS.fileparaco = fscanf(ent, '%s',1);     % Arquivo com os par�metros do a�o para concreto armado
DADOS.fileparsteel = fscanf(ent, '%s',1);    % Arquivo com os par�metros do a�o do estaquemaneto
DADOS.filepareco = fscanf(ent, '%s',1);     % Arquivo com os par�metros econ�micos
DADOS.filefluxocaixa = fscanf(ent, '%s',1);     % Arquivo com os par�metros econ�micos

%-----------------------------------------VARI�VEIS DAS OP��ES DE SIMULA��O
DADOS.op_simulador = fscanf(ent, '%d',1);   % Op��o de escolha do simulador a ser utilizado: 0-MATLAB; 1-FEAP
DADOS.op_montafile = fscanf(ent,'%d',1);    % Op��o de montar arquivo de simulacao:0-Nao ; 1-Sim                     
DADOS.op_exec = fscanf(ent,'%d',1);         % Op��o de Execucao do codigo
DADOS.op_spring = fscanf(ent,'%d',1);       % Op��o de barra sobre base el�stica
DADOS.op_time = fscanf(ent,'%d',1);         % Op��o de de an�lise time dependent
DADOS.op_temp = fscanf(ent,'%d',1);         % Opcao de an�lise considerando varia��o t�rmica
DADOS.op_concdesing = fscanf(ent,'%d',1);   % Opcao de dimensionamento dos elementos estruturais
DADOS.op_phisicalpar=fscanf(ent,'%d',1);    % Op��o para c�lculo dos par�metros fisicos a partir do fck
DADOS.op_op_tempeffctes=fscanf(ent,'%d',1); % Op��o para considera��o do efeito da temperatura no coef. de retra��o e flu�ncia do concreto
DADOS.op_ecoanalise=fscanf(ent,'%d',1);     % Op��o para considera��o de an�lise econ�mica
DADOS.op_gain = fscanf(ent,'%d',1);         % Op��o de utiliza��o dos valores das constantes do gain
DADOS.op_suav = fscanf(ent,'%d',1);         % Op��o de utiliza��o da suaviza��o do gradiente aproximado
DADOS.op_minimax = fscanf(ent,'%d',1);      % Op��o do tipo de funcao objetivo:

%------------------------------------PAR�METROS DE OTIMIZA��O - TOLER�NCIAS
DADOS.tolfun = fscanf(ent,'%f',1);  %Toler�ncia da fun��o objetivo
DADOS.tolx = fscanf(ent,'%f',1);    %Toler�ncia dos par�metros
DADOS.tolfunh = fscanf(ent,'%f',1); %Toler�ncia da fun��o objetivo na fase ASP (SPSA-H)
DADOS.tolxh = fscanf(ent,'%f',1);   %Toler�ncia em x na fase ASP (SPSA-H)
DADOS.N = fscanf(ent,'%f',1);       % Par�metro SPSA
DADOS.c = fscanf(ent,'%f',1);       % Par�metro SPSA
DADOS.a = fscanf(ent,'%f',1);       % Par�metro SPSA
DADOS.A = fscanf(ent,'%f',1);       % Par�metro SPSA
DADOS.alphaSPSA = fscanf(ent,'%f',1);% Par�metro SPSA        
DADOS.gamma = fscanf(ent,'%f',1);    % Par�metro SPSA
DADOS.gmedio = fscanf(ent,'%f',1);   % Par�metro SPSA - n�mero de avalia��es da fun��o objetivo no gain ou suaviza��o
DADOS.stepi = fscanf(ent,'%f',1);    % Par�metro SPSA - tamanho inicial do passo, vai alterar na vari�vel a ser otimizada. Valor em metros

%------------------------------------PAR�METROS DE MONTE CARLO E RESTRI��ES
DADOS.NMC = fscanf(ent,'%f',1);     %N�mero de Realiza��es Monte Carlo
DADOS.covb = fscanf(ent,'%f',1);    %Coefeficiente de Varia��o Especificado (op_restr =2,4)
DADOS.stdb = fscanf(ent,'%f',1);    %Desvio Padr�o Especificado (op_restr = 3,5)
DADOS.delcov = fscanf(ent,'%f',1);  %Delta do Coeficiente de Varia��o

%--------------------------------------------------VARI�VEIS DO MODELO SOLO
DADOS.covSOLO=fscanf(ent,'%f',1);         % Coef. varia��o do m�dulo de rea��o do solo
DADOS.sigmaadm=fscanf(ent,'%f',1);        % Tens�o admiss�vel (kN/m2)
DADOS.Lenc=fscanf(ent,'%f',1);            % Largura do encontro em contato com o solo (m)
DADOS.Lest=fscanf(ent,'%f',1);            % Largura da estaca em contato com o solo (m)
%--------------------------------------------------VARI�VEIS DO MODELO ESTACA
DADOS.bf=fscanf(ent,'%f',1);              % Largura da mesa
DADOS.tf=fscanf(ent,'%f',1);              % Espessura da chapa da mesa
DADOS.hest=fscanf(ent,'%f',1);            % Altura do perfil na dire��o do eixo de maior in�rcia
DADOS.tw=fscanf(ent,'%f',1);              % Espessura da chapa da alma
%--------------------------------------------------VARI�VEIS DO MODELO VIGA
DADOS.cobv=fscanf(ent,'%f',1);         % Cobrimento das armaduras das vigas
DADOS.diamagreg=fscanf(ent,'%f',1);    % Di�mentro do agregado gra�do
DADOS.flexinicial=fscanf(ent,'%f',1);  % Estimativa inicial do di�metro da armadura de flex�o
DADOS.transinicial=fscanf(ent,'%f',1); % Estimativa inicial do di�metro da armadura transversal
DADOS.bvmin=fscanf(ent,'%f',1);        % Largura m�nima da viga cm
DADOS.hvmin=fscanf(ent,'%f',1);        % Altura m�nima da viga cm
DADOS.bvmax=fscanf(ent,'%f',1);        % Largura m�xima da viga cm
DADOS.hvmax=fscanf(ent,'%f',1);        % Altura m�xima da viga cm
DADOS.Ltrecho=fscanf(ent,'%f',1);      % N�mero de divis�es da viga para c�lculo dos estribos

%-------------------------------------------------VARI�VEIS DO MODELO PILAR
DADOS.cobp=fscanf(ent,'%f',1);         %Cobrimento das armaduras(cm)
DADOS.bpmin=fscanf(ent,'%f',1);        % Largura m�nima do pilar em cm
DADOS.hpmin=fscanf(ent,'%f',1);        % Altura m�nima do pilar cm
DADOS.bpmax=fscanf(ent,'%f',1);        % Largura m�xima do pilar cm
DADOS.hpmax=fscanf(ent,'%f',1);        % Altura m�xima do pilar cm

%--------------------------------------------------------------OUTROS DADOS
DADOS.romin=fscanf(ent,'%f',1);   %Taxa geom�trica m�nima de armadura long. de vigas 
DADOS.teta=fscanf(ent,'%f',1);    %�ngulo de inclina��o das fissuras (graus).
DADOS.alfa=fscanf(ent,'%f',1);    %�ngulo de inclina��o dos estribos (graus).   
DADOS.neta1=fscanf(ent,'%f',1);   %Coef. para c�lculo da tens�o de ader�ncia da arm. pass.
DADOS.neta2=fscanf(ent,'%f',1);   %Coef. para c�lculo da tens�o de ader�ncia da arm. pass. 
DADOS.neta3=fscanf(ent,'%f',1);   %Coef. para c�lculo da tens�o de ader�ncia da arm. pass.   
DADOS.tx=fscanf(ent,'%f',1)/100;  % Taxa de atratividade do empreendimento

fclose(ent);
delete('dopping.tmp');
%
% =============================== RetComent ================================

function str2 = RetComent(str1)
% RetComent: retira os comentarios de uma string dada.
% Sao considerados comentarios todos os caracteres apos o simbolo %.

% Verifica se a string � vazia.

n = length(str1);
if (n < 1), str2 = ''; end

% Procura a posicao do simbolo de comentario.

i = 1;
while (i <= n & str1(i) ~= '%'), i = i + 1; end 

% Retorna a string anterior ao simbolo % (toda ela se nao houver o %).

str2 = str1(1:i-1);
