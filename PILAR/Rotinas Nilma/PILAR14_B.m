%FUNCAO QUE CALCULA AS EXCENTRICIDADES
%Nesta fun��o, a metodologia de c�lculo das excentricidades para os pilares
%central (ou intermedi�rio) e de extremidade (ou lateral)foi retirada do
%livro CURSO DE CONCRETO ARMADO Jos� Milton Araujo VOLUME 3.
%A metodologia de c�lculo das excentricidades para pilares de canto foi
%adaptada da metodologia para pilares de extremidade.

function[ex,ey]=PILAR14_B(Realizacao,Npilar,POSPILAR,lex,ley,hx,hy,lambdax,lambday,ni0,Ns,Msx,Msy,eixo)
%Npilar    N�mero do pilar
%POSPILAR  Tipo de pilar quanto � posi��o em planta
%          1-Pilar central  2-Pilar de extremidade  3-Pilar de canto
%lex: Comprimento de flambagem (cm) do pilar na dire��o x
%ley: Comprimento de flambagem (cm) do pilar na dire��o y
%hx:  Dimens�o do pilar na dire��o x (cm)
%hy:  Dimens�o do pilar na dire��o y (cm)
%lambdax: �ndice de esbeltez 
%lambday: �ndice de esbeltez 
%ni0: par�metro usado no c�lculo da excentricidade de segunda ordem
%NBR6118-15.8.3.3.2.: ni � a for�a normal adimensional
%Ns         For�a normal solicitante(KN).
%Msx e Msy  Momento fletor solicitante(KNcm)
%Cada linha de Mx � um pilar
%Cada linha de My � um pilar
%Coluna 1:momento na base do pilar
%Coluna 2:momento no topo do pilar
%ex e ey: excentricidades finais.

%As excentricidades est�o em cent�metros

switch POSPILAR
case 1 %-------------------------------------PILAR CENTRAL ou intermedi�rio
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
   disp('lambdax � maior que 90.   NBR6118 15.8.3.1 A considera��o da flu�ncia � obrigat�ria.')
   disp('JOS� Milton de Araujo, VOL.3,pg.98:O pilar � esbelto e deve ser analisado atrav�s de algum processo rigoroso')
else
   e2x=(lex^2*0.005)/(10*(ni0+0.5)*hx);
end
if lambday>90
   disp(['Realizacao: ',num2str(Realizacao),' - PILAR ',num2str(Npilar)])    
   disp('lambday � maior que 90.   NBR6118 15.8.3.1 A considera��o da flu�ncia � obrigat�ria.')
   disp('JOS� Milton de Araujo, VOL.3,pg.98:O pilar � esbelto e deve ser analisado atrav�s de algum processo rigoroso')
else
   e2y=(ley^2*0.005)/(10*(ni0+0.5)*hy);
end

%Excentricidades finais
%Primeira situacao de c�lculo
ex=e1x+e2x;
%Segunda situacao de calculo
ey=e1y+e2y;

case 2 %------------------------------------PILAR DE EXTREMIDADE ou lateral
%Para os pilares de extremidade � necess�rio saber se ele se localiza em
%uma extremidade paralela ao eixo x ou ao eixo y.  Se a vari�vel "eixo"=x,
%o pilar est� em uma borda do pavimento paralela ao eixo x, se "eixo=y", ele est�
%em uma borda do pavimento paralela ao eixo y.

if eixo=='x'%O PILAR EST� EM UMA BORDA PARALELA AO EIXO x.
    %Excentricidades iniciais
    %Secao de extremidade
    eib=Msy(1,1)/Ns;%******A LINHA DEVE IDENTIFICAR O PILAR
    eia=Msy(1,2)/Ns;%******A LINHA DEVE IDENTIFICAR O PILAR
    %Cada linha de My � um pilar
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
    
    %Excentricidades m�nimas
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
        disp('lambdax � maior que 90.   NBR6118 15.8.3.1 A considera��o da flu�ncia � obrigat�ria.')
        disp('JOS� Milton de Araujo, VOL.3,pg.98:O pilar � esbelto e deve ser analisado atrav�s de algum processo rigoroso')
    else
        e2x=(lex^2*0.005)/(10*(ni0+0.5)*hx);
    end
    if lambday>90
        disp(['Realizacao: ',num2str(Realizacao),' - PILAR ',num2str(Npilar)])    
        disp('lambday � maior que 90.   NBR6118 15.8.3.1 A considera��o da flu�ncia � obrigat�ria.')
        disp('JOS� Milton de Araujo, VOL.3,pg.98:O pilar � esbelto e deve ser analisado atrav�s de algum processo rigoroso')
    else
        e2yext=0;
        e2yint=(ley^2*0.005)/(10*(ni0+0.5)*hy);
    end
    
    %Excentricidades finais
    %Primeira situa��o de calculo
    ex=e1x+e2x;
    %Segunda situa��o de c�lculo
    %Secao de extremidade: coluna1
    %Se��o intermedi�ria: coluna 2
    temporario=[e1yext+e2yext e1yint+e2yint];
    ey=max(temporario);
    
    
else %O PILAR EST� EM UMA BORDA PARALELA AO EIXO y.
    %Excentricidades iniciais
    %Secao de extremidade
    eib=Msx(1,1)/Ns;%******A LINHA DEVE IDENTIFICAR O PILAR
    eia=Msx(1,2)/Ns;%******A LINHA DEVE IDENTIFICAR O PILAR
    %Cada linha de Mx � um pilar
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
    
    %Excentricidades m�nimas
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
        disp('lambdax � maior que 90.   NBR6118 15.8.3.1 A considera��o da flu�ncia � obrigat�ria.')
        disp('JOS� Milton de Araujo, VOL.3,pg.98:O pilar � esbelto e deve ser analisado atrav�s de algum processo rigoroso')
    else
       e2xext=0;
       e2xint=(lex^2*0.005)/(10*(ni0+0.5)*hx);
    end
    if lambday>90
        disp(['Realizacao: ',num2str(Realizacao),' - PILAR ',num2str(Npilar)])    
        disp('lambday � maior que 90.   NBR6118 15.8.3.1 A considera��o da flu�ncia � obrigat�ria.')
        disp('JOS� Milton de Araujo, VOL.3,pg.98:O pilar � esbelto e deve ser analisado atrav�s de algum processo rigoroso')
    else
        e2y=(ley^2*0.005)/(10*(ni0+0.5)*hy);
    end
    
    %Excentricidades finais
    %Primeira situa��o de calculo
    %Secao de extremidade: coluna1
    %Se��o intermedi�ria: coluna 2
    temporario=[e1xext+e2xext e1xint+e2xint];
    ex=max(temporario);
    %Segunda situa��o de c�lculo
    ey=e1y+e2y;
end%Fim do pilar de extremidade (ou lateral)

otherwise %-------------------------------------------------PILAR DE CANTO
 %A metodologia de c�lculo das excentricidades para pilares de canto foi
%adaptada da metodologia para pilares de extremidade.

%As excentricidades iniciais nas dire��es x e y n�o ser�o consideradas
%iguais a 0 (como no caso de pilar lateral).

%Excentricidade inicial na dire��o x
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

%Excentricidade inicial na dire��o y
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

%Excentricidades m�nimas
e1xmin=1.5+0.03*hx;
e1ymin=1.5+0.03*hy;

%Como neste caso as excentricidades iniciais nas dire��es x e y fooram
%considereadas em duas se��es, as excentricidades m�nimas tamb�m devem ser
%comparada em duas se��es.
%Dire��o x:
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
   disp('lambdax � maior que 90.   NBR6118 15.8.3.1 A considera��o da flu�ncia � obrigat�ria.')
   disp('JOS� Milton de Araujo, VOL.3,pg.98:O pilar � esbelto e deve ser analisado atrav�s de algum processo rigoroso')
else
   e2xext=0; 
   e2xint=(lex^2*0.005)/(10*(ni0+0.5)*hx);
end
if lambday>90
   disp(['Realizacao: ',num2str(Realizacao),' - PILAR ',num2str(Npilar)])    
   disp('lambday � maior que 90.   NBR6118 15.8.3.1 A considera��o da flu�ncia � obrigat�ria.')
   disp('JOS� Milton de Araujo, VOL.3,pg.98:O pilar � esbelto e deve ser analisado atrav�s de algum processo rigoroso')
else
   e2yext=0; 
   e2yint=(ley^2*0.005)/(10*(ni0+0.5)*hy);
end

%Excentricidades finais
%Como a dire��o y est� sendo calculada da mesma forma que a dire��o x,
%ent�o deve-se verificar duas se��es:
%Primeira situa��o de calculo
%Secao de extremidade: coluna1
%Se��o intermedi�ria: coluna 2
temporario=[e1xext+e2xext e1xint+e2xint];
ex=max(temporario);

%Segunda situa��o de c�lculo
%Secao de extremidade: coluna1
%Se��o intermedi�ria: coluna 2
temporario=[e1yext+e2yext e1yint+e2yint];
ey=max(temporario);


end %Fim do loop switch

end


 
%--------------------------------------------------------------------------
% % % otherwise %--------------------------------------------------PILAR DE CANTO
% % % %A metodologia de c�lculo das excentricidades para pilares de canto foi
% % % %adaptada da metodologia para pilares de extremidade.
% % % %O pilar de canto � calculado duas vezes.Na primeira vez ele � considerado
% % % %um pilar lateral com 'eixo=x'. Calcula-se As1.
% % % %Na segunda vez ele � considerado um pilar lateral com 'eixo=y'. Calcula-se
% % % %As2. Ao final, As=As1+As2.
% % %     
% % % if eixo=='x'%O PILAR EST� EM UMA BORDA PARALELA AO EIXO x.
% % %     %Excentricidades iniciais
% % %     %Secao de extremidade
% % %     eib=Msy(1,1)/Ns;%******A LINHA DEVE IDENTIFICAR O PILAR
% % %     eia=Msy(1,2)/Ns;%******A LINHA DEVE IDENTIFICAR O PILAR
% % %     %Cada linha de My � um pilar
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
% % %     %Excentricidades m�nimas
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
% % %         disp('lambdax � maior que 90.   NBR6118 15.8.3.1 A considera��o da flu�ncia � obrigat�ria.')
% % %         disp('JOS� Milton de Araujo, VOL.3,pg.98:O pilar � esbelto e deve ser analisado atrav�s de algum processo rigoroso')
% % %     else
% % %         e2x=(lex^2*0.005)/(10*(ni0+0.5)*hx);
% % %     end
% % %     if lambday>90
% % %         disp('lambday � maior que 90.   NBR6118 15.8.3.1 A considera��o da flu�ncia � obrigat�ria.')
% % %         disp('JOS� Milton de Araujo, VOL.3,pg.98:O pilar � esbelto e deve ser analisado atrav�s de algum processo rigoroso')
% % %     else
% % %         e2yext=0;
% % %         e2yint=(ley^2*0.005)/(10*(ni0+0.5)*hy);
% % %     end
% % %     
% % %     %Excentricidades finais
% % %     %Primeira situa��o de calculo
% % %     ex=e1x+e2x;
% % %     %Segunda situa��o de c�lculo
% % %     %Secao de extremidade: coluna1
% % %     %Se��o intermedi�ria: coluna 2
% % %     temporario=[e1yext+e2yext e1yint+e2yint];
% % %     ey=max(temporario);
% % %     
% % %     
% % % else %O PILAR EST� EM UMA BORDA PARALELA AO EIXO y.
% % %     %Excentricidades iniciais
% % %     %Secao de extremidade
% % %     eib=Msx(1,1)/Ns;%******A LINHA DEVE IDENTIFICAR O PILAR
% % %     eia=Msx(1,2)/Ns;%******A LINHA DEVE IDENTIFICAR O PILAR
% % %     %Cada linha de Mx � um pilar
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
% % %     %Excentricidades m�nimas
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
% % %         disp('lambdax � maior que 90.   NBR6118 15.8.3.1 A considera��o da flu�ncia � obrigat�ria.')
% % %         disp('JOS� Milton de Araujo, VOL.3,pg.98:O pilar � esbelto e deve ser analisado atrav�s de algum processo rigoroso')
% % %     else
% % %        e2xext=0;
% % %        e2xint=(lex^2*0.005)/(10*(ni0+0.5)*hx);
% % %     end
% % %     if lambday>90
% % %         disp('lambday � maior que 90.   NBR6118 15.8.3.1 A considera��o da flu�ncia � obrigat�ria.')
% % %         disp('JOS� Milton de Araujo, VOL.3,pg.98:O pilar � esbelto e deve ser analisado atrav�s de algum processo rigoroso')
% % %     else
% % %         e2y=(ley^2*0.005)/(10*(ni0+0.5)*hy);
% % %     end
% % %     
% % %     %Excentricidades finais
% % %     %Primeira situa��o de calculo
% % %     %Secao de extremidade: coluna1
% % %     %Se��o intermedi�ria: coluna 2
% % %     temporario=[e1xext+e2xext e1xint+e2xint];
% % %     ex=max(temporario);
% % %     %Segunda situa��o de c�lculo
% % %     ey=e1y+e2y;
% % % end%Fim do pilar de canto
      





            