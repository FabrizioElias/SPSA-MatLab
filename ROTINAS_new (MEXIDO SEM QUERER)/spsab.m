function [X, ys, vak, vck] = spsab(OTIM, DADOS, VIGA, PILAR, PAR, ELEMENTOS, PORTICO, FLUXOCAIXA)
%Minimizacao com SPSA-B (captacao de minimos sem reinicializa��o)
%--------------------------------------------------------------------------
%spsab
%theta0 = X (=parametros iniciais, rotina de Diego (Le_parametros)
%Criado:        xx-xx-1997      James Spall
%Modificacoes:  2009/2010       Liliane Fonseca e Prof. Ezio Araujo
%usar valor elevado para toleranceloss
%--------------------------------------------------------------------------

% STEP 1 - INICIALIZA��O SPSA
N=DADOS.N;                  % N�mero de avalia��es da fun��o objetivo
c=DADOS.c;                  % Par�metro "c" da fun��o de ganho  
a=DADOS.a;                  % Par�metro "a" da fun��o de ganho
A=DADOS.A;                  % Par�metro "A" da fun��o de ganho
alpha =DADOS.alphaSPSA;     % Par�metro "alpha" da fun��o de ganho
gamma =DADOS.gamma;         % Par�metro "gamma" da fun��o de ganho
p=DADOS.NPar;               % <-- N�mero de vari�veis a serem otimizadas

% A vari�vel theta0 � a vari�vel a ser otimizada. Ela ser� o vetor com as
% dimensi�es m�dias dos elementos estruturais
theta=OTIM.X0';
loss='fobjetivo';
theta_lo=OTIM.Xmin';
theta_hi=OTIM.Xmax';

% IN�CIO DO PROCESSO ITERATIVO
vak=zeros(1,N);
vck=zeros(1,N);
ys=zeros(1, N);
X=zeros(N, DADOS.NPar);
for k=1:N    % Crit�rio de parada - AJUSTAR
    disp(['====================================================================== ITERA��O: k = ', num2str(k)])
% STEP 2 - GERA��O DO VETOR DE PERTURBA��O SIMULT�NEA
    ak=a/((A+k+1)^alpha);
    ck=c/((k+1)^gamma);
    delta = 2*round(rand(p,1))-1;
% STEP 3 - AVALIA��O DA FUN��O OBJETIVO EM DOIS PONTOS
    thetaplus = theta + ck*delta;
    thetaminus = theta - ck*delta;
    tp=thetaplus;
    tm=thetaminus;
    zeromin=1.0000e-008;
    % Restringe os valores de thetaplus e thetaminus ao limite superior
    thetaplus=min(thetaplus,OTIM.Xsup);
    thetaminus=min(thetaminus,OTIM.Xsup);
    % Restringe os valores de thetaplus e thetaminus ao limite inferior
    thetaplus=max(thetaplus,OTIM.Xinf);
    thetaminus=max(thetaminus,OTIM.Xinf);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % N�o sei o que � feito nesse if!!!
        if (abs(thetaplus-thetaminus)) <= zeromin
          DeltaX = 1.0000e-004;      %%pode ser mudado, substituindo 0.1 por ck
           if (tp > tm)
               thetaplus = thetaminus + DeltaX;
           else
               thetaminus = thetaplus + DeltaX;
           end   
        end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % A fun��o objetivo ser� avaliada em dois pontos a fim de estimar o
    % valor do gradinte.
    % yplus e yminus � o valor m�dio das NMC itera��es de Monte Carlo
    % Insere os valores de thetaplus em ELEMENTOS.secao
    secao=thetaplus;
    ELEMENTOS = assignsections(ELEMENTOS, PILAR, VIGA, secao); 
    % Avalia��o da fun��o com o valores de thetaplus
    est=feval(loss,VIGA, PILAR, DADOS, PAR, ELEMENTOS, PORTICO, FLUXOCAIXA);
    yplus=est.med;
    % Insere os valores de thetaminus em ELEMENTOS.secao
    secao=thetaminus;
    ELEMENTOS = assignsections(ELEMENTOS, PILAR, VIGA, secao); 
    % Avalia��o da fun��o com o valores de thetaminus
    est=feval(loss,VIGA, PILAR, DADOS, PAR, ELEMENTOS, PORTICO, FLUXOCAIXA); 
    yminus=est.med;

% STEP 4 - CRIA��O DE VETOR GRADIENTE APROXIMADO
    ghat = ((yplus - yminus)./(2*ck*delta)); 
    disp(['ghat= ',num2str(ghat')])

% STEP 5 - ATUALIZA��O DO VALOR DE THETA
    sk=ak*ghat;         % <-- Passo sem suaviza��o
    theta=theta-sk;     % <-- Atualiza��o do valor de theta
	% Limita o novo valor de theta aos limites superior e inferior   
    theta=min(theta,theta_hi);
    theta=max(theta,theta_lo);
	% Avalia a fun��o mais uma vez no novo valor de theta
    secao=theta;
    ELEMENTOS = assignsections(ELEMENTOS, PILAR, VIGA, secao);
    est=feval(loss,VIGA, PILAR, DADOS, PAR, ELEMENTOS, PORTICO, FLUXOCAIXA);

% SALVA OS VALORES GERADOS NESTA ITERA��O
    % Valor m�dio da fun��o objetivo (Custo ou VPL)
    ys(k)=est.med;
    % Valor da se��o transversal dos elementos estruturais - vari�veis de
    % projeto
    X(k,:)=theta;
    % Valor dos coeficientes do gain armazenados em um vetor
    vak(k)=ak;
    vck(k)=ck;
end



