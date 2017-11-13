function [Xfim,funcfim,exitflg] = spsab(theta0)
%Minimizacao com SPSA-B (captacao de minimos sem reinicializa��o)
%--------------------------------------------------------------------------
%spsab
%theta0 = X (=parametros iniciais, rotina de Diego (Le_parametros)
%Criado:        xx-xx-1997      James Spall
%Modificacoes:  2009/2010       Liliane Fonseca e Prof. Ezio Araujo
%usar valor elevado para toleranceloss
%--------------------------------------------------------------------------

global NPar;
%global ruido;
global func0;
%global covfmc0; global yreal0; global L;
global tolfun;
%global tolfunh; global covb; global stdb;
global tolx;
%global tolxh; global delcov; global NMC;
global X;
global Xmin Xmax Xsup Xinf;
%global CountSim;
global fid;
global op_output;
%global op_restr; global op_mc;
global fileout;
global op_gain;
%global op_tp_fob;
global Mparam; global Mgain; global texto
global ii;
%global irod; global tabela
%global n1; global Xn1;
global freal;
%global varfmc; global stdfmc; global covfmc; 
%global Dias; global Diasmax; global fdias; global vdiasmax; global vfdias;
%global numgraf; global h_vfdias; global h_vdiasmax;
global k; global N; 

global hf_mc f_mc;   
global SPA_V hSPA_V SVC_V hSVC_V SForma_V hSForma_V;%VIGA
global SPA_L hSPA_L SVC_L hSVC_L SForma_L hSForma_L;%LAJE
global SPA_P hSPA_P SVC_P hSVC_P SForma_P hSForma_P;%PILAR
global fyV hfyV fccV hfccV;

%VIGA
global CVA  CVC  CVF;
%LAJE
global CLA CLC CLF;
%PILAR
global CPA CPC CPF;

%global hvV hhvV bvV hbvV hlV hhlV hpxV hhpxV hpyV hhpyV;

arqparam=fopen('param_spsa.txt','r');
Mparam=fscanf(arqparam, '%g %g %g %g',[4 inf]);
Mgain=Mparam';
linM=size(Mgain);

for ii=1:linM(1)
    if op_gain ==1
        arqpar = fopen('param_outgain.txt','r');
        Mg = fscanf(arqpar, '%g %g %g',[3 inf]);
        Mgain(ii,:)=[Mgain(ii,1) Mg'];
    end
 
%c, A e a em cada rodada (ii)
    N=Mgain(ii,1);   %total no. of loss measurements
    c=Mgain(ii,2);
    a=Mgain(ii,3);
    A=Mgain(ii,4);
    if op_output==1
        fid=1;
    else
        texto=[fileout(1:end-4), '_',num2str(ii),'.dat'];
%        [arqui(ii), msg] = fopen(texto, 'w');
    end

%--- Par�metros 1SPSA
alpha =.602;
gamma =.101;

%rand('seed',31415927);
tolerancetheta=tolx;    %max. varia��o permitida em theta (fase 1SPSA)
toleranceloss=tolfun;
% tolerancethetah=tolxh;
% tolerancelossh=tolfunh;
% avg=0;

p=NPar;
theta=theta0;
loss='fobjetivo';
thetaold=theta;
lossold=func0;

%y0 e L0: interesse de c�l. apenas para f.banana, c�l. do erro relativo
% y0=lossold; covfmc0=covfmc; yreal0=freal;
% L0=L;
CountS=0;
CountS=CountS+1;
theta_lo=Xmin';
theta_hi=Xmax';
% ghatsum=zeros(NPar,1);
%Limites Xinf e Xsup das vari�veis para cada f.o. na rotina fobjetivo.m

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Suavizacao-LILIANE
%Parametros temporarios para testar o gmedio
gavg=5;

%%**********    1SPSA   **********************************  
tic
%Inicializa��o de lossold usada para op��o do loss blocking
% lossold=0;	%lossold calculation is for use in loss-based blocking step below
% for i=1:avg
%   lossold=lossold+feval(loss,theta);
% end
  %lossold=lossold/avg;         %ativar se avg > 1
  
%n�mero de gr�ficos VPL m�ximo x Dias
% numgraf=0;

for k=1:N
disp(['====================================================================== ITERA��O: k = ', num2str(k)])
    CountS=CountS+2;
    ak = (a)/(k+(A))^alpha;
    ck = (c)/(k)^gamma;
    
    %%% in�cio do loop do gmedio
    ghat=0;
    for jg=1:gavg  
        %%%%%
        delta = 2*round(rand(p,1))-1;
        thetaplus = theta + ck*delta;
        thetaminus = theta - ck*delta;
    % % % %     disp([' a= ',num2str(ak)])
    % % % %     disp([' c= ',num2str(ck)])
    % % % %     disp(['++ theta+ = ',num2str(thetaplus')])
    % % % %     disp(['-- theta- = ',num2str(thetaminus')])
    %%projete thetaplus e thetaminus no intervalo [Xinf, Xsup]
    %-- intervalo > dom�nio, para n�o limitar a secante nos pontos da fronteira em [Xmin, Xmax]
        tp=thetaplus;
        tm=thetaminus;
        zeromin=1.0000e-008;

        thetaplus=min(thetaplus,Xsup);
        thetaminus=min(thetaminus,Xsup);

        thetaplus=max(thetaplus,Xinf);
        thetaminus=max(thetaminus,Xinf);

        if (abs(thetaplus-thetaminus)) <= zeromin
          DeltaX = 1.0000e-004;      %%pode ser mudado, substituindo 0.1 por ck
           if (tp > tm)
               thetaplus = thetaminus + DeltaX;
           else
               thetaminus = thetaplus + DeltaX;
           end   
        end
    % % % %         disp('ap�s restri��es - proje��es')
    % % % %         disp(['++ theta+ = ',num2str(thetaplus')])
    % % % %         disp(['-- theta- = ',num2str(thetaminus')])
    %--
    %%avalie a fun��o nos dois pontos para passar a secante (=tangente) 
    % % % %     disp('++++ c�lculo de fobjetivo na perturba��o positiva thetaplus ++++')
        yplus=feval(loss,thetaplus);
    % % % %     disp(['++++ yplus= ',num2str(yplus)])
    % % % %     disp(['++++ yplus SEM restri��o= ',num2str(-freal)])

    % % % %     disp('---- c�lculo de fobjetivo na perturba��o positiva thetaminus ----')
        yminus=feval(loss,thetaminus);
    % % % %     disp(['---- yminus= ',num2str(yminus)])
    % % % %     disp(['---- yminus SEM restri��o= ',num2str(-freal)])

    % % % %     disp(' *** dados da otimiza��o na itera��o ***')    
        disp('----------------------------------------------------------------------------------------')

        %     ghat = (yplus - yminus)./(2*ck*delta);
    %alteracao em 15 de agosto - ghat anterior + ghat % 
        ghat = ((yplus - yminus)./(2*ck*delta))+ghat;  %ghat da suavizacao (gmedio)
        disp(['ghat= ',num2str(ghat')])
    %%c�lculo ghat m�dio:
    %     ghatsum = abs(ghat) + ghatsum;
    %     ghatmed = sum(ghatsum)/(NPar*k);
    %     disp(['ghat medio= ',num2str(ghatmed)])
    %     akmed=5/ghatmed;
    %     disp(['ak med= ',num2str(akmed)])
    %%%%%%%%%%%%% FIM DA SUAVIZACAO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end  %fim do loop do gmedio (gavg)

%%theta update (guarde valor de theta em thetaold para blocking adiante)
    thetaold=theta;
%%avalie o valor do passo do algoritmo (PASSO COM SUAVIZA��O)
%     sk=ak*ghat;         %sk (passo sem suaviza��o)
    sk=ak*ghat/gavg;      %alteracao em 15 de agosto - sk com gmedio
    sknorm=norm(sk);  %c�lculo ||sk||= norm no matlab. Para A vetor: norm(A,p)= sum(abs(A).^p)^(1/p), norm(A)=> p=2
% % % %     disp(['sk= ',num2str(sk')])
% % % %     disp(['sknorm= ',num2str(sknorm)])
%%fa�a o algoritmo caminhar  
    theta=theta-sk;%sk � o tamanho do passo do algoritmo j� na dire��o do novo gradiente
%%mas, sem ultrapassar a regi�o admiss�vel    
    theta=min(theta,theta_hi);
    theta=max(theta,theta_lo);
    disp(['theta (vari�veis de projeto) = ',num2str(theta')])
%As variaveis de projeto n�o assumem valores cont�nuos.  Abaixo elas ser�o
%aproximadas para inteiro mais pr�ximo.
%     theta=round(theta);
%     disp(['theta (vari�veis de projeto aproximadas)= ',num2str(theta')])
%--------------------------------------------------------------------------
%%BLOCKING LOSS (impe�a que o algoritmo ande muito pouco) 
% SPSA-B: use toleranceloss elevada
% This blocking is based on extra loss evaluation(s) -> se avg<>0
%     lossnew=0;
%     for i=1:avg
%         lossnew=lossnew+feval(loss,theta);
%         lossnew
%     end
%     if lossnew > lossold - avg*toleranceloss; %if avg=0, this statement is always false
%        theta=thetaold;
%        disp('lossnew > lossold')
%        theta
%     else                                    %statements to follow are harmless when avg=0
%        lossold1=lossold;
%        lossold=lossnew;
%        lossold
%     end
%--------------------------------------------------------------------------
%%BLOCKING THETA (impe�a que o algoritmo d� grandes saltos na vari�vel)
% SPSA-B: tolerancetheta ~ varia��o m�xima desejada em theta
%     if max(abs(thetaold-theta)) > tolerancetheta;
%        theta=thetaold;
%  %se theta bloqueado, n�o fa�a a 3� avalia��o e repita o valor anterior de y.      
%           if k==1       %bloqueado na 1� itera��o, repita valor anterior
%             y=lossold;  
%                 if op_mc == 1    
%             yreal=freal;
%             vary=varfmc;
%             stdy=stdfmc;
%             covy=covfmc;
%                 end
%           end
%        disp(' tttttt  theta block  tttttt')
%       %lossold=lossold1;     %ativar se usar lossblocking
%     else
%--------------------------------------------------------------------------
% %se theta n�o for bloqueado, faz 3� avalia��o para an�lise
% %avalia fun��o mais uma vez para entendimento
%         disp('********************************  ')
% % % %  disp('  Custo m�dio  ')
         y=feval(loss,theta);
         disp('----------------------------------------------------------------------------------------')
         disp('Valor da fun��o objetivo na 3� avalia��o do algoritmo spsa-b')
         disp(['y = ',num2str(y)])
    
%--------------------------------------------------------------------------        
%    if op_mc == 1
%         yreal=freal;
%         vary=varfmc;
%         stdy=stdfmc;
%         covy=covfmc;
%             end
%     end
%--------------------------------------------------------------------------
%     
%***** An�lise comportamento do algoritmo *******************
%avalia fun��o mais uma vez para entendimento

%%salva theta e y
    X(k,:)=theta;
% X: matriz com as vari�veis de projeto
% N�mero de linhas de X:  n�mero de itera��es
% N�mero de colunas de X: n�mero de vari�veis de projeto
    ys(k,:)=y;

%--------------------------------------------------------------------------    
%%plote graficos do VPL m�ximo no tempo (3 primeiras e 3 ultimas iteracoes)
% if op_tp_fob == 3
%     h_vfdias(k,:)=mean(vfdias);  %guarde valores medios de fdias (inicial, maximo e final) a cada k
%     h_vdiasmax(k,:)=mean(vdiasmax); %guarde a media dos tempo em q ocorrem os maximos
%     
% %     if k <= 3 | k >= N-2
% % %        gvplm
% %     end
% end
%%salve ghat e ghatmed para an�lise gr�fica    
%     vghat(k,1)=ghat(1);
%     vghatmed(k,1)=ghatmed(1);     
%     
% if op_mc == 1 
% %%salve estat�sticas do loop monte carlo para an�lise (y)    
%     medf_mc(k,:)=-yreal;
%     varf_mc(k,:)=vary;
%     stdf_mc(k,:)=stdy;
%     covf_mc(k,:)=covy;
%--------------------------------------------------------------------------

% OS VALORES DAS VARI�VEIS ALEAT�RIAS S�O ARMAZENADOS EM MATRIZES:

% CUSTO DA ESTRUTURA--------------------------------------------------------
% Custo das vigas
h_CVA(k,:)=CVA'; h_CVC(k,:)=CVC';  h_CVF(k,:)=CVF';
% h_CVA,h_CVC,h_CVF: matrizes com os custos de a�o,conc. e forma
% N�mero de linhas de cada matriz:  n�mero de itera��es
% N�mero de colunas de cada matriz: n�mero de Monte Carlo

% Custo das lajes
h_CLA(k,:)=CLA'; h_CLC(k,:)=CLC';  h_CLF(k,:)=CLF';
% h_CLA,h_CLC,h_CLF: matrizes com os custos de a�o,conc. e forma
% N�mero de linhas de cada matriz:  n�mero de itera��es
% N�mero de colunas de cada matriz: n�mero de Monte Carlo

% Custo dos pilares
h_CPA(k,:)=CPA'; h_CPC(k,:)=CPC';  h_CPF(k,:)=CPF';
% h_CPA,h_CPC,h_CPF: matrizes com os custos de a�o,conc. e forma
% N�mero de linhas de cada matriz:  n�mero de itera��es
% N�mero de colunas de cada matriz: n�mero de Monte Carlo

hf_mc(k,:)=f_mc';   
% hf_mc: matriz com os resultados da fun��o objetivo (custo da estrutura) 
% N�mero de linhas de hf_mc:  n�mero de itera��es
% N�mero de colunas de hf_mc: n�mero de Monte Carlo

%VIGA----------------------------------------------------------------------
hSPA_V(k,:)=SPA_V';
% hSPA_V: matriz com os pesos de a�o das vigas
% N�mero de linhas de hSPA_V: n�mero de itera��es
% N�mero de colunas de hSPA_V:n�mero de Monte Carlo

hSVC_V(k,:)=SVC_V';
% hSVC_V: matriz com os volumes de concreto das vigas.
% N�mero de linhas de hSVC_V:  n�mero de itera��es
% N�mero de colunas de hSVC_V: n�mero de Monte Carlo
      
hSForma_V(k,:)=SForma_V';
% hSForma_V: matriz com as �reas de forma das vigas.
% N�mero de linhas de hSForma_V:  n�mero de itera��es
% N�mero de colunas de hSForma_V: n�mero de Monte Carlo

%LAJE----------------------------------------------------------------------
hSPA_L(k,:)=SPA_L'; 
% hPA_L: matriz com os pesos de a�o das lajes.
% N�mero de linhas de hPA_L:  n�mero de itera��es
% N�mero de colunas de hPA_L: n�mero de Monte Carlo

hSVC_L(k,:)=SVC_L';
% hVC_L: matriz com os volumes de concreto das lajes.
% N�mero de linhas de hVC_L:  n�mero de itera��es
% N�mero de colunas de hVC_L: n�mero de Monte Carlo

hSForma_L(k,:)=SForma_L';
% vForma_L: matriz com as �reas de forma das lajes
% N�mero de linhas de vFormaL:   n�mero de itera��es
% N�mero de colunas de hForma_L: n�mero de Monte Carlo

%PILAR---------------------------------------------------------------------
hSPA_P(k,:)=SPA_P';
% hSPA_P: matriz com os pesos de a�o dos pilares
% N�mero de linhas de hSPA_P: n�mero de itera��es
% N�mero de colunas de hSPA_P:n�mero de Monte Carlo

hSVC_P(k,:)=SVC_P';
% hSVC_P: matriz com os volumes de concreto dos pilares
% N�mero de linhas de hSVC_P:  n�mero de itera��es
% N�mero de colunas de hSVC_P: n�mero de Monte Carlo
      
hSForma_P(k,:)=SForma_P';
% hSForma_P: matriz com as �reas de forma dos pilares
% N�mero de linhas de hSForma_P:  n�mero de itera��es
% N�mero de colunas de hSForma_P: n�mero de Monte Carlo

%A�O-----------------------------------------------------------------------
hfyV(k,:)=fyV';   
% hfyV: matriz com as resist�ncias ao escoamento do a�o.
% N�mero de linhas de hfyV:  n�mero de itera��es
% N�mero de colunas de hfyV: n�mero de Monte Carlo

%CONCRETO------------------------------------------------------------------
hfccV(k,:)=fccV';   
% hfccV: matriz com as resist�ncias � compress�o do concreto.
% N�mero de linhas de hfccV:  n�mero de itera��es
% N�mero de colunas de hfccV: n�mero de Monte Carlo

%GEOMETRIA-----------------------------------------------------------------
% X: matriz com as vari�veis de projeto
% N�mero de linhas de X:  n�mero de itera��es
% N�mero de colunas de X: n�mero de vari�veis de projeto


%--------------------------------------------------------------------------
%Imprime no 'fileout'.dat para plotar os gr�ficos  com sa�das MC  
%     fprintf(arqui(ii),'%12.8g %12.8g %12.8g %12.8g %12.8g %12.8g %12.8g %12.8g %12.8g \n', k, y, ak, ck, sknorm, covy, stdy, vary, -yreal);
% %Sa�da na tela de comando o n�mero de itera��es (opcao Monte Carlo)
%     disp([num2str(k),' vpl m�dio c/ restri��o cov= ', num2str(y)])
%     disp([num2str(k),' vpl m�dio SEM restri��o= ', num2str(-yreal)])
%     disp([' vari�ncia= ', num2str(vary)]);
%     disp([' desvio padr�o= ', num2str(stdy)]);
%     disp([' coef. varia��o= ', num2str(covy)]);
% else
%  %imprime no 'fileout'.dat para plotar os gr�ficos (NAO MC)  
%     fprintf(arqui(ii),'%12.8g %12.8g %12.8g %12.8g %12.8g %12.8g %12.8g \n', k, y, ak, ck, sknorm, CountS, L);
% end
% ************************************************************************* 
     
%--- Crit�rios de Parada - Erro Relativo ---    
% switch  op_tp_fob
%     case 1
%         if op_mc == 1           
%              disp([' op_restr= ', num2str(op_restr)]);
%              if op_restr == 2
%                  disp('case 1 - crit�rio parada')
%                  disp([' covb= ', num2str(covb)]);
%                  disp([' covy= ', num2str(covy)]);
%                  disp([' delta cov= ', num2str(delcov)]);
%                 if (covy >= covb-delcov) &  (covy <= covb)
%                     disp('BREAK')
%                     break
%                 end
%              end
%         end
%     case 7 %expg9
%         %reduc=(y+0.7901)/(y0+0.7901); usado p/ MC=>n existe L
%         reduc=(L+0.7901)/(L0+0.7901);
%         if abs (reduc) < 0.005  %criterio de parada
%                 break
%         end
%     case 8 %Griewank  reduc=normatheta
%         reduc= abs(sqrt((100^2+100^2))- sqrt(theta(1)^2+theta(2)^2));
%             if reduc < 0.02 & abs(y) < 0.01  %criterio de parada
%                 break
%             end
%     case 9 %Rosenbrock
%         reduc=(L-0)/(L0-0);       
%     case 10 %ST90
%         reduc =(L-(-40))/(L0-(-40)); 
%         toll=1E-05;
%             if y -(-40.0) <= toll
%                 break
%             end
%     otherwise
%         reduc=0;
% end
%--------------------------------------------------------------------------

vak(k)=ak;
vck(k)=ck;
vsknorm(k)=sknorm;
%salva as sa�das de cada rodada
save([fileout(1:end-4) '_' num2str(ii)]); 
% % % % disp(['============= nova itera��o ================  k = ', num2str(k+1)])
end  %FIM DO LOOP DAS ITERA��ES
toc

%M�DIAS E DESVIOS PADR�ES DAS REALIZA��ES NA �LTIMA ITERA��O:

%Viga
MpaV = mean(hSPA_V(k,:));    DPpaV = std(hSPA_V(k,:));    %Peso de a�o kg
MvcV = mean(hSVC_V(k,:));    DPvcV = std(hSVC_V(k,:));    %Vol. conc. m3
MafV = mean(hSForma_V(k,:)); DPafV = std(hSForma_V(k,:)); %�rea de forma m2
MCVA = mean(h_CVA(k,:));     DPCVA = std(h_CVA(k,:));     %Custo a�o R$
MCVC = mean(h_CVC(k,:));     DPCVC = std(h_CVC(k,:));     %Custo conc. R$
MCVF = mean(h_CVF(k,:));     DPCVF = std(h_CVF(k,:));     %Custo forma R$

%Laje
MpaL = mean(hSPA_L(k,:));    DPpaL = std(hSPA_L(k,:));    %Peso de a�o kg
MvcL = mean(hSVC_L(k,:));    DPvcL = std(hSVC_L(k,:));    %Vol. conc. m3
MafL = mean(hSForma_L(k,:)); DPafL = std(hSForma_L(k,:)); %�rea de forma m2
MCLA = mean(h_CLA(k,:));     DPCLA = std(h_CLA(k,:));     %Custo a�o R$
MCLC = mean(h_CLC(k,:));     DPCLC = std(h_CLC(k,:));     %Custo conc. R$
MCLF = mean(h_CLF(k,:));     DPCLF = std(h_CLF(k,:));     %Custo forma R$
     
%Pilar
MpaP = mean(hSPA_P(k,:));      DPpaP = std(hSPA_P(k,:));    %Peso de a�o kg
MvcP = mean(hSVC_P(k,:));      DPvcP = std(hSVC_P(k,:));    %Vol. conc. m3
MafP = mean(hSForma_P(k,:));   DPafP = std(hSForma_P(k,:)); %�rea de forma m2
MCPA = mean(h_CPA(k,:));       DPCPA = std(h_CPA(k,:));     %Custo a�o R$
MCPC = mean(h_CPC(k,:));       DPCPC = std(h_CPC(k,:));     %Custo conc. R$
MCPF = mean(h_CPF(k,:));       DPCPF = std(h_CPF(k,:));     %Custo forma R$

%Estrutura
MpaEST = MpaV + MpaL + MpaP;    
MvcEST = MvcV + MvcL + MvcP;
MafEST = MafV + MafL + MafP;

%Fun��o objetivo
DPfo = std(hf_mc(k,:));

disp('-------------------------------------------------------------------')
%AP�S TODAS AS ITERA��ES:
disp('RESULTADOS AP�S A �LTIMA ITERA��O DO ALGORITMO SPSA-B')
Xfim=X(k,:)';
disp(['Vari�veis de projeto:    X = ',num2str(Xfim')])

disp('Os valores abaixo s�o as m�dias das realiza��es na �ltima itera��o.')

disp('VIGA')
disp(['Peso de a�o (kg)       = ',num2str(MpaV),'      Desvio padr�o = ',num2str(DPpaV)])
disp(['Volume de concreto (m3)= ',num2str(MvcV),'      Desvio padr�o = ',num2str(DPvcV)])
disp(['�rea de forma (m2)     = ',num2str(MafV),'      Desvio padr�o = ',num2str(DPafV)])
disp(['Custo do peso de a�o (R$) = ',num2str(MCVA),'      Desvio padr�o = ',num2str(DPCVA)])
disp(['Custo do vol. de conc. (R$) = ',num2str(MCVC),'    Desvio padr�o = ',num2str(DPCVC)])
disp(['Custo da �rea de forma (R$) = ',num2str(MCVF),'    Desvio padr�o = ',num2str(DPCVF)])

disp('LAJE')
disp(['Peso de a�o (kg)       = ',num2str(MpaL),'      Desvio padr�o = ',num2str(DPpaL)])
disp(['Volume de concreto (m3)= ',num2str(MvcL),'      Desvio padr�o = ',num2str(DPvcL)])
disp(['�rea de forma (m2)     = ',num2str(MafL),'      Desvio padr�o = ',num2str(DPafL)])
disp(['Custo do peso de a�o (R$) = ',num2str(MCLA),'      Desvio padr�o = ',num2str(DPCLA)])
disp(['Custo do vol. de conc. (R$) = ',num2str(MCLC),'    Desvio padr�o = ',num2str(DPCLC)])
disp(['Custo da �rea de forma (R$) = ',num2str(MCLF),'    Desvio padr�o = ',num2str(DPCLF)])

disp('PILAR')
disp(['Peso de a�o (kg)       = ',num2str(MpaP),'      Desvio padr�o = ',num2str(DPpaP)])
disp(['Volume de concreto (m3)= ',num2str(MvcP),'      Desvio padr�o = ',num2str(DPvcP)])
disp(['�rea de forma (m2)     = ',num2str(MafP),'      Desvio padr�o = ',num2str(DPafP)])
disp(['Custo do peso de a�o (R$) = ',num2str(MCPA),'      Desvio padr�o = ',num2str(DPCPA)])
disp(['Custo do vol. de conc. (R$) = ',num2str(MCPC),'    Desvio padr�o = ',num2str(DPCPC)])
disp(['Custo da �rea de forma (R$) = ',num2str(MCPF),'    Desvio padr�o = ',num2str(DPCPF)])

%Estrutura
disp('ESTRUTURA')
disp(['Peso de a�o (kg)       = ',num2str(MpaEST)]);
disp(['Volume de concreto (m3)= ',num2str(MvcEST)]);
disp(['�rea de forma (m2)     = ',num2str(MafEST)]);

%Fun��o objetivo
disp('FUN��O OBJETIVO')
funcfim=y;
disp(['Valor da fun��o objetivo (R$) = ',num2str(funcfim),'      Desvio padr�o = ',num2str(std(hf_mc(k,:)))])
exitflg=1;
%fclose(arqui(ii));

%--------------------------------------------------------------------------
%gr�ficos
% if op_mc == 1   %mc
%     figs_stat
%     figs_hist
% else
%     titfig2     %nao mc
% end

%sa�das valores finais na vari�vel tabela 
%     if op_tp_fob ~= (1|2)
%         if op_tp_fob == 7
%            tabela(ii,:)=[y0 y L0 L reduc theta0 theta k];
%         else
%            tabela(ii,:)=[y0 y L0 L reduc theta0(1) theta0(2) theta(1) theta(2) k];
%         end
%     else
%         tabela(ii,:)=[y0 y L0 L];
%     end
%--------------------------------------------------------------------------
end

%save tabela

%--------------------------------------------------------------------------
%****** Fase Capta��o de M�nimos para Reinicializa��o *******
%Capta��o de m�nimos  (proximo passo: colocar esse trecho em rotina
%separada para ficar gen�rica e usar a t�cnica de reinicializa��o para
%todos os algoritmos de otimiza��o)
% nm=0;
% if ys(1)<=ys(2)
%     nm=nm+1;
%     lm(nm)=1;
%     ys(nm)=ys(1);
% end
% 
% na=5;   %m�ximo de reinicializa��es desejadas
% nfor=size(ys);
% 
% for im=2:1:nfor(1)-1
%     if ys(im)<ys(im+1)
%         if ys(im)<ys(im-1)
%             nm=nm+1;
%             lm(nm)=im;
%         end
%     end
% end
% 
% if  ys(nfor(1)) <= ys(nfor(1)-1)
%     nm=nm+1;
%     ys(nm)=ys(nfor(1));
%     lm(nm)=nfor(1);
% end
% %matriz com valor fobjetiva, itera��o e theta correpondente
% mywor=[ys(lm,:) lm(:,:)' X(lm,:)];  %matriz sem ordem
% mysor=sortrows(mywor,1);            %matriz ordenada por ys
% % ys e X m�nimos locais ordenados pelo menor valor de ys
% ysor=mysor(:,1);
% Xor=mysor(:,3:end);
% %limite de reinicializa��es
% n1=min(nm,na);      
% Xn1=Xor(1:n1,:);

%%Chamada do algoritmo de reinicializa��o
%--------------------------------------------------------------------------
save(fileout(1:end-4));

