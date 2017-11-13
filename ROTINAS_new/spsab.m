function [X, ys, vak, vck, vsknorm] = spsab(OTIM, DADOS, VIGA, PILAR, PAR, ELEMENTOS, PORTICO, FLUXOCAIXA, ESTRUTURAL,...
        CORTANTE, MOMENTO, NORMAL, TRANSX, TRANSZ, ROTACAO, CARGASOLO, COST, VPL)
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
ys(1)=OTIM.custoinicial;
vsknorm=zeros(1, N);
X=zeros(N, DADOS.NPar);

k=1;
while k<N    % Crit�rio de parada - AJUSTAR
    disp(['====================================================================== ITERA��O: k = ', num2str(k)])
% STEP 2 - GERA��O DO VETOR DE PERTURBA��O SIMULT�NEA
    ak=a/((A+k)^alpha);
    ck=c/(k^gamma);
    ghat=0;
    thetaold=theta; % Guarda o valor das vari�veis caso a itera��o seguinte v� p um ponto n�o desejado
    j=1;
    while j<=5
        delta = 2*round(rand(p,1))-1;
% STEP 3 - AVALIA��O DA FUN��O OBJETIVO EM DOIS PONTOS
        thetaplus = theta + (ck)*delta;
        thetaminus = theta - (ck)*delta;
%         thetaplus([1,3])=2.4;
%         thetaminus([1,3])=2.4;
        tp=thetaplus;
        tm=thetaminus;
        zeromin=1.0000e-008;
        % Restringe os valores de thetaplus e thetaminus ao limite superior
        thetaplus=min(thetaplus,OTIM.Xsup');
        thetaminus=min(thetaminus,OTIM.Xsup');
        % Restringe os valores de thetaplus e thetaminus ao limite inferior
        thetaplus=max(thetaplus,OTIM.Xinf');
        thetaminus=max(thetaminus,OTIM.Xinf');
        
        if (abs(thetaplus-thetaminus)) <= zeromin
          DeltaX = 1.0000e-004;      %%pode ser mudado, substituindo 0.1 por ck
           if (tp > tm)
               thetaplus = thetaminus + DeltaX;
           else
               thetaminus = thetaplus + DeltaX;
           end   
        end
        % A fun��o objetivo ser� avaliada em dois pontos a fim de estimar o
        % valor do gradinte, yplus e yminus � o valor m�dio do custo
        % calculado nas NMC itera��es de Monte Carlo
        disp(['    ------------------------------------------------------------------gmedio: j = ',num2str(j)])
        % YPLUS
        disp('    Avalia��o da fun��o objetivo em thetaplus')
        % Insere os valores de thetaplus em ELEMENTOS.secao
        secao=thetaplus;
        ELEMENTOS = assignsections(ELEMENTOS, PILAR, secao, ESTRUTURAL); 
        % Avalia��o da fun��o com o valores de thetaplus
        est=feval(loss,VIGA, PILAR, DADOS, PAR, ELEMENTOS, PORTICO, FLUXOCAIXA, COST, VPL, ESTRUTURAL, CORTANTE, MOMENTO, NORMAL, TRANSX, TRANSZ, ROTACAO, CARGASOLO);
        yplus=est.med;
        % YMINUS
        disp('    Avalia��o da fun��o objetivo em thetaminus')
        % Insere os valores de thetaminus em ELEMENTOS.secao
        secao=thetaminus;
        ELEMENTOS = assignsections(ELEMENTOS, PILAR, secao, ESTRUTURAL);
        % Avalia��o da fun��o com o valores de thetaminus
        est=feval(loss,VIGA, PILAR, DADOS, PAR, ELEMENTOS, PORTICO, FLUXOCAIXA, COST, VPL, ESTRUTURAL, CORTANTE, MOMENTO, NORMAL, TRANSX, TRANSZ, ROTACAO, CARGASOLO);
        yminus=est.med;
        
        if yplus<2*10^6 && yminus<2*10^6
            % STEP 4 - CRIA��O DE VETOR GRADIENTE APROXIMADO
            ghat = ((yplus - yminus)./(2*ck*delta))+ghat;
            j=j+1;
        end
    end
    disp('    ----------------------------------------------------------------')
    disp(['    ghat= ',num2str(ghat')])

% STEP 5 - ATUALIZA��O DO VALOR DE THETA
    sk=ak*ghat/5;         % <-- Passo sem suaviza��o
    sknorm=norm(sk);
    theta=theta-sk;     % <-- Atualiza��o do valor de theta
	% Limita o novo valor de theta aos limites superior e inferior   
    theta=min(theta,OTIM.Xsup');
    theta=max(theta,OTIM.Xinf');
%     theta([1,3])=2.4;
    % Avalia a fun��o mais uma vez no novo valor de theta
    secao=theta;
    ELEMENTOS = assignsections(ELEMENTOS, PILAR, secao, ESTRUTURAL);
    est=feval(loss,VIGA, PILAR, DADOS, PAR, ELEMENTOS, PORTICO, FLUXOCAIXA, COST, VPL, ESTRUTURAL, CORTANTE, MOMENTO, NORMAL, TRANSX, TRANSZ, ROTACAO, CARGASOLO);

if est.med>3*ys(k) || est.med>2*10^6
        disp('Fun��o foi p casa do kct')
        theta=thetaold;
    else
        % SALVA OS VALORES GERADOS NESTA ITERA��O
        % Valor m�dio da fun��o objetivo (Custo ou VPL)
        ys(k+1)=est.med;
        % Valor da se��o transversal dos elementos estruturais - vari�veis de
        % projeto
        X(k+1,:)=theta;
        % Valor dos coeficientes do gain armazenados em um vetor
        vak(k+1)=ak;
        vck(k+1)=ck;
        vsknorm(k+1)=sknorm;
        % Verifica��o do segundo crit�rio de parada - toler�ncia
        
        ss=k-10;
        if ss<=0
            ss=1;
        end
        vy=ys(ss:k);
        s=size(vy);
        s=s(2);
        for kk=1:s-1
            vtol(kk)=abs(vy(kk+1)-vy(kk));
        end

        if k==1
            vtol=0;
        end

        check=vtol<=DADOS.tolx;

        if sum(check)==10
            break
        end

        % Atualiza o valor de k
        k=k+1;
    end     
end