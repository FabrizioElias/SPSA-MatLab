%FAB - Remoção de variável sem uso (CORTANTE).
function [PILARresult]=columnMC(PILARresult, PORTICO, ELEMENTOS, DADOS, ~, MOMENTO, NORMAL, PILAR, PAR, qntbitolas, ESTRUTURAL)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIÊNCIAS
% PROGRAMA DE PÓS-GRADUAÇÃO EM ENGENHARIA CIVIL        - ÁREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELEÇÃO DE  MÉDIA FIDELIDADE  PARA  ANÁLISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO.
% ALUNO       Sérgio José Priori Jovino Marques Filho
% ORIENTADOR  Prof. Ézio da Rocha Araújo
% -------------------------------------------------------------------------
% DESCRIÇÃO
% Rotina para gerenciar o dimensionamento e detalhamento de pilares
% submetidos à flexocompressão normal.
% -------------------------------------------------------------------------
% MODIFICAÇÕES:         
%--------------------------------------------------------------------------
% VARIÁVEIS DE ENTRADA: --
% VARIÁVEIS DE SAÍDA:   PILARin: "structure" contendo as variáveis necessá-
% rias ao algoritmo de detalhamento do pilar - column.m 
%--------------------------------------------------------------------------
% CRIADA EM 21-fevereiro-2016
% -------------------------------------------------------------------------
global m;

% Cálculo da qnt de pilares no pórtico e do comprimento de cada um
PILAR.elemento=ESTRUTURAL.ELEMPILAR';
s=size(PILAR.elemento);
s=s(1);
DADOS.Npilares=s;
PILARin.COMPRIMENTO=zeros(1,DADOS.Npilares);
PILARin.compelem=zeros(1,DADOS.Npilares);
for NumPilar=1:DADOS.Npilares
    % Nós inicail e final
    noi=PORTICO.conec(ESTRUTURAL.D(PILAR.elemento(NumPilar,1),1),1);
    nof=PORTICO.conec(ESTRUTURAL.D(PILAR.elemento(NumPilar,1),2),2);
    PILARin.COMPRIMENTO(NumPilar)=PORTICO.z(nof)-PORTICO.z(noi);
    nelem=ESTRUTURAL.D(PILAR.elemento(NumPilar,1),2)-ESTRUTURAL.D(PILAR.elemento(NumPilar,1),1)+1;
    PILARin.compelem(NumPilar)=PILARin.COMPRIMENTO(NumPilar)/nelem;
end



% Propriedades físicas dos materiais
PILARin.Es=PAR.ACO.EsV(m);
PILARin.roaco=PAR.ACO.rosV(m);    % Peso específico do aço
PILARin.fyd=PAR.ACO.fyV(m);
PILARin.Ec=PAR.CONC.EcsV(m);    % <-- Módulo de elasticidade secante do concreto
PILARin.fcd=PAR.CONC.fccV(m);   % Dados em kN/m2;
PILARin.phi=PAR.CONC.phi(m);
PILARin.sigmacd=0.85*PILARin.fcd;
PILARin.epsonyd=1000*PILARin.fyd/PILARin.Es; % <-- Multiplicação por 1000 para que a unidade fique em termos de "por mil"
PILARin.diamagregado=DADOS.diamagreg;
PILARin.cob=DADOS.cobp;
    
% DETERINAÇÃO DA QUANTIDADE MÁXIMA DE BARRAS NA DIREÇÃO y - será
% utilizada um trecho da rotina column2.m considerando o menor diâmetro
% da TABELALONG, e o máxima dimensão permitida para a altura da seção do pilar
% dessa forma, procura-se a se obter a maior qnt possível de barras ao
% longo da altura da seção. Em seguida, as barras dimensionadas serão
% alocadas nesse vetor, os elementos do vetor, não utilizados e preenchidos
% com zeros, serão em seguida removidos. 
esp=max([0.02, 0.01, 1.2*PILARin.diamagregado]);
n=floor((DADOS.hpmax/100-2*(PILARin.cob+0.005)+esp)/(0.01+esp)); % <-- Qnt máx de barras em y
PILARresult.ARRANJO=zeros(DADOS.Npilares,n);
  
for NumPilar=1:DADOS.Npilares
    %disp(['Dimensionando pilar ',num2str(NumPilar),' de ',num2str(DADOS.Npilares)])
    %disp('----------------------------------------------------------------')
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%------------------------ENTRADA DE DADOS---------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % PROPRIEDADES GEOMÉTRICAS DA SEÇÃO   
    pilar=ESTRUTURAL.D(PILAR.elemento(NumPilar),1);                      
    PILARin.b=ELEMENTOS.secaoV(pilar,1,m);
    PILARin.h=ELEMENTOS.secaoV(pilar,2,m);
    pilar=PILAR.elemento(NumPilar,1);
    
    PILARin.yT=PILARin.h/2;                         % ordenada do topo da seção transversal
    PILARin.yB=-PILARin.h/2;                        % ordenada da base da seção transversal
%     PILARin.comp=PORTICO.comp(PILAR.elemento(NumPilar));   % Comprimento
    PILARin.A=PILARin.b*PILARin.h;                  % Área
    PILARin.I=PILARin.b*PILARin.h^3/12;             % Momento de inércia
    
    % CÁLCULO DO ÍNDICE DE ESBELTEZ DO PILAR
    PILARin.k=0.7;                              % <-- Constante a ser definida em função das condições de contorno do elemento estrutural - automatizar posteriormemte
    PILARin.Lef=PILARin.k*PILARin.COMPRIMENTO(NumPilar);         % <-- Comprimento efetivo de flambagem
    PILARin.i=(PILARin.I/PILARin.A)^(1/2);      % <-- Raio de giração
    PILARin.lambda=PILARin.Lef/PILARin.i;       % <-- Índice de esbeltez do pilar    
    
    % OBTENÇÃO DOS ESFORÇOS SOLICITANTES - column0.m
    % Cálculo das excentricidades
    [PILARout]=column0MC(MOMENTO, NORMAL, PILARin, pilar, NumPilar);
    % Esforço normal - PILARout.Nmax
    % Momento fletor
    PILARout.Md=PILARout.Nmax*PILARout.et;
    
    % CÁLCULO DAS ÁREAS DE AÇO MÍNIMA E MÁXIMA - column1.m
    [PILARout]=column1(PILARin, PILARout);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-------------------------PROCESSAMENTO-----------------------------------%
%--Cada bitola terá um arranjo de barras verificado, esse arranjo possui--%
%--------------a menor área de aço para a bitola em questão---------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Tag para ativar o dimensionamento das armaduras do pilar
    tagELU=0;
    for ii=1:qntbitolas  % <-- Esse for irá "varrer" as bitolas comerciais   
        if tagELU==0
            % Bitola a ser utilizada nesse loop
            PILARin.diambarra=PILAR.TABELALONG(ii)/1000;

            % QUANTIDADE MÁXIMA DE BARRAS NA SEÇÃO DO PILAR - column2.m
            [nbxmax, nbymax, diamestribo]=column2(PILARin);

            % EM CADA LOOP O NÚMERO DE CAMADAS SERÁ INCREMENTADO
            for j=2:nbymax
                for k=2:nbxmax

                    % Tag que indica que a configuração da seção atende o ELU
                    %tagELU=0 -> Arranjo atende ao ELU
                    tagELU=0;

                    % ARRANJO DE ARMADURA - numéro de barras em x e y
                    % Num de camdas de barras, direção x
                    nbx=k;
                    % Num de camdas de barras, direção y
                    %nby=j;
                    PILARin.ncam=j; 

                    % Criação do vetor contendo a qnt de barras em cada camada
                    % aqui iremos considerar que a primeira a ultima camada
                    % contem nbx barras, as camadas intermadirárias conterão
                    % apenas duas barras.
                    PILARin.distbarras=2*ones(1, PILARin.ncam);
                    PILARin.distbarras(1)=nbx;
                    PILARin.distbarras(PILARin.ncam)=nbx;
                    % Área de aço na seção
                    PILARin.As=PILARin.distbarras*pi*PILARin.diambarra^2/4;
                    % Área de aço total da seção
                    PILARin.Astotal=sum(PILARin.As);
                    % Área de aço total na seção
                    AsTotal=sum(PILARin.distbarras*pi*PILARin.diambarra^2/4);
    %                 disp(['Distribuição de barras na seção ',num2str(PILARin.distbarras)])

                    % PROCESSO DE VERIFICAÇÃO - apenas se Asmin<PILARin.As<Asmax
                    if AsTotal>=PILARout.Asmin && AsTotal<PILARout.Asmax

                        % DETERMINAÇÃO DO CG DE CADA CAMADA DE BARRA
                        [PILARout]=column3(PILARin, PILARout, diamestribo);

                        % DETERMINAÇÃO DO DIAGRAMA DE ITERAÇÃO 
                        [PILARout]=column4(PILARin, PILARout);

    %                     plot(PILARout.Mn,PILARout.Pn,PILARout.Md,PILARout.Nmax,'o')
    %                     grid on

                        % VERIFICAÇÃO ELU - verifica se o par de esforços
                        % solicitantes encontra-se dentro do intervalo definido
                        % pelo diagrama de iteração - caso afirmativo, o tagELU
                        % assume valor igual 1.
                        [tagELU]=column5(PILARout, tagELU);
                    end
                    if tagELU==1
    %                     disp('      Disposição de  barras passa')
                        break    % <-- Finaliza o primeiro loop do nbx
                    end
                end
                if tagELU==1
                    break        % <-- Finaliza o segundo loop do nby
                end
            end
            % INDICADORES AÇO
            % Cálculo da área de aço, peso da armadura longitudinal, distribuição de
            % barras na seção e diâmetro da barra de aço empregada
            if tagELU==1
                s=size(PILARin.distbarras);
                PILARresult.ARRANJO(NumPilar,1:s(2))=PILARin.distbarras;
                PILARresult.bitola(NumPilar)=PILAR.TABELALONG(ii)/1000;
                PILARresult.As(m,NumPilar)=sum(PILARresult.ARRANJO(NumPilar,:))*pi*(PILAR.TABELALONG(ii)/1000)^2/4;
                PILARresult.PesoArmLong(m,NumPilar)=PILARresult.As(m,NumPilar)*PILARin.COMPRIMENTO(NumPilar)*PILARin.roaco*100;
                % INDICADORES CONCRETO
                % Cálculo do volume de concreto e área de forma
                PILARresult.Volconc(m,NumPilar)=PILARin.b*PILARin.h*PILARin.COMPRIMENTO(NumPilar);
                PILARresult.Aforma(m,NumPilar)=(2*PILARin.b+2*PILARin.h)*PILARin.COMPRIMENTO(NumPilar);
            end
        end
    end  
    if tagELU==0
        PILARresult.PesoArmLong(m,NumPilar)=9999999;
        PILARresult.Volconc(m,NumPilar)=PILARin.b*PILARin.h*PILARin.COMPRIMENTO(NumPilar);
        PILARresult.Aforma(m,NumPilar)=(2*PILARin.b+2*PILARin.h)*PILARin.COMPRIMENTO(NumPilar);
    end
        
end                    