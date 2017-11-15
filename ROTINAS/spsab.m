function [X, ys, vak, vck, vsknorm, k] = spsab(maxRuns, OTIM, DADOS, VIGA, PILAR, PAR, ELEMENTOS, PORTICO, FLUXOCAIXA, ESTRUTURAL)
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
alpha=DADOS.alphaSPSA;      % Parâmetro "alpha" da função de ganho
gamma=DADOS.gamma;          % Parâmetro "gamma" da função de ganho
p=DADOS.NPar;               % <-- Número de variáveis a serem otimizadas
vtol = zeros(10);

% A variável theta0 é a variável a ser otimizada. Ela será o vetor com as
% dimensiões médias dos elementos estruturais
theta=OTIM.X0';
%loss='fobjetivo';
%theta_lo=OTIM.Xmin'; %FAB - Variáveis sem utilização.
%theta_hi=OTIM.Xmax';

% INÍCIO DO PROCESSO ITERATIVO
vak=zeros(1,N);
vck=zeros(1,N);
ys=zeros(1, N);
ys(1)=OTIM.custoinicial;
vsknorm=zeros(1, N);
X=zeros(N, DADOS.NPar);

k=1;
% repeticoes=0;
% estMed_min = 0;
% ak_min = 0;
% ck_min = 0;
% theta_min = theta;
% sknorm_min = 0;
while k<N    % Critério de parada - AJUSTAR
    %disp(['====================================================================== ITERAÇÃO: k = ', num2str(k)])
    tic
% STEP 2 - GERAÇÃO DO VETOR DE PERTURBAÇÃO SIMULTÂNEA
    ak=a/((A+k)^alpha);
    ck=c/(k^gamma);
    disp([' ** Alpha = ', num2str(alpha), ' ** Gamma = ', num2str(gamma), ' ** Ck = ', num2str(ck), ' ** Ak = ', num2str(ak), ' ** ITERAÇÃO: k = ', num2str(k)])
    ghat=0;
    thetaold=theta; % Guarda o valor das variáveis caso a iteração seguinte vá p um ponto não desejado
    j=1;
    while j<5
        delta = 2*round(rand(p,1))-1;
% STEP 3 - AVALIAÇÃO DA FUNÇÃO OBJETIVO EM DOIS PONTOS
        thetaplus = theta + ck*delta;
        thetaminus = theta - ck*delta;
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
        % A função objetivo será avaliada em dois pontos a fim de estimar o
        % valor do gradinte, yplus e yminus é o valor médio do custo
        % calculado nas NMC iterações de Monte Carlo
        
        % YPLUS
        %disp(['    ------------------------------------------------------------------gmedio: j = ',num2str(j)])
        %disp('    Avaliação da função objetivo em thetaplus')
        % Insere os valores de thetaplus em ELEMENTOS.secao
        secao=thetaplus;
        ELEMENTOS = assignsections(ELEMENTOS, PILAR, VIGA, secao, ESTRUTURAL); 
        % Avaliação da função com o valores de thetaplus
        est=fobjetivo(VIGA, PILAR, DADOS, PAR, ELEMENTOS, PORTICO, FLUXOCAIXA);
        yplus=est.med;
        % YMINUS
        %disp('    Avaliação da função objetivo em thetaminus');
        % Insere os valores de thetaminus em ELEMENTOS.secao
        secao=thetaminus;
        ELEMENTOS = assignsections(ELEMENTOS, PILAR, VIGA, secao, ESTRUTURAL); 
        % Avaliação da função com o valores de thetaminus
        est=fobjetivo(VIGA, PILAR, DADOS, PAR, ELEMENTOS, PORTICO, FLUXOCAIXA); 
        yminus=est.med;
        

% STEP 4 - CRIAÇÃO DE VETOR GRADIENTE APROXIMADO
        if (yplus < 9E9 && yminus < 9E9)
            ghat = ((yplus - yminus)./(2*ck*delta))+ghat;
            j=j+1;
        end
    end
    %disp('    ----------------------------------------------------------------')
    %disp(['    ghat= ',num2str(ghat')])

% STEP 5 - ATUALIZAÇÃO DO VALOR DE THETA
    sk=ak*ghat/5;         % <-- Passo sem suavização
    sknorm=norm(sk);
    theta=theta-sk;     % <-- Atualização do valor de theta
	% Limita o novo valor de theta aos limites superior e inferior   
    theta=min(theta,OTIM.Xsup');
    theta=max(theta,OTIM.Xinf');
	% Avalia a função mais uma vez no novo valor de theta
    secao=theta;
    disp(['    secao= ',num2str(theta')])
    ELEMENTOS = assignsections(ELEMENTOS, PILAR, VIGA, secao, ESTRUTURAL);
    est=fobjetivo(VIGA, PILAR, DADOS, PAR, ELEMENTOS, PORTICO, FLUXOCAIXA);
    
    if est.med>3*ys(k)
        disp('Função foi p casa do kct')
%         repeticoes=repeticoes+1;
%         if repeticoes == 1
%             estMed_min = est.med;
%             ak_min = ak;
%             ck_min = ck;
%             theta_min = theta;
%             sknorm_min = sknorm;
%         else
%             if (theta(1)*theta(2)+theta(3)*theta(4)+theta(5)*theta(6) < theta_min(1)*theta_min(2)+theta_min(3)*theta_min(4)+theta_min(5)*theta_min(6))
%                 estMed_min = est.med;
%                 ak_min = ak;
%                 ck_min = ck;
%                 theta_min = theta;
%                 sknorm_min = sknorm;
%             end
%         end
        theta=thetaold;
    else
%         if repeticoes == 50
%             disp('Repeti SPSA 50x e não consegui baixar o custo. Assumindo como menor e continuando...')
%             ys(k+1) = estMed_min;
%             vak(k+1) = ak_min;
%             vck(k+1) = ck_min;
%             X(k+1,:) = theta_min;
%             vsknorm(k+1) = sknorm_min;
%             break;
%         end
        %repeticoes = 0;
        % SALVA OS VALORES GERADOS NESTA ITERAÇÃO
        % Valor médio da função objetivo (Custo ou VPL)
        ys(k+1)=est.med;
        % Valor da seção transversal dos elementos estruturais - variáveis de
        % projeto
        X(k+1,:)=theta;
        % Valor dos coeficientes do gain armazenados em um vetor
        vak(k+1)=ak;
        vck(k+1)=ck;
        vsknorm(k+1)=sknorm;
        % Verificação do segundo critério de parada - tolerância
        
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
            disp(['    check= ',num2str(check)])
            
        
    
        if sum(check)==10
            break
        end
        
        if k>maxRuns/2
            if k>maxRuns
                disp(['    Saindo do SPSA pois k>', num2str(maxRuns),'. . .'])
                break
            end
            if sum(check)==0
                disp(['    Saindo do SPSA pois k>',num2str(maxRuns/2),' e não ficou na tolerância nas últimas 10 tentativas. . .'])
                break
            end
        end
        
        % Atualiza o valor de k
        k=k+1;
    end
    toc    
end



