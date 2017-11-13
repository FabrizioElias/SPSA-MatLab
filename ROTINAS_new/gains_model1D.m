function [DADOS] = gains_model1D(OTIM, DADOS, ELEMENTOS, PILAR, VIGA, PAR, PORTICO, VPL, ESTRUTURAL, CORTANTE, MOMENTO, NORMAL, TRANSX, TRANSZ, ROTACAO, CARGASOLO, FLUXOCAIXA, COST)
% J. C. Spall, March 1999
% This code provides values of a, A, and c in the gains a_k=a/(k+1+A)^alpha and 
% c_k = c/(k+1)^.101.  Code assumes Bernoulli +/- 1 distribution for the delta elements. 
%
% Note: if get some error "Subscript indices must be integer values"
% then use "clear" function and redo.
%
% Specify the dimension, loss function, and i.c. for theta; also alpha for gain 
% selection (alpha = 0.602 is often used as a companion to gamma = 0.101). 
%
%global sigma p z	% sigma is noise level used in loss calls; z is global 
						% random variable for use in generating noise in loss
						% function calls(so that seed can be set here).
                        
% op_in=InputDados_struct;                        
%sigma=std(X0);
X0=OTIM.X0;

p=length(X0);
NVar=p;
loss='fobjetivo';
theta=X0';

%Limites Xinf e Xsup das variáveis para cada f.o. na rotina fobjetivo.m
% RESTRIÇÃO PARA AS PERMEABILIDADES DO PROBLEMA MODEL1D - EMERICK
%Xinf e Xsup sao os valores minimos e maximos na escala da permeabilidade
%do problema
% thetamin=0;
% thetamax=16;
% Xinf=thetamin*ones(NVar,1);
% Xsup=thetamax*ones(NVar,1);

%Xmin e Xmax sao os valores minimos e maximos na escala percentual.
Xmin=OTIM.Xmin';
Xmax=OTIM.Xmax';
theta_lo=Xmin;
theta_hi=Xmax;

alpha=DADOS.alphaSPSA;
gamma=DADOS.gamma;
gmedio=DADOS.gmedio;
stepi=DADOS.stepi;
N=DADOS.N;
%
% User input on measurement noise level, expected no. of iterations in the SPSA run,
% desired magnitude of change in the theta elements, the number of SPSA gradient approximations
% that will be averaged, and the no. of loss evaluations to be used in the gain calculations
% here (note this no. should be divisible by twice the no. of averaged gradients).
%
% step= input('What is the initial desired magnitude of change in the theta elements? ');
% step=0.5;
step=stepi;
% gavg= input('How many averaged SP gradients will be used per iteration? ');
% gavg=10;
gavg=gmedio;
% A = .10*input('What is the expected number of loss evaluations per run? ')...
%    /(2*gavg);
A = .10*N/(2*gavg);
% c = input('What is the standard deviation of the measurement noise at i.c.? '); %sem ruido c=0 !!!

% Xp=((theta-Xinf)./(Xsup-Xinf))*100;
c=std(X0);

c = max(c/gavg^0.5, .0001); %averaging set up for independent noise
% NL = input('How many loss function evaluations do you want to use in this gain calculation? ');
NL=30;
%
% Do the NL/(2*gavg) SP gradient estimates
%
% rand('seed',31415927)	% Seed for delta generation
% randn('seed',111113); 	% Seed for noise in loss measurements
gbar=zeros(p,1);
for i=1:NL/(2*gavg)
    ghat=zeros(p,1);
    j=1;
    while j<=gavg
        delta=2*round(rand(p,1))-1;
        thetaplus = theta + c*delta;
        thetaminus = theta - c*delta;
%------- projecao dos theta no dominio permitido ----------%   
        thetaplus=min(thetaplus,theta_hi);
        thetaminus=min(thetaminus,theta_hi);
        thetaplus=max(thetaplus,theta_lo);
        thetaminus=max(thetaminus,theta_lo);  
%-----------------------------------------------------------%
        secao=thetaplus;
        ELEMENTOS = assignsections(ELEMENTOS, PILAR, secao, ESTRUTURAL); 
        % Avaliação da função com o valores de thetaplus
        est=feval(loss,VIGA, PILAR, DADOS, PAR, ELEMENTOS, PORTICO, FLUXOCAIXA, COST, VPL, ESTRUTURAL, CORTANTE, MOMENTO, NORMAL, TRANSX, TRANSZ, ROTACAO, CARGASOLO);
        yplus=est.med;
        % Inserir os valores de thetaminus em ELEMENTOS.secao
        secao=thetaminus;
        ELEMENTOS = assignsections(ELEMENTOS, PILAR, secao, ESTRUTURAL); 
        % Avaliação da função com o valores de thetaminus
        est=feval(loss,VIGA, PILAR, DADOS, PAR, ELEMENTOS, PORTICO, FLUXOCAIXA, COST, VPL, ESTRUTURAL, CORTANTE, MOMENTO, NORMAL, TRANSX, TRANSZ, ROTACAO, CARGASOLO);
        yminus=est.med;
        % Cálculo do ghat
        if yplus<2*10^6 && yminus<2*10^6
            % STEP 4 - CRIAÇÃO DE VETOR GRADIENTE APROXIMADO
            ghat = ((yplus - yminus)./(2*c*delta))+ghat;
            j=j+1;
        end
    end
    gbar=gbar+abs(ghat/gavg);
end

meangbar=mean(gbar);
meangbar=meangbar/(NL/(2*gavg));
a=step*((A+1)^alpha)/meangbar;
% ARMAZENA E PLOTA OS VALORES DAS COSNTANTES DO GAIN
DADOS.c=c;
DADOS.A=A;
DADOS.a=a;
disp(['   Valor do parâmetro c = ',num2str(DADOS.c)])
disp(['   Valor do parâmetro A = ',num2str(DADOS.A)])
disp(['   Valor do parâmetro a = ',num2str(DADOS.a)])

