%FAB - Remo��o de vari�vel sem uso (CORTANTE).
function [PILARresult]=columnMC(PILARresult, PORTICO, ELEMENTOS, DADOS, ~, MOMENTO, NORMAL, PILAR, PAR, qntbitolas, ESTRUTURAL)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCI�NCIAS
% PROGRAMA DE P�S-GRADUA��O EM ENGENHARIA CIVIL        - �REA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELE��O DE  M�DIA FIDELIDADE  PARA  AN�LISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO.
% ALUNO       S�rgio Jos� Priori Jovino Marques Filho
% ORIENTADOR  Prof. �zio da Rocha Ara�jo
% -------------------------------------------------------------------------
% DESCRI��O
% Rotina para gerenciar o dimensionamento e detalhamento de pilares
% submetidos � flexocompress�o normal.
% -------------------------------------------------------------------------
% MODIFICA��ES:         
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: --
% VARI�VEIS DE SA�DA:   PILARin: "structure" contendo as vari�veis necess�-
% rias ao algoritmo de detalhamento do pilar - column.m 
%--------------------------------------------------------------------------
% CRIADA EM 21-fevereiro-2016
% -------------------------------------------------------------------------
global m;

% C�lculo da qnt de pilares no p�rtico e do comprimento de cada um
PILAR.elemento=ESTRUTURAL.ELEMPILAR';
s=size(PILAR.elemento);
s=s(1);
DADOS.Npilares=s;
PILARin.COMPRIMENTO=zeros(1,DADOS.Npilares);
PILARin.compelem=zeros(1,DADOS.Npilares);
for NumPilar=1:DADOS.Npilares
    % N�s inicail e final
    noi=PORTICO.conec(ESTRUTURAL.D(PILAR.elemento(NumPilar,1),1),1);
    nof=PORTICO.conec(ESTRUTURAL.D(PILAR.elemento(NumPilar,1),2),2);
    PILARin.COMPRIMENTO(NumPilar)=PORTICO.z(nof)-PORTICO.z(noi);
    nelem=ESTRUTURAL.D(PILAR.elemento(NumPilar,1),2)-ESTRUTURAL.D(PILAR.elemento(NumPilar,1),1)+1;
    PILARin.compelem(NumPilar)=PILARin.COMPRIMENTO(NumPilar)/nelem;
end



% Propriedades f�sicas dos materiais
PILARin.Es=PAR.ACO.EsV(m);
PILARin.roaco=PAR.ACO.rosV(m);    % Peso espec�fico do a�o
PILARin.fyd=PAR.ACO.fyV(m);
PILARin.Ec=PAR.CONC.EcsV(m);    % <-- M�dulo de elasticidade secante do concreto
PILARin.fcd=PAR.CONC.fccV(m);   % Dados em kN/m2;
PILARin.phi=PAR.CONC.phi(m);
PILARin.sigmacd=0.85*PILARin.fcd;
PILARin.epsonyd=1000*PILARin.fyd/PILARin.Es; % <-- Multiplica��o por 1000 para que a unidade fique em termos de "por mil"
PILARin.diamagregado=DADOS.diamagreg;
PILARin.cob=DADOS.cobp;
    
% DETERINA��O DA QUANTIDADE M�XIMA DE BARRAS NA DIRE��O y - ser�
% utilizada um trecho da rotina column2.m considerando o menor di�metro
% da TABELALONG, e o m�xima dimens�o permitida para a altura da se��o do pilar
% dessa forma, procura-se a se obter a maior qnt poss�vel de barras ao
% longo da altura da se��o. Em seguida, as barras dimensionadas ser�o
% alocadas nesse vetor, os elementos do vetor, n�o utilizados e preenchidos
% com zeros, ser�o em seguida removidos. 
esp=max([0.02, 0.01, 1.2*PILARin.diamagregado]);
n=floor((DADOS.hpmax/100-2*(PILARin.cob+0.005)+esp)/(0.01+esp)); % <-- Qnt m�x de barras em y
PILARresult.ARRANJO=zeros(DADOS.Npilares,n);
  
for NumPilar=1:DADOS.Npilares
    %disp(['Dimensionando pilar ',num2str(NumPilar),' de ',num2str(DADOS.Npilares)])
    %disp('----------------------------------------------------------------')
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%------------------------ENTRADA DE DADOS---------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % PROPRIEDADES GEOM�TRICAS DA SE��O   
    pilar=ESTRUTURAL.D(PILAR.elemento(NumPilar),1);                      
    PILARin.b=ELEMENTOS.secaoV(pilar,1,m);
    PILARin.h=ELEMENTOS.secaoV(pilar,2,m);
    pilar=PILAR.elemento(NumPilar,1);
    
    PILARin.yT=PILARin.h/2;                         % ordenada do topo da se��o transversal
    PILARin.yB=-PILARin.h/2;                        % ordenada da base da se��o transversal
%     PILARin.comp=PORTICO.comp(PILAR.elemento(NumPilar));   % Comprimento
    PILARin.A=PILARin.b*PILARin.h;                  % �rea
    PILARin.I=PILARin.b*PILARin.h^3/12;             % Momento de in�rcia
    
    % C�LCULO DO �NDICE DE ESBELTEZ DO PILAR
    PILARin.k=0.7;                              % <-- Constante a ser definida em fun��o das condi��es de contorno do elemento estrutural - automatizar posteriormemte
    PILARin.Lef=PILARin.k*PILARin.COMPRIMENTO(NumPilar);         % <-- Comprimento efetivo de flambagem
    PILARin.i=(PILARin.I/PILARin.A)^(1/2);      % <-- Raio de gira��o
    PILARin.lambda=PILARin.Lef/PILARin.i;       % <-- �ndice de esbeltez do pilar    
    
    % OBTEN��O DOS ESFOR�OS SOLICITANTES - column0.m
    % C�lculo das excentricidades
    [PILARout]=column0MC(MOMENTO, NORMAL, PILARin, pilar, NumPilar);
    % Esfor�o normal - PILARout.Nmax
    % Momento fletor
    PILARout.Md=PILARout.Nmax*PILARout.et;
    
    % C�LCULO DAS �REAS DE A�O M�NIMA E M�XIMA - column1.m
    [PILARout]=column1(PILARin, PILARout);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-------------------------PROCESSAMENTO-----------------------------------%
%--Cada bitola ter� um arranjo de barras verificado, esse arranjo possui--%
%--------------a menor �rea de a�o para a bitola em quest�o---------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Tag para ativar o dimensionamento das armaduras do pilar
    tagELU=0;
    for ii=1:qntbitolas  % <-- Esse for ir� "varrer" as bitolas comerciais   
        if tagELU==0
            % Bitola a ser utilizada nesse loop
            PILARin.diambarra=PILAR.TABELALONG(ii)/1000;

            % QUANTIDADE M�XIMA DE BARRAS NA SE��O DO PILAR - column2.m
            [nbxmax, nbymax, diamestribo]=column2(PILARin);

            % EM CADA LOOP O N�MERO DE CAMADAS SER� INCREMENTADO
            for j=2:nbymax
                for k=2:nbxmax

                    % Tag que indica que a configura��o da se��o atende o ELU
                    %tagELU=0 -> Arranjo atende ao ELU
                    tagELU=0;

                    % ARRANJO DE ARMADURA - num�ro de barras em x e y
                    % Num de camdas de barras, dire��o x
                    nbx=k;
                    % Num de camdas de barras, dire��o y
                    %nby=j;
                    PILARin.ncam=j; 

                    % Cria��o do vetor contendo a qnt de barras em cada camada
                    % aqui iremos considerar que a primeira a ultima camada
                    % contem nbx barras, as camadas intermadir�rias conter�o
                    % apenas duas barras.
                    PILARin.distbarras=2*ones(1, PILARin.ncam);
                    PILARin.distbarras(1)=nbx;
                    PILARin.distbarras(PILARin.ncam)=nbx;
                    % �rea de a�o na se��o
                    PILARin.As=PILARin.distbarras*pi*PILARin.diambarra^2/4;
                    % �rea de a�o total da se��o
                    PILARin.Astotal=sum(PILARin.As);
                    % �rea de a�o total na se��o
                    AsTotal=sum(PILARin.distbarras*pi*PILARin.diambarra^2/4);
    %                 disp(['Distribui��o de barras na se��o ',num2str(PILARin.distbarras)])

                    % PROCESSO DE VERIFICA��O - apenas se Asmin<PILARin.As<Asmax
                    if AsTotal>=PILARout.Asmin && AsTotal<PILARout.Asmax

                        % DETERMINA��O DO CG DE CADA CAMADA DE BARRA
                        [PILARout]=column3(PILARin, PILARout, diamestribo);

                        % DETERMINA��O DO DIAGRAMA DE ITERA��O 
                        [PILARout]=column4(PILARin, PILARout);

    %                     plot(PILARout.Mn,PILARout.Pn,PILARout.Md,PILARout.Nmax,'o')
    %                     grid on

                        % VERIFICA��O ELU - verifica se o par de esfor�os
                        % solicitantes encontra-se dentro do intervalo definido
                        % pelo diagrama de itera��o - caso afirmativo, o tagELU
                        % assume valor igual 1.
                        [tagELU]=column5(PILARout, tagELU);
                    end
                    if tagELU==1
    %                     disp('      Disposi��o de  barras passa')
                        break    % <-- Finaliza o primeiro loop do nbx
                    end
                end
                if tagELU==1
                    break        % <-- Finaliza o segundo loop do nby
                end
            end
            % INDICADORES A�O
            % C�lculo da �rea de a�o, peso da armadura longitudinal, distribui��o de
            % barras na se��o e di�metro da barra de a�o empregada
            if tagELU==1
                s=size(PILARin.distbarras);
                PILARresult.ARRANJO(NumPilar,1:s(2))=PILARin.distbarras;
                PILARresult.bitola(NumPilar)=PILAR.TABELALONG(ii)/1000;
                PILARresult.As(m,NumPilar)=sum(PILARresult.ARRANJO(NumPilar,:))*pi*(PILAR.TABELALONG(ii)/1000)^2/4;
                PILARresult.PesoArmLong(m,NumPilar)=PILARresult.As(m,NumPilar)*PILARin.COMPRIMENTO(NumPilar)*PILARin.roaco*100;
                % INDICADORES CONCRETO
                % C�lculo do volume de concreto e �rea de forma
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