%FAB - Função sem uso.

% function [X, ys, vak, vck] = spsab(OTIM, DADOS, ESTATISTICA, VIGA, PILAR, PAR, ELEMENTOS, PORTICO, FLUXOCAIXA)
% %Minimizacao com SPSA-B (captacao de minimos sem reinicialização)
% %--------------------------------------------------------------------------
% %spsab
% %theta0 = X (=parametros iniciais, rotina de Diego (Le_parametros)
% %Criado:        xx-xx-1997      James Spall
% %Modificacoes:  2009/2010       Liliane Fonseca e Prof. Ezio Araujo
% %usar valor elevado para toleranceloss
% %--------------------------------------------------------------------------
% 
% % STEP 1 - INICIALIZAÇÃO SPSA
% N=DADOS.N;                  % Número de avaliações da função objetivo
% c=DADOS.c;                  % Parâmetro "c" da função de ganho  
% a=DADOS.a;                  % Parâmetro "a" da função de ganho
% A=DADOS.A;                  % Parâmetro "A" da função de ganho
% alpha =DADOS.alphaSPSA;     % Parâmetro "alpha" da função de ganho
% gamma =DADOS.gamma;         % Parâmetro "gamma" da função de ganho
% tolerancetheta=DADOS.tolx;  % <-- max. variação permitida em theta (fase 1SPSA)
% toleranceloss=DADOS.tolfun;
% p=DADOS.NPar;               % <-- Número de variáveis a serem otimizadas
% 
% % A variável theta0 é a variável a ser otimizada. Ela será o vetor com as
% % dimensiões médias dos elementos estruturais
% theta=OTIM.X0';
% loss='fobjetivo';
% thetaold=theta;
% lossold=ESTATISTICA.med(1);
% CountS=0;
% CountS=CountS+1;
% theta_lo=OTIM.Xmin';
% theta_hi=OTIM.Xmax';
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Suavizacao-LILIANE
% %Parametros temporarios para testar o gmedio
% gavg=5;
% 
% % INÍCIO DO PROCESSO ITERATIVO
% vak=zeros(1,N);
% vck=zeros(1,N);
% for k=1:N    % Critério de parada - AJUSTAR
%     tic
%     disp(['====================================================================== ITERAÇÃO: k = ', num2str(k)])
%     CountS=CountS+2;
%     ak=a/((k+A)^alpha);
%     ck=c/(k^gamma);
% 
%     %%% início do loop do gmedio
%     ghat=0;
%     for jg=1:gavg  
%         delta = 2*round(rand(p,1))-1;
%         thetaplus = theta + ck*delta;
%         thetaminus = theta - ck*delta;
%         tp=thetaplus;
%         tm=thetaminus;
%         zeromin=1.0000e-008;
%         % Restringe os valores de thetaplus e thetaminus ao limite superior
%         thetaplus=min(thetaplus,OTIM.Xsup);
%         thetaminus=min(thetaminus,OTIM.Xsup);
%         % Restringe os valores de thetaplus e thetaminus ao limite inferior
%         thetaplus=max(thetaplus,OTIM.Xinf);
%         thetaminus=max(thetaminus,OTIM.Xinf);
%         
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         % Não sei o que é feito nesse if!!!
%         if (abs(thetaplus-thetaminus)) <= zeromin
%           DeltaX = 1.0000e-004;      %%pode ser mudado, substituindo 0.1 por ck
%            if (tp > tm)
%                thetaplus = thetaminus + DeltaX;
%            else
%                thetaminus = thetaplus + DeltaX;
%            end   
%         end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%         % A função objetivo será avaliada em dois pontos a fim de estimar o
%         % valor do gradinte.
%         % yplus e yminus é o valor médio das NMC iterações de Monte Carlo
%         % Insere os valores de thetaplus em ELEMENTOS.secao
%         secao=thetaplus;
%         ELEMENTOS = assignsections(ELEMENTOS, PILAR, VIGA, secao); 
%         % Avaliação da função com o valores de thetaplus
%         est=feval(loss,VIGA, PILAR, DADOS, PAR, ELEMENTOS, PORTICO, FLUXOCAIXA);
%         yplus=est.med;
%         % Insere os valores de thetaminus em ELEMENTOS.secao
%         secao=thetaminus;
%         ELEMENTOS = assignsections(ELEMENTOS, PILAR, VIGA, secao); 
%         % Avaliação da função com o valores de thetaminus
%         est=feval(loss,VIGA, PILAR, DADOS, PAR, ELEMENTOS, PORTICO, FLUXOCAIXA); 
%         yminus=est.med;
% 
% %       ghat = (yplus - yminus)./(2*ck*delta);
%         % alteracao em 15 de agosto - ghat anterior + ghat % 
%         ghat = ((yplus - yminus)./(2*ck*delta))+ghat;  %ghat da suavizacao (gmedio)
%         disp(['ghat= ',num2str(ghat')])
%     %%cálculo ghat médio:
%     %     ghatsum = abs(ghat) + ghatsum;
%     %     ghatmed = sum(ghatsum)/(NPar*k);
%     %     disp(['ghat medio= ',num2str(ghatmed)])
%     %     akmed=5/ghatmed;
%     %     disp(['ak med= ',num2str(akmed)])
%     %%%%%%%%%%%%% FIM DA SUAVIZACAO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     end  %fim do loop do gmedio (gavg)
% 
% %%theta update (guarde valor de theta em thetaold para blocking adiante)
%     thetaold=theta;
% %%avalie o valor do passo do algoritmo (PASSO COM SUAVIZAÇÃO)
% %     sk=ak*ghat;         %sk (passo sem suavização)
%     sk=ak*ghat/gavg;      %alteracao em 15 de agosto - sk com gmedio
%     sknorm=norm(sk);  %cálculo ||sk||= norm no matlab. Para A vetor: norm(A,p)= sum(abs(A).^p)^(1/p), norm(A)=> p=2
% % % % %     disp(['sk= ',num2str(sk')])
% % % % %     disp(['sknorm= ',num2str(sknorm)])
% %%faça o algoritmo caminhar  
%     theta=theta-sk;%sk é o tamanho do passo do algoritmo já na direção do novo gradiente
% %%mas, sem ultrapassar a região admissível    
%     theta=min(theta,theta_hi);
%     theta=max(theta,theta_lo);
% %         disp(['theta (variáveis de projeto) = ',num2str(theta')])
% %As variaveis de projeto não assumem valores contínuos.  Abaixo elas serão
% %aproximadas para inteiro mais próximo.
% %     theta=round(theta);
% %     disp(['theta (variáveis de projeto aproximadas)= ',num2str(theta')])
% %--------------------------------------------------------------------------
% %%BLOCKING LOSS (impeça que o algoritmo ande muito pouco) 
% % SPSA-B: use toleranceloss elevada
% % This blocking is based on extra loss evaluation(s) -> se avg<>0
% %     lossnew=0;
% %     for i=1:avg
% %         lossnew=lossnew+feval(loss,theta);
% %         lossnew
% %     end
% %     if lossnew > lossold - avg*toleranceloss; %if avg=0, this statement is always false
% %        theta=thetaold;
% %        disp('lossnew > lossold')
% %        theta
% %     else                                    %statements to follow are harmless when avg=0
% %        lossold1=lossold;
% %        lossold=lossnew;
% %        lossold
% %     end
% %--------------------------------------------------------------------------
% %%BLOCKING THETA (impeça que o algoritmo dê grandes saltos na variável)
% % SPSA-B: tolerancetheta ~ variação máxima desejada em theta
% %     if max(abs(thetaold-theta)) > tolerancetheta;
% %        theta=thetaold;
% %  %se theta bloqueado, não faça a 3ª avaliação e repita o valor anterior de y.      
% %           if k==1       %bloqueado na 1ª iteração, repita valor anterior
% %             y=lossold;  
% %                 if op_mc == 1    
% %             yreal=freal;
% %             vary=varfmc;
% %             stdy=stdfmc;
% %             covy=covfmc;
% %                 end
% %           end
% %        disp(' tttttt  theta block  tttttt')
% %       %lossold=lossold1;     %ativar se usar lossblocking
% %     else
% %--------------------------------------------------------------------------
% % %se theta não for bloqueado, faz 3ª avaliação para análise
% % %avalia função mais uma vez para entendimento
% %         disp('********************************  ')
% % % % %  disp('  Custo médio  ')
%     secao=theta;
%     ELEMENTOS = assignsections(ELEMENTOS, PILAR, VIGA, secao);
%     est=feval(loss,VIGA, PILAR, DADOS, PAR, ELEMENTOS, PORTICO, FLUXOCAIXA);
%     y=est.med;
% %         disp('----------------------------------------------------------------------------------------')
% %         disp('Valor da função objetivo na 3ª avaliação do algoritmo spsa-b')
% %         disp(['y = ',num2str(y)])
% 
% %--------------------------------------------------------------------------        
% %    if op_mc == 1
% %         yreal=freal;
% %         vary=varfmc;
% %         stdy=stdfmc;
% %         covy=covfmc;
% %             end
% %     end
% %--------------------------------------------------------------------------
% %     
% %***** Análise comportamento do algoritmo *******************
% %avalia função mais uma vez para entendimento
% 
% %%salva theta e y
%     X(k,:)=theta;
% % X: matriz com as variáveis de projeto
% % Número de linhas de X:  número de iterações
% % Número de colunas de X: número de variáveis de projeto
%     ys(k,:)=y;
% 
% %--------------------------------------------------------------------------    
% %%plote graficos do VPL máximo no tempo (3 primeiras e 3 ultimas iteracoes)
% % if op_tp_fob == 3
% %     h_vfdias(k,:)=mean(vfdias);  %guarde valores medios de fdias (inicial, maximo e final) a cada k
% %     h_vdiasmax(k,:)=mean(vdiasmax); %guarde a media dos tempo em q ocorrem os maximos
% %     
% % %     if k <= 3 | k >= N-2
% % % %        gvplm
% % %     end
% % end
% %%salve ghat e ghatmed para análise gráfica    
% %     vghat(k,1)=ghat(1);
% %     vghatmed(k,1)=ghatmed(1);     
% %     
% % if op_mc == 1 
% % %%salve estatísticas do loop monte carlo para análise (y)    
% %     medf_mc(k,:)=-yreal;
% %     varf_mc(k,:)=vary;
% %     stdf_mc(k,:)=stdy;
% %     covf_mc(k,:)=covy;
% %--------------------------------------------------------------------------
% 
% %     % OS VALORES DAS VARIÁVEIS ALEATÓRIAS SÃO ARMAZENADOS EM MATRIZES:
% % 
% %     % CUSTO DA ESTRUTURA--------------------------------------------------------
% %     % Custo das vigas
% %     h_CVA(k,:)=CVA'; h_CVC(k,:)=CVC';  h_CVF(k,:)=CVF';
% %     % h_CVA,h_CVC,h_CVF: matrizes com os custos de aço,conc. e forma
% %     % Número de linhas de cada matriz:  número de iterações
% %     % Número de colunas de cada matriz: número de Monte Carlo
% % 
% %     % Custo das lajes
% %     h_CLA(k,:)=CLA'; h_CLC(k,:)=CLC';  h_CLF(k,:)=CLF';
% %     % h_CLA,h_CLC,h_CLF: matrizes com os custos de aço,conc. e forma
% %     % Número de linhas de cada matriz:  número de iterações
% %     % Número de colunas de cada matriz: número de Monte Carlo
% % 
% %     % Custo dos pilares
% %     h_CPA(k,:)=CPA'; h_CPC(k,:)=CPC';  h_CPF(k,:)=CPF';
% %     % h_CPA,h_CPC,h_CPF: matrizes com os custos de aço,conc. e forma
% %     % Número de linhas de cada matriz:  número de iterações
% %     % Número de colunas de cada matriz: número de Monte Carlo
% % 
% %     hf_mc(k,:)=f_mc';   
% %     % hf_mc: matriz com os resultados da função objetivo (custo da estrutura) 
% %     % Número de linhas de hf_mc:  número de iterações
% %     % Número de colunas de hf_mc: número de Monte Carlo
% % 
% %     %VIGA----------------------------------------------------------------------
% %     hSPA_V(k,:)=SPA_V';
% %     % hSPA_V: matriz com os pesos de aço das vigas
% %     % Número de linhas de hSPA_V: número de iterações
% %     % Número de colunas de hSPA_V:número de Monte Carlo
% % 
% %     hSVC_V(k,:)=SVC_V';
% %     % hSVC_V: matriz com os volumes de concreto das vigas.
% %     % Número de linhas de hSVC_V:  número de iterações
% %     % Número de colunas de hSVC_V: número de Monte Carlo
% % 
% %     hSForma_V(k,:)=SForma_V';
% %     % hSForma_V: matriz com as áreas de forma das vigas.
% %     % Número de linhas de hSForma_V:  número de iterações
% %     % Número de colunas de hSForma_V: número de Monte Carlo
% % 
% %     %LAJE----------------------------------------------------------------------
% %     hSPA_L(k,:)=SPA_L'; 
% %     % hPA_L: matriz com os pesos de aço das lajes.
% %     % Número de linhas de hPA_L:  número de iterações
% %     % Número de colunas de hPA_L: número de Monte Carlo
% % 
% %     hSVC_L(k,:)=SVC_L';
% %     % hVC_L: matriz com os volumes de concreto das lajes.
% %     % Número de linhas de hVC_L:  número de iterações
% %     % Número de colunas de hVC_L: número de Monte Carlo
% % 
% %     hSForma_L(k,:)=SForma_L';
% %     % vForma_L: matriz com as áreas de forma das lajes
% %     % Número de linhas de vFormaL:   número de iterações
% %     % Número de colunas de hForma_L: número de Monte Carlo
% % 
% %     %PILAR---------------------------------------------------------------------
% %     hSPA_P(k,:)=SPA_P';
% %     % hSPA_P: matriz com os pesos de aço dos pilares
% %     % Número de linhas de hSPA_P: número de iterações
% %     % Número de colunas de hSPA_P:número de Monte Carlo
% % 
% %     hSVC_P(k,:)=SVC_P';
% %     % hSVC_P: matriz com os volumes de concreto dos pilares
% %     % Número de linhas de hSVC_P:  número de iterações
% %     % Número de colunas de hSVC_P: número de Monte Carlo
% % 
% %     hSForma_P(k,:)=SForma_P';
% %     % hSForma_P: matriz com as áreas de forma dos pilares
% %     % Número de linhas de hSForma_P:  número de iterações
% %     % Número de colunas de hSForma_P: número de Monte Carlo
% % 
% %     %AÇO-----------------------------------------------------------------------
% %     hfyV(k,:)=fyV';   
% %     % hfyV: matriz com as resistências ao escoamento do aço.
% %     % Número de linhas de hfyV:  número de iterações
% %     % Número de colunas de hfyV: número de Monte Carlo
% % 
% %     %CONCRETO------------------------------------------------------------------
% %     hfccV(k,:)=fccV';   
% %     % hfccV: matriz com as resistências à compressão do concreto.
% %     % Número de linhas de hfccV:  número de iterações
% %     % Número de colunas de hfccV: número de Monte Carlo
% % 
% %     %GEOMETRIA-----------------------------------------------------------------
% %     % X: matriz com as variáveis de projeto
% %     % Número de linhas de X:  número de iterações
% %     % Número de colunas de X: número de variáveis de projeto
% % 
% % 
% %     %--------------------------------------------------------------------------
% %     %Imprime no 'fileout'.dat para plotar os gráficos  com saídas MC  
% %     %     fprintf(arqui(ii),'%12.8g %12.8g %12.8g %12.8g %12.8g %12.8g %12.8g %12.8g %12.8g \n', k, y, ak, ck, sknorm, covy, stdy, vary, -yreal);
% %     % %Saída na tela de comando o número de iterações (opcao Monte Carlo)
% %     %     disp([num2str(k),' vpl médio c/ restrição cov= ', num2str(y)])
% %     %     disp([num2str(k),' vpl médio SEM restrição= ', num2str(-yreal)])
% %     %     disp([' variância= ', num2str(vary)]);
% %     %     disp([' desvio padrão= ', num2str(stdy)]);
% %     %     disp([' coef. variação= ', num2str(covy)]);
% %     % else
% %     %  %imprime no 'fileout'.dat para plotar os gráficos (NAO MC)  
% %     %     fprintf(arqui(ii),'%12.8g %12.8g %12.8g %12.8g %12.8g %12.8g %12.8g \n', k, y, ak, ck, sknorm, CountS, L);
% %     % end
% %     % ************************************************************************* 
% % 
% %     %--- Critérios de Parada - Erro Relativo ---    
% %     % switch  op_tp_fob
% %     %     case 1
% %     %         if op_mc == 1           
% %     %              disp([' op_restr= ', num2str(op_restr)]);
% %     %              if op_restr == 2
% %     %                  disp('case 1 - critério parada')
% %     %                  disp([' covb= ', num2str(covb)]);
% %     %                  disp([' covy= ', num2str(covy)]);
% %     %                  disp([' delta cov= ', num2str(delcov)]);
% %     %                 if (covy >= covb-delcov) &  (covy <= covb)
% %     %                     disp('BREAK')
% %     %                     break
% %     %                 end
% %     %              end
% %     %         end
% %     %     case 7 %expg9
% %     %         %reduc=(y+0.7901)/(y0+0.7901); usado p/ MC=>n existe L
% %     %         reduc=(L+0.7901)/(L0+0.7901);
% %     %         if abs (reduc) < 0.005  %criterio de parada
% %     %                 break
% %     %         end
% %     %     case 8 %Griewank  reduc=normatheta
% %     %         reduc= abs(sqrt((100^2+100^2))- sqrt(theta(1)^2+theta(2)^2));
% %     %             if reduc < 0.02 & abs(y) < 0.01  %criterio de parada
% %     %                 break
% %     %             end
% %     %     case 9 %Rosenbrock
% %     %         reduc=(L-0)/(L0-0);       
% %     %     case 10 %ST90
% %     %         reduc =(L-(-40))/(L0-(-40)); 
% %     %         toll=1E-05;
% %     %             if y -(-40.0) <= toll
% %     %                 break
% %     %             end
% %     %     otherwise
% %     %         reduc=0;
% %     % end
% %     %--------------------------------------------------------------------------
% % 
% vak(k)=ak;
% vck(k)=ck;
% vsknorm(k)=sknorm;
% %salva as saídas de cada rodada
% %     save([fileout(1:end-4) '_' num2str(ii)]); 
% %     % % % % disp(['============= nova iteração ================  k = ', num2str(k+1)])
% 
% % toc
% % 
% % %MÉDIAS E DESVIOS PADRÕES DAS REALIZAÇÕES NA ÚLTIMA ITERAÇÃO:
% % 
% % %Viga
% % MpaV = mean(hSPA_V(k,:));    DPpaV = std(hSPA_V(k,:));    %Peso de aço kg
% % MvcV = mean(hSVC_V(k,:));    DPvcV = std(hSVC_V(k,:));    %Vol. conc. m3
% % MafV = mean(hSForma_V(k,:)); DPafV = std(hSForma_V(k,:)); %Área de forma m2
% % MCVA = mean(h_CVA(k,:));     DPCVA = std(h_CVA(k,:));     %Custo aço R$
% % MCVC = mean(h_CVC(k,:));     DPCVC = std(h_CVC(k,:));     %Custo conc. R$
% % MCVF = mean(h_CVF(k,:));     DPCVF = std(h_CVF(k,:));     %Custo forma R$
% % 
% % %Laje
% % MpaL = mean(hSPA_L(k,:));    DPpaL = std(hSPA_L(k,:));    %Peso de aço kg
% % MvcL = mean(hSVC_L(k,:));    DPvcL = std(hSVC_L(k,:));    %Vol. conc. m3
% % MafL = mean(hSForma_L(k,:)); DPafL = std(hSForma_L(k,:)); %Área de forma m2
% % MCLA = mean(h_CLA(k,:));     DPCLA = std(h_CLA(k,:));     %Custo aço R$
% % MCLC = mean(h_CLC(k,:));     DPCLC = std(h_CLC(k,:));     %Custo conc. R$
% % MCLF = mean(h_CLF(k,:));     DPCLF = std(h_CLF(k,:));     %Custo forma R$
% %      
% % %Pilar
% % MpaP = mean(hSPA_P(k,:));      DPpaP = std(hSPA_P(k,:));    %Peso de aço kg
% % MvcP = mean(hSVC_P(k,:));      DPvcP = std(hSVC_P(k,:));    %Vol. conc. m3
% % MafP = mean(hSForma_P(k,:));   DPafP = std(hSForma_P(k,:)); %Área de forma m2
% % MCPA = mean(h_CPA(k,:));       DPCPA = std(h_CPA(k,:));     %Custo aço R$
% % MCPC = mean(h_CPC(k,:));       DPCPC = std(h_CPC(k,:));     %Custo conc. R$
% % MCPF = mean(h_CPF(k,:));       DPCPF = std(h_CPF(k,:));     %Custo forma R$
% % 
% % %Estrutura
% % MpaEST = MpaV + MpaL + MpaP;    
% % MvcEST = MvcV + MvcL + MvcP;
% % MafEST = MafV + MafL + MafP;
% % 
% % %Função objetivo
% % DPfo = std(hf_mc(k,:));
% % 
% % disp('-------------------------------------------------------------------')
% % %APÓS TODAS AS ITERAÇÕES:
% % disp('RESULTADOS APÓS A ÚLTIMA ITERAÇÃO DO ALGORITMO SPSA-B')
% % Xfim=X(k,:)';
% % disp(['Variáveis de projeto:    X = ',num2str(Xfim')])
% % 
% % disp('Os valores abaixo são as médias das realizações na última iteração.')
% % 
% % disp('VIGA')
% % disp(['Peso de aço (kg)       = ',num2str(MpaV),'      Desvio padrão = ',num2str(DPpaV)])
% % disp(['Volume de concreto (m3)= ',num2str(MvcV),'      Desvio padrão = ',num2str(DPvcV)])
% % disp(['Área de forma (m2)     = ',num2str(MafV),'      Desvio padrão = ',num2str(DPafV)])
% % disp(['Custo do peso de aço (R$) = ',num2str(MCVA),'      Desvio padrão = ',num2str(DPCVA)])
% % disp(['Custo do vol. de conc. (R$) = ',num2str(MCVC),'    Desvio padrão = ',num2str(DPCVC)])
% % disp(['Custo da área de forma (R$) = ',num2str(MCVF),'    Desvio padrão = ',num2str(DPCVF)])
% % 
% % disp('LAJE')
% % disp(['Peso de aço (kg)       = ',num2str(MpaL),'      Desvio padrão = ',num2str(DPpaL)])
% % disp(['Volume de concreto (m3)= ',num2str(MvcL),'      Desvio padrão = ',num2str(DPvcL)])
% % disp(['Área de forma (m2)     = ',num2str(MafL),'      Desvio padrão = ',num2str(DPafL)])
% % disp(['Custo do peso de aço (R$) = ',num2str(MCLA),'      Desvio padrão = ',num2str(DPCLA)])
% % disp(['Custo do vol. de conc. (R$) = ',num2str(MCLC),'    Desvio padrão = ',num2str(DPCLC)])
% % disp(['Custo da área de forma (R$) = ',num2str(MCLF),'    Desvio padrão = ',num2str(DPCLF)])
% % 
% % disp('PILAR')
% % disp(['Peso de aço (kg)       = ',num2str(MpaP),'      Desvio padrão = ',num2str(DPpaP)])
% % disp(['Volume de concreto (m3)= ',num2str(MvcP),'      Desvio padrão = ',num2str(DPvcP)])
% % disp(['Área de forma (m2)     = ',num2str(MafP),'      Desvio padrão = ',num2str(DPafP)])
% % disp(['Custo do peso de aço (R$) = ',num2str(MCPA),'      Desvio padrão = ',num2str(DPCPA)])
% % disp(['Custo do vol. de conc. (R$) = ',num2str(MCPC),'    Desvio padrão = ',num2str(DPCPC)])
% % disp(['Custo da área de forma (R$) = ',num2str(MCPF),'    Desvio padrão = ',num2str(DPCPF)])
% % 
% % %Estrutura
% % disp('ESTRUTURA')
% % disp(['Peso de aço (kg)       = ',num2str(MpaEST)]);
% % disp(['Volume de concreto (m3)= ',num2str(MvcEST)]);
% % disp(['Área de forma (m2)     = ',num2str(MafEST)]);
% % 
% % %Função objetivo
% % disp('FUNÇÃO OBJETIVO')
% % funcfim=y;
% % disp(['Valor da função objetivo (R$) = ',num2str(funcfim),'      Desvio padrão = ',num2str(std(hf_mc(k,:)))])
% % exitflg=1;
% 
% %fclose(arqui(ii));
% 
% %--------------------------------------------------------------------------
% %gráficos
% % if op_mc == 1   %mc
% %     figs_stat
% %     figs_hist
% % else
% %     titfig2     %nao mc
% % end
% 
% %saídas valores finais na variável tabela 
% %     if op_tp_fob ~= (1|2)
% %         if op_tp_fob == 7
% %            tabela(ii,:)=[y0 y L0 L reduc theta0 theta k];
% %         else
% %            tabela(ii,:)=[y0 y L0 L reduc theta0(1) theta0(2) theta(1) theta(2) k];
% %         end
% %     else
% %         tabela(ii,:)=[y0 y L0 L];
% %     end
% %--------------------------------------------------------------------------
% toc
% end
% 
% %save tabela
% 
% %--------------------------------------------------------------------------
% %****** Fase Captação de Mínimos para Reinicialização *******
% %Captação de mínimos  (proximo passo: colocar esse trecho em rotina
% %separada para ficar genérica e usar a técnica de reinicialização para
% %todos os algoritmos de otimização)
% % nm=0;
% % if ys(1)<=ys(2)
% %     nm=nm+1;
% %     lm(nm)=1;
% %     ys(nm)=ys(1);
% % end
% % 
% % na=5;   %máximo de reinicializações desejadas
% % nfor=size(ys);
% % 
% % for im=2:1:nfor(1)-1
% %     if ys(im)<ys(im+1)
% %         if ys(im)<ys(im-1)
% %             nm=nm+1;
% %             lm(nm)=im;
% %         end
% %     end
% % end
% % 
% % if  ys(nfor(1)) <= ys(nfor(1)-1)
% %     nm=nm+1;
% %     ys(nm)=ys(nfor(1));
% %     lm(nm)=nfor(1);
% % end
% % %matriz com valor fobjetiva, iteração e theta correpondente
% % mywor=[ys(lm,:) lm(:,:)' X(lm,:)];  %matriz sem ordem
% % mysor=sortrows(mywor,1);            %matriz ordenada por ys
% % % ys e X mínimos locais ordenados pelo menor valor de ys
% % ysor=mysor(:,1);
% % Xor=mysor(:,3:end);
% % %limite de reinicializações
% % n1=min(nm,na);      
% % Xn1=Xor(1:n1,:);
% 
% %%Chamada do algoritmo de reinicialização
% %--------------------------------------------------------------------------
% % save(fileout(1:end-4));
% 
