%FUNCAO QUE CALCULA AS EXCENTRICIDADES
%Nesta função, a metodologia de cálculo das excentricidades para os pilares
%central (ou intermediário) e de extremidade (ou lateral)foi retirada do
%livro CURSO DE CONCRETO ARMADO José Milton Araujo VOLUME 3.
%A metodologia de cálculo das excentricidades para pilares de canto foi
%adaptada da metodologia para pilares de extremidade.

function[ex,ey]=PILAR14_B(Realizacao,Npilar,POSPILAR,lex,ley,hx,hy,lambdax,lambday,ni0,Ns,Msx,Msy,eixo)
%Npilar    Número do pilar
%POSPILAR  Tipo de pilar quanto à posição em planta
%          1-Pilar central  2-Pilar de extremidade  3-Pilar de canto
%lex: Comprimento de flambagem (cm) do pilar na direção x
%ley: Comprimento de flambagem (cm) do pilar na direção y
%hx:  Dimensão do pilar na direção x (cm)
%hy:  Dimensão do pilar na direção y (cm)
%lambdax: índice de esbeltez 
%lambday: índice de esbeltez 
%ni0: parâmetro usado no cálculo da excentricidade de segunda ordem
%NBR6118-15.8.3.3.2.: ni é a força normal adimensional
%Ns         Força normal solicitante(KN).
%Msx e Msy  Momento fletor solicitante(KNcm)
%Cada linha de Mx é um pilar
%Cada linha de My é um pilar
%Coluna 1:momento na base do pilar
%Coluna 2:momento no topo do pilar
%ex e ey: excentricidades finais.

%As excentricidades estão em centímetros

switch POSPILAR
case 1 %-------------------------------------PILAR CENTRAL ou intermediário
%Excentricidades iniciais
eix=0;
eiy=0;
%Excentricidades acidentais
eax=lex/400;
eay=ley/400;
%Excentricidades minimas
e1xmin=1.5+0.03*hx; 
e1ymin=1.5+0.03*hy; 

temporario=[eix+eax e1xmin];
e1x=max(temporario); %e1x: maior valor entre (eix+eax) e e1xmin

temporario=[eiy+eay e1ymin];
e1y=max(temporario); %e1y: maior valor entre (eiy+eay) e e1ymin

%Excentricidades de segunda ordem:
if lambdax>90
   disp(['Realizacao: ',num2str(Realizacao),' - PILAR ',num2str(Npilar)])    
   disp('lambdax é maior que 90.   NBR6118 15.8.3.1 A consideração da fluência é obrigatória.')
   disp('JOSÉ Milton de Araujo, VOL.3,pg.98:O pilar é esbelto e deve ser analisado através de algum processo rigoroso')
else
   e2x=(lex^2*0.005)/(10*(ni0+0.5)*hx);
end
if lambday>90
   disp(['Realizacao: ',num2str(Realizacao),' - PILAR ',num2str(Npilar)])    
   disp('lambday é maior que 90.   NBR6118 15.8.3.1 A consideração da fluência é obrigatória.')
   disp('JOSÉ Milton de Araujo, VOL.3,pg.98:O pilar é esbelto e deve ser analisado através de algum processo rigoroso')
else
   e2y=(ley^2*0.005)/(10*(ni0+0.5)*hy);
end

%Excentricidades finais
%Primeira situacao de cálculo
ex=e1x+e2x;
%Segunda situacao de calculo
ey=e1y+e2y;

case 2 %------------------------------------PILAR DE EXTREMIDADE ou lateral
%Para os pilares de extremidade é necessário saber se ele se localiza em
%uma extremidade paralela ao eixo x ou ao eixo y.  Se a variável "eixo"=x,
%o pilar está em uma borda do pavimento paralela ao eixo x, se "eixo=y", ele está
%em uma borda do pavimento paralela ao eixo y.

if eixo=='x'%O PILAR ESTÁ EM UMA BORDA PARALELA AO EIXO x.
    %Excentricidades iniciais
    %Secao de extremidade
    eib=Msy(1,1)/Ns;%******A LINHA DEVE IDENTIFICAR O PILAR
    eia=Msy(1,2)/Ns;%******A LINHA DEVE IDENTIFICAR O PILAR
    %Cada linha de My é um pilar
    %Coluna 1:momento na base do pilar
    %Coluna 2:momento no topo do pilar
    temporario=[abs(eia) abs(eib)];
    %Escolhe-se o maior valor entre as excentricidades:
    %eia:excentricidade inicial causada pelo momento no topo do pilar
    %eib:excentricidade inicial causada pelo momento na base do pilar
    eiyext=max(temporario);
    %Secao intermediaria (direcao x)
    temporario=[abs(0.6*eia+0.4*eib) abs(0.4*eia)];
    eiyint=max(temporario);
    
    eix=0;
    
    %Excentricidades acidentais
    eax=lex/400;
    eayext=ley/400;
    eayint=ley/400;
    
    %Excentricidades mínimas
    e1xmin=1.5+0.03*hx;
    e1ymin=1.5+0.03*hy;
    
    temporario=[eiyext+eayext e1ymin];
    e1yext=max(temporario);
    
    temporario=[eiyint+eayint e1ymin];
    e1yint=max(temporario);
    
    temporario=[eix+eax e1xmin];
    e1x=max(temporario);
    
    %Excentricidades de segunda ordem
    if lambdax>90;
        disp(['Realizacao: ',num2str(Realizacao),' - PILAR ',num2str(Npilar)])    
        disp('lambdax é maior que 90.   NBR6118 15.8.3.1 A consideração da fluência é obrigatória.')
        disp('JOSÉ Milton de Araujo, VOL.3,pg.98:O pilar é esbelto e deve ser analisado através de algum processo rigoroso')
    else
        e2x=(lex^2*0.005)/(10*(ni0+0.5)*hx);
    end
    if lambday>90
        disp(['Realizacao: ',num2str(Realizacao),' - PILAR ',num2str(Npilar)])    
        disp('lambday é maior que 90.   NBR6118 15.8.3.1 A consideração da fluência é obrigatória.')
        disp('JOSÉ Milton de Araujo, VOL.3,pg.98:O pilar é esbelto e deve ser analisado através de algum processo rigoroso')
    else
        e2yext=0;
        e2yint=(ley^2*0.005)/(10*(ni0+0.5)*hy);
    end
    
    %Excentricidades finais
    %Primeira situação de calculo
    ex=e1x+e2x;
    %Segunda situação de cálculo
    %Secao de extremidade: coluna1
    %Seção intermediária: coluna 2
    temporario=[e1yext+e2yext e1yint+e2yint];
    ey=max(temporario);
    
    
else %O PILAR ESTÁ EM UMA BORDA PARALELA AO EIXO y.
    %Excentricidades iniciais
    %Secao de extremidade
    eib=Msx(1,1)/Ns;%******A LINHA DEVE IDENTIFICAR O PILAR
    eia=Msx(1,2)/Ns;%******A LINHA DEVE IDENTIFICAR O PILAR
    %Cada linha de Mx é um pilar
    %Coluna 1:momento na base do pilar
    %Coluna 2:momento no topo do pilar
    temporario=[abs(eia) abs(eib)];
    %Escolhe-se o maior valor entre as excentricidades:
    %eia:excentricidade inicial causada pelo momento no topo do pilar
    %eib:excentricidade inicial causada pelo momento na base do pilar
    eixext=max(temporario);
    %Secao intermediaria (direcao x)
    temporario=[abs(0.6*eia+0.4*eib) abs(0.4*eia)];
    eixint=max(temporario);
    
    eiy=0;
    
    %Excentricidades acidentais
    eaxext=lex/400;
    eaxint=lex/400;
    eay=ley/400;
    
    %Excentricidades mínimas
    e1xmin=1.5+0.03*hx;
    e1ymin=1.5+0.03*hy;
    
    temporario=[eixext+eaxext e1xmin];
    e1xext=max(temporario);
    
    temporario=[eixint+eaxint e1xmin];
    e1xint=max(temporario);
    
    temporario=[eiy+eay e1ymin];
    e1y=max(temporario);
    
    %Excentricidades de segunda ordem
    if lambdax>90;
        disp(['Realizacao: ',num2str(Realizacao),' - PILAR ',num2str(Npilar)])    
        disp('lambdax é maior que 90.   NBR6118 15.8.3.1 A consideração da fluência é obrigatória.')
        disp('JOSÉ Milton de Araujo, VOL.3,pg.98:O pilar é esbelto e deve ser analisado através de algum processo rigoroso')
    else
       e2xext=0;
       e2xint=(lex^2*0.005)/(10*(ni0+0.5)*hx);
    end
    if lambday>90
        disp(['Realizacao: ',num2str(Realizacao),' - PILAR ',num2str(Npilar)])    
        disp('lambday é maior que 90.   NBR6118 15.8.3.1 A consideração da fluência é obrigatória.')
        disp('JOSÉ Milton de Araujo, VOL.3,pg.98:O pilar é esbelto e deve ser analisado através de algum processo rigoroso')
    else
        e2y=(ley^2*0.005)/(10*(ni0+0.5)*hy);
    end
    
    %Excentricidades finais
    %Primeira situação de calculo
    %Secao de extremidade: coluna1
    %Seção intermediária: coluna 2
    temporario=[e1xext+e2xext e1xint+e2xint];
    ex=max(temporario);
    %Segunda situação de cálculo
    ey=e1y+e2y;
end%Fim do pilar de extremidade (ou lateral)

otherwise %-------------------------------------------------PILAR DE CANTO
 %A metodologia de cálculo das excentricidades para pilares de canto foi
%adaptada da metodologia para pilares de extremidade.

%As excentricidades iniciais nas direções x e y não serão consideradas
%iguais a 0 (como no caso de pilar lateral).

%Excentricidade inicial na direção x
%Secao de extremidade
eib=Msx(1,1)/Ns;%******A LINHA DEVE IDENTIFICAR O PILAR
eia=Msx(1,2)/Ns;%******A LINHA DEVE IDENTIFICAR O PILAR
temporario=[abs(eia) abs(eib)];
%Escolhe-se o maior valor entre as excentricidades:
 %eia:excentricidade inicial causada pelo momento no topo do pilar
 %eib:excentricidade inicial causada pelo momento na base do pilar
eixext=max(temporario);
%Secao intermediaria (direcao x)
temporario=[abs(0.6*eia+0.4*eib) abs(0.4*eia)];
eixint=max(temporario);

%Excentricidade inicial na direção y
%Secao de extremidade
eib=Msy(1,1)/Ns;%******A LINHA DEVE IDENTIFICAR O PILAR
eia=Msy(1,2)/Ns;%******A LINHA DEVE IDENTIFICAR O PILAR
temporario=[abs(eia) abs(eib)];
%Escolhe-se o maior valor entre as excentricidades:
 %eia:excentricidade inicial causada pelo momento no topo do pilar
 %eib:excentricidade inicial causada pelo momento na base do pilar
eiyext=max(temporario);
%Secao intermediaria (direcao y)
temporario=[abs(0.6*eia+0.4*eib) abs(0.4*eia)];
eiyint=max(temporario);

%Excentricidades acidentais
eax=lex/400;
eay=ley/400;

%Excentricidades mínimas
e1xmin=1.5+0.03*hx;
e1ymin=1.5+0.03*hy;

%Como neste caso as excentricidades iniciais nas direções x e y fooram
%considereadas em duas seções, as excentricidades mínimas também devem ser
%comparada em duas seções.
%Direção x:
temporario=[eixext+eax e1xmin];
e1xext=max(temporario);

temporario=[eixint+eax e1xmin];
e1xint=max(temporario);

temporario=[eiyext+eay e1ymin];
e1yext=max(temporario);

temporario=[eiyint+eay e1ymin];
e1yint=max(temporario);

%Excentricidades de segunda ordem
if lambdax>90;
   disp(['Realizacao: ',num2str(Realizacao),' - PILAR ',num2str(Npilar)])    
   disp('lambdax é maior que 90.   NBR6118 15.8.3.1 A consideração da fluência é obrigatória.')
   disp('JOSÉ Milton de Araujo, VOL.3,pg.98:O pilar é esbelto e deve ser analisado através de algum processo rigoroso')
else
   e2xext=0; 
   e2xint=(lex^2*0.005)/(10*(ni0+0.5)*hx);
end
if lambday>90
   disp(['Realizacao: ',num2str(Realizacao),' - PILAR ',num2str(Npilar)])    
   disp('lambday é maior que 90.   NBR6118 15.8.3.1 A consideração da fluência é obrigatória.')
   disp('JOSÉ Milton de Araujo, VOL.3,pg.98:O pilar é esbelto e deve ser analisado através de algum processo rigoroso')
else
   e2yext=0; 
   e2yint=(ley^2*0.005)/(10*(ni0+0.5)*hy);
end

%Excentricidades finais
%Como a direção y está sendo calculada da mesma forma que a direção x,
%então deve-se verificar duas seções:
%Primeira situação de calculo
%Secao de extremidade: coluna1
%Seção intermediária: coluna 2
temporario=[e1xext+e2xext e1xint+e2xint];
ex=max(temporario);

%Segunda situação de cálculo
%Secao de extremidade: coluna1
%Seção intermediária: coluna 2
temporario=[e1yext+e2yext e1yint+e2yint];
ey=max(temporario);


end %Fim do loop switch

end


 
%--------------------------------------------------------------------------
% % % otherwise %--------------------------------------------------PILAR DE CANTO
% % % %A metodologia de cálculo das excentricidades para pilares de canto foi
% % % %adaptada da metodologia para pilares de extremidade.
% % % %O pilar de canto é calculado duas vezes.Na primeira vez ele é considerado
% % % %um pilar lateral com 'eixo=x'. Calcula-se As1.
% % % %Na segunda vez ele é considerado um pilar lateral com 'eixo=y'. Calcula-se
% % % %As2. Ao final, As=As1+As2.
% % %     
% % % if eixo=='x'%O PILAR ESTÁ EM UMA BORDA PARALELA AO EIXO x.
% % %     %Excentricidades iniciais
% % %     %Secao de extremidade
% % %     eib=Msy(1,1)/Ns;%******A LINHA DEVE IDENTIFICAR O PILAR
% % %     eia=Msy(1,2)/Ns;%******A LINHA DEVE IDENTIFICAR O PILAR
% % %     %Cada linha de My é um pilar
% % %     %Coluna 1:momento na base do pilar
% % %     %Coluna 2:momento no topo do pilar
% % %     temporario=[abs(eia) abs(eib)];
% % %     %Escolhe-se o maior valor entre as excentricidades:
% % %     %eia:excentricidade inicial causada pelo momento no topo do pilar
% % %     %eib:excentricidade inicial causada pelo momento na base do pilar
% % %     eiyext=max(temporario);
% % %     %Secao intermediaria (direcao x)
% % %     temporario=[abs(0.6*eia+0.4*eib) abs(0.4*eia)];
% % %     eiyint=max(temporario);
% % %     
% % %     eix=0;
% % %     
% % %     %Excentricidades acidentais
% % %     eax=lex/400;
% % %     eayext=ley/400;
% % %     eayint=ley/400;
% % %     
% % %     %Excentricidades mínimas
% % %     e1xmin=1.5+0.03*hx;
% % %     e1ymin=1.5+0.03*hy;
% % %     
% % %     temporario=[eiyext+eayext e1ymin];
% % %     e1yext=max(temporario);
% % %     
% % %     temporario=[eiyint+eayint e1ymin];
% % %     e1yint=max(temporario);
% % %     
% % %     temporario=[eix+eax e1xmin];
% % %     e1x=max(temporario);
% % %     
% % %     %Excentricidades de segunda ordem
% % %     if lambdax>90;
% % %         disp('lambdax é maior que 90.   NBR6118 15.8.3.1 A consideração da fluência é obrigatória.')
% % %         disp('JOSÉ Milton de Araujo, VOL.3,pg.98:O pilar é esbelto e deve ser analisado através de algum processo rigoroso')
% % %     else
% % %         e2x=(lex^2*0.005)/(10*(ni0+0.5)*hx);
% % %     end
% % %     if lambday>90
% % %         disp('lambday é maior que 90.   NBR6118 15.8.3.1 A consideração da fluência é obrigatória.')
% % %         disp('JOSÉ Milton de Araujo, VOL.3,pg.98:O pilar é esbelto e deve ser analisado através de algum processo rigoroso')
% % %     else
% % %         e2yext=0;
% % %         e2yint=(ley^2*0.005)/(10*(ni0+0.5)*hy);
% % %     end
% % %     
% % %     %Excentricidades finais
% % %     %Primeira situação de calculo
% % %     ex=e1x+e2x;
% % %     %Segunda situação de cálculo
% % %     %Secao de extremidade: coluna1
% % %     %Seção intermediária: coluna 2
% % %     temporario=[e1yext+e2yext e1yint+e2yint];
% % %     ey=max(temporario);
% % %     
% % %     
% % % else %O PILAR ESTÁ EM UMA BORDA PARALELA AO EIXO y.
% % %     %Excentricidades iniciais
% % %     %Secao de extremidade
% % %     eib=Msx(1,1)/Ns;%******A LINHA DEVE IDENTIFICAR O PILAR
% % %     eia=Msx(1,2)/Ns;%******A LINHA DEVE IDENTIFICAR O PILAR
% % %     %Cada linha de Mx é um pilar
% % %     %Coluna 1:momento na base do pilar
% % %     %Coluna 2:momento no topo do pilar
% % %     temporario=[abs(eia) abs(eib)];
% % %     %Escolhe-se o maior valor entre as excentricidades:
% % %     %eia:excentricidade inicial causada pelo momento no topo do pilar
% % %     %eib:excentricidade inicial causada pelo momento na base do pilar
% % %     eixext=max(temporario);
% % %     %Secao intermediaria (direcao x)
% % %     temporario=[abs(0.6*eia+0.4*eib) abs(0.4*eia)];
% % %     eixint=max(temporario);
% % %     
% % %     eiy=0;
% % %     
% % %     %Excentricidades acidentais
% % %     eaxext=lex/400;
% % %     eaxint=lex/400;
% % %     eay=ley/400;
% % %     
% % %     %Excentricidades mínimas
% % %     e1xmin=1.5+0.03*hx;
% % %     e1ymin=1.5+0.03*hy;
% % %     
% % %     temporario=[eixext+eaxext e1xmin];
% % %     e1xext=max(temporario);
% % %     
% % %     temporario=[eixint+eaxint e1xmin];
% % %     e1xint=max(temporario);
% % %     
% % %     temporario=[eiy+eay e1ymin];
% % %     e1y=max(temporario);
% % %     
% % %     %Excentricidades de segunda ordem
% % %     if lambdax>90;
% % %         disp('lambdax é maior que 90.   NBR6118 15.8.3.1 A consideração da fluência é obrigatória.')
% % %         disp('JOSÉ Milton de Araujo, VOL.3,pg.98:O pilar é esbelto e deve ser analisado através de algum processo rigoroso')
% % %     else
% % %        e2xext=0;
% % %        e2xint=(lex^2*0.005)/(10*(ni0+0.5)*hx);
% % %     end
% % %     if lambday>90
% % %         disp('lambday é maior que 90.   NBR6118 15.8.3.1 A consideração da fluência é obrigatória.')
% % %         disp('JOSÉ Milton de Araujo, VOL.3,pg.98:O pilar é esbelto e deve ser analisado através de algum processo rigoroso')
% % %     else
% % %         e2y=(ley^2*0.005)/(10*(ni0+0.5)*hy);
% % %     end
% % %     
% % %     %Excentricidades finais
% % %     %Primeira situação de calculo
% % %     %Secao de extremidade: coluna1
% % %     %Seção intermediária: coluna 2
% % %     temporario=[e1xext+e2xext e1xint+e2xint];
% % %     ex=max(temporario);
% % %     %Segunda situação de cálculo
% % %     ey=e1y+e2y;
% % % end%Fim do pilar de canto
      





            