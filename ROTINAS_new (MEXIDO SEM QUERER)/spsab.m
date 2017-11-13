function [X, ys, vak, vck] = spsab(OTIM, DADOS, VIGA, PILAR, PAR, ELEMENTOS, PORTICO, FLUXOCAIXA)
%Minimizacao com SPSA-B (captacao de minimos sem reinicialização)
%--------------------------------------------------------------------------
%spsab
%theta0 = X (=parametros iniciais, rotina de Diego (Le_parametros)
%Criado:        xx-xx-1997      James Spall
%Modificacoes:  2009/2010       Liliane Fonseca e Prof. Ezio Araujo
%usar valor elevado para toleranceloss
%--------------------------------------------------------------------------

% STEP 1 - INICIALIZAÇÃO SPSA
N=DADOS.N;                  % Número de avaliações da função objetivo
c=DADOS.c;                  % Parâmetro "c" da função de ganho  
a=DADOS.a;                  % Parâmetro "a" da função de ganho
A=DADOS.A;                  % Parâmetro "A" da função de ganho
alpha =DADOS.alphaSPSA;     % Parâmetro "alpha" da função de ganho
gamma =DADOS.gamma;         % Parâmetro "gamma" da função de ganho
p=DADOS.NPar;               % <-- Número de variáveis a serem otimizadas

% A variável theta0 é a variável a ser otimizada. Ela será o vetor com as
% dimensiões médias dos elementos estruturais
theta=OTIM.X0';
loss='fobjetivo';
theta_lo=OTIM.Xmin';
theta_hi=OTIM.Xmax';

% INÍCIO DO PROCESSO ITERATIVO
vak=zeros(1,N);
vck=zeros(1,N);
ys=zeros(1, N);
X=zeros(N, DADOS.NPar);
for k=1:N    % Critério de parada - AJUSTAR
    disp(['====================================================================== ITERAÇÃO: k = ', num2str(k)])
% STEP 2 - GERAÇÃO DO VETOR DE PERTURBAÇÃO SIMULTÂNEA
    ak=a/((A+k+1)^alpha);
    ck=c/((k+1)^gamma);
    delta = 2*round(rand(p,1))-1;
% STEP 3 - AVALIAÇÃO DA FUNÇÃO OBJETIVO EM DOIS PONTOS
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
        % Não sei o que é feito nesse if!!!
        if (abs(thetaplus-thetaminus)) <= zeromin
          DeltaX = 1.0000e-004;      %%pode ser mudado, substituindo 0.1 por ck
           if (tp > tm)
               thetaplus = thetaminus + DeltaX;
           else
               thetaminus = thetaplus + DeltaX;
           end   
        end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % A função objetivo será avaliada em dois pontos a fim de estimar o
    % valor do gradinte.
    % yplus e yminus é o valor médio das NMC iterações de Monte Carlo
    % Insere os valores de thetaplus em ELEMENTOS.secao
    secao=thetaplus;
    ELEMENTOS = assignsections(ELEMENTOS, PILAR, VIGA, secao); 
    % Avaliação da função com o valores de thetaplus
    est=feval(loss,VIGA, PILAR, DADOS, PAR, ELEMENTOS, PORTICO, FLUXOCAIXA);
    yplus=est.med;
    % Insere os valores de thetaminus em ELEMENTOS.secao
    secao=thetaminus;
    ELEMENTOS = assignsections(ELEMENTOS, PILAR, VIGA, secao); 
    % Avaliação da função com o valores de thetaminus
    est=feval(loss,VIGA, PILAR, DADOS, PAR, ELEMENTOS, PORTICO, FLUXOCAIXA); 
    yminus=est.med;

% STEP 4 - CRIAÇÃO DE VETOR GRADIENTE APROXIMADO
    ghat = ((yplus - yminus)./(2*ck*delta)); 
    disp(['ghat= ',num2str(ghat')])

% STEP 5 - ATUALIZAÇÃO DO VALOR DE THETA
    sk=ak*ghat;         % <-- Passo sem suavização
    theta=theta-sk;     % <-- Atualização do valor de theta
	% Limita o novo valor de theta aos limites superior e inferior   
    theta=min(theta,theta_hi);
    theta=max(theta,theta_lo);
	% Avalia a função mais uma vez no novo valor de theta
    secao=theta;
    ELEMENTOS = assignsections(ELEMENTOS, PILAR, VIGA, secao);
    est=feval(loss,VIGA, PILAR, DADOS, PAR, ELEMENTOS, PORTICO, FLUXOCAIXA);

% SALVA OS VALORES GERADOS NESTA ITERAÇÃO
    % Valor médio da função objetivo (Custo ou VPL)
    ys(k)=est.med;
    % Valor da seção transversal dos elementos estruturais - variáveis de
    % projeto
    X(k,:)=theta;
    % Valor dos coeficientes do gain armazenados em um vetor
    vak(k)=ak;
    vck(k)=ck;
end



