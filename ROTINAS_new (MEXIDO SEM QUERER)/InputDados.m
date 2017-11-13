function DADOS=InputDados
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIÊNCIAS
% PROGRAMA DE PÓS-GRADUAÇÃO EM ENGENHARIA CIVIL        - ÁREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELEÇÃO DE  MÉDIA FIDELIDADE  PARA  ANÁLISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO.
% ALUNA       Sérgio José Priori Jovino Marques Filho
% ORIENTADOR  Prof. Ézio da Rocha Araújo
% -------------------------------------------------------------------------
% DESCRIÇÃO
% Lê dados de entrada (do arquivo DADOS.in) e atribui estes valores às variáveis
% -------------------------------------------------------------------------
% MODIFICAÇÕES - Sérgio Marques
% 1. Variáveis globais foram substituídas por "STRUCTURES"
%--------------------------------------------------------------------------
% VARIÁVEIS DE ENTRADA: -
% VARIÁVEIS DE SAÍDA:   DADOS - contem todos os parâmetros necessários ao
% processamento e otimização do pórtico que constam no cartão de entrada
% (arquivo DADOS.in)
%--------------------------------------------------------------------------
% ADAPTAÇÃO DA ROTINA DE DIEGO OLIVEIRA 30-Janeiro-2006
% Modificada      04-Agosto-2011              NILMA ANDRADE
% Modificada      13-Janeiro-2015             SÉRGIO MARQUES
% -------------------------------------------------------------------------
% 1-DEFINICAO DAS VARIÁVEIS GLOBAIS

% 2-LEITURA DO ARQUIVO DE ENTRADA DE DADOS E MONTAGEM DO ARQUIVO TEMPORÁRIO
% Abre,para leitura,o arquivo com os valores das variáveis (DADOS.in)
% e também abre o arquivo temporario para registro.

% A variável nomearq recebe o arquivo (DADOS.in) que contém os valores da variaveis:
nomearq = 'DADOS.in';
% Abre o arquivo de dados original (DADOS.in)para leitura:
[arq, msg] = fopen(nomearq, 'r');
if (arq == -1)
  error(msg);
end
% Abre o arquivo temporário (dopping.tmp) para escrita:
[tmp, msg] = fopen('dopping.tmp', 'wt');
if (tmp == -1)
  error(msg);
end
% Lê o arquivo (DADOS.in) com os dados  e os escreve (extraindo
% linhas em branco e comentários) no arquivo temporário (dopping.tmp):
linha = fgets(arq);              % Lê a primeira linha do arquivo de dados
while (linha ~= -1);
  linha = RetComent(linha);      % Elimina os comentários
  linha = deblank(linha);        % Elimina brancos do fim da linha
  %linha
  if (isempty(linha) == 0);
    fprintf(tmp, '%s\n', linha); % Escreve no arquivo temporário
  end
  linha = fgets(arq);            % Lê a próxima linha do arquivo de dados
end
fclose(tmp);
fclose(arq);

% 3-ATRIBUIÇÃO DOS DADOS A SUAS RESPECTIVAS VARIÀVEIS
ent = fopen('dopping.tmp', 'r');    %Abre o arquivo temporário para leitura

aux = fscanf(ent,'%s',1); 
DADOS.NPar = str2num(aux);      % Número de parâmetros a serem otimizados
%------------------------------------------------------------------ARQUIVOS
DADOS.filetpl = fscanf(ent,'%s',1);   % Arquivo Template
DADOS.filetplmc =fscanf(ent,'%s',1);  % Arquivo Template da opcao Monte Carlo
DADOS.filesim = fscanf(ent,'%s',1);   % Arquivo Simulação
DADOS.fileinc1 = fscanf(ent,'%s',1);  % Arquivo Include
DADOS.fileinc2 = fscanf(ent,'%s',1);  % Arquivo Include
DADOS.fileout = fscanf(ent,'%s',1);   % Arquivo de Output
DADOS.filein = fscanf(ent, '%s',1);   % Arquivo de Input
DADOS.filetabflex = fscanf(ent, '%s',1);  % Arquivo contendo as bitolas comerciais a serem empregadas no modelo de viga
DADOS.filetabtrans = fscanf(ent, '%s',1); % Arquivo contendo as bitolas comerciais a serem empregadas no modelo de viga e pilar
DADOS.filetablong = fscanf(ent, '%s',1);  % Arquivo contendo as bitolas comerciais a serem empregadas no modelo de pilar
DADOS.fileparconc = fscanf(ent, '%s',1);    % Arquivo com os parâmetros do concreto
DADOS.fileparconcTD = fscanf(ent, '%s',1);  % Arquivo com os coeficientes para cácluclo dos paraâmetros dependentes do tempo
DADOS.fileparaco = fscanf(ent, '%s',1);     % Arquivo com os parâmetros do aço para concreto armado
DADOS.fileparsteel = fscanf(ent, '%s',1);    % Arquivo com os parâmetros do aço do estaquemaneto
DADOS.filepareco = fscanf(ent, '%s',1);     % Arquivo com os parâmetros econômicos
DADOS.filefluxocaixa = fscanf(ent, '%s',1);     % Arquivo com os parâmetros econômicos

%-----------------------------------------VARIÁVEIS DAS OPÇÕES DE SIMULAÇÃO
DADOS.op_simulador = fscanf(ent, '%d',1);   % Opção de escolha do simulador a ser utilizado: 0-MATLAB; 1-FEAP
DADOS.op_montafile = fscanf(ent,'%d',1);    % Opção de montar arquivo de simulacao:0-Nao ; 1-Sim                     
DADOS.op_exec = fscanf(ent,'%d',1);         % Opção de Execucao do codigo
DADOS.op_spring = fscanf(ent,'%d',1);       % Opção de barra sobre base elástica
DADOS.op_time = fscanf(ent,'%d',1);         % Opção de de análise time dependent
DADOS.op_temp = fscanf(ent,'%d',1);         % Opcao de análise considerando variação térmica
DADOS.op_concdesing = fscanf(ent,'%d',1);   % Opcao de dimensionamento dos elementos estruturais
DADOS.op_phisicalpar=fscanf(ent,'%d',1);    % Opção para cálculo dos parâmetros fisicos a partir do fck
DADOS.op_op_tempeffctes=fscanf(ent,'%d',1); % Opção para consideração do efeito da temperatura no coef. de retração e fluência do concreto
DADOS.op_ecoanalise=fscanf(ent,'%d',1);     % Opção para consideração de análise econômica
DADOS.op_gain = fscanf(ent,'%d',1);         % Opção de utilização dos valores das constantes do gain
DADOS.op_suav = fscanf(ent,'%d',1);         % Opção de utilização da suavização do gradiente aproximado
DADOS.op_minimax = fscanf(ent,'%d',1);      % Opção do tipo de funcao objetivo:

%------------------------------------PARÂMETROS DE OTIMIZAÇÃO - TOLERÂNCIAS
DADOS.tolfun = fscanf(ent,'%f',1);  %Tolerância da função objetivo
DADOS.tolx = fscanf(ent,'%f',1);    %Tolerância dos parâmetros
DADOS.tolfunh = fscanf(ent,'%f',1); %Tolerância da função objetivo na fase ASP (SPSA-H)
DADOS.tolxh = fscanf(ent,'%f',1);   %Tolerância em x na fase ASP (SPSA-H)
DADOS.N = fscanf(ent,'%f',1);       % Parâmetro SPSA
DADOS.c = fscanf(ent,'%f',1);       % Parâmetro SPSA
DADOS.a = fscanf(ent,'%f',1);       % Parâmetro SPSA
DADOS.A = fscanf(ent,'%f',1);       % Parâmetro SPSA
DADOS.alphaSPSA = fscanf(ent,'%f',1);% Parâmetro SPSA        
DADOS.gamma = fscanf(ent,'%f',1);    % Parâmetro SPSA
DADOS.gmedio = fscanf(ent,'%f',1);   % Parâmetro SPSA - número de avaliações da função objetivo no gain ou suavização
DADOS.stepi = fscanf(ent,'%f',1);    % Parâmetro SPSA - tamanho inicial do passo, vai alterar na variável a ser otimizada. Valor em metros

%------------------------------------PARÂMETROS DE MONTE CARLO E RESTRIÇÕES
DADOS.NMC = fscanf(ent,'%f',1);     %Número de Realizações Monte Carlo
DADOS.covb = fscanf(ent,'%f',1);    %Coefeficiente de Variação Especificado (op_restr =2,4)
DADOS.stdb = fscanf(ent,'%f',1);    %Desvio Padrão Especificado (op_restr = 3,5)
DADOS.delcov = fscanf(ent,'%f',1);  %Delta do Coeficiente de Variação

%--------------------------------------------------VARIÁVEIS DO MODELO SOLO
DADOS.covSOLO=fscanf(ent,'%f',1);         % Coef. variação do módulo de reação do solo
DADOS.sigmaadm=fscanf(ent,'%f',1);        % Tensão admissível (kN/m2)
DADOS.Lenc=fscanf(ent,'%f',1);            % Largura do encontro em contato com o solo (m)
DADOS.Lest=fscanf(ent,'%f',1);            % Largura da estaca em contato com o solo (m)
%--------------------------------------------------VARIÁVEIS DO MODELO ESTACA
DADOS.bf=fscanf(ent,'%f',1);              % Largura da mesa
DADOS.tf=fscanf(ent,'%f',1);              % Espessura da chapa da mesa
DADOS.hest=fscanf(ent,'%f',1);            % Altura do perfil na direção do eixo de maior inércia
DADOS.tw=fscanf(ent,'%f',1);              % Espessura da chapa da alma
%--------------------------------------------------VARIÁVEIS DO MODELO VIGA
DADOS.cobv=fscanf(ent,'%f',1);         % Cobrimento das armaduras das vigas
DADOS.diamagreg=fscanf(ent,'%f',1);    % Diâmentro do agregado graúdo
DADOS.flexinicial=fscanf(ent,'%f',1);  % Estimativa inicial do diâmetro da armadura de flexão
DADOS.transinicial=fscanf(ent,'%f',1); % Estimativa inicial do diâmetro da armadura transversal
DADOS.bvmin=fscanf(ent,'%f',1);        % Largura mínima da viga cm
DADOS.hvmin=fscanf(ent,'%f',1);        % Altura mínima da viga cm
DADOS.bvmax=fscanf(ent,'%f',1);        % Largura máxima da viga cm
DADOS.hvmax=fscanf(ent,'%f',1);        % Altura máxima da viga cm
DADOS.Ltrecho=fscanf(ent,'%f',1);      % Número de divisões da viga para cálculo dos estribos

%-------------------------------------------------VARIÁVEIS DO MODELO PILAR
DADOS.cobp=fscanf(ent,'%f',1);         %Cobrimento das armaduras(cm)
DADOS.bpmin=fscanf(ent,'%f',1);        % Largura mínima do pilar em cm
DADOS.hpmin=fscanf(ent,'%f',1);        % Altura mínima do pilar cm
DADOS.bpmax=fscanf(ent,'%f',1);        % Largura máxima do pilar cm
DADOS.hpmax=fscanf(ent,'%f',1);        % Altura máxima do pilar cm

%--------------------------------------------------------------OUTROS DADOS
DADOS.romin=fscanf(ent,'%f',1);   %Taxa geométrica mínima de armadura long. de vigas 
DADOS.teta=fscanf(ent,'%f',1);    %Ângulo de inclinação das fissuras (graus).
DADOS.alfa=fscanf(ent,'%f',1);    %Ângulo de inclinação dos estribos (graus).   
DADOS.neta1=fscanf(ent,'%f',1);   %Coef. para cálculo da tensão de aderência da arm. pass.
DADOS.neta2=fscanf(ent,'%f',1);   %Coef. para cálculo da tensão de aderência da arm. pass. 
DADOS.neta3=fscanf(ent,'%f',1);   %Coef. para cálculo da tensão de aderência da arm. pass.   
DADOS.tx=fscanf(ent,'%f',1)/100;  % Taxa de atratividade do empreendimento

fclose(ent);
delete('dopping.tmp');
%
% =============================== RetComent ================================

function str2 = RetComent(str1)
% RetComent: retira os comentarios de uma string dada.
% Sao considerados comentarios todos os caracteres apos o simbolo %.

% Verifica se a string é vazia.

n = length(str1);
if (n < 1), str2 = ''; end

% Procura a posicao do simbolo de comentario.

i = 1;
while (i <= n & str1(i) ~= '%'), i = i + 1; end 

% Retorna a string anterior ao simbolo % (toda ela se nao houver o %).

str2 = str1(1:i-1);
