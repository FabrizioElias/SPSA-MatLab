%FUNCAO QUE CALCULA AS EXCENTRICIDADES
%Nesta fun��o, a metodologia de c�lculo das excentricidades para os pilares
%central (ou intermedi�rio), de extremidade (ou lateral) e de canto foi
%retirada do livro CURSO DE CONCRETO ARMADO Jos� Milton Araujo VOLUME 3.

function[ex,ey]=PILAR14_A(POSPILAR,lex,ley,hx,hy,lambdax,lambday,ni0,Ns,Msx,Msy)
%lex: Comprimento de flambagem (cm)
%ley: Comprimento de flambagem (cm)
%lambdax: �ndice de esbeltez 
%lambday: �ndice de esbeltez 
%ni0: par�metro usado no c�lculo da excentricidade de segunda ordem
%NBR6118-15.8.3.3.2.: ni � a for�a normal adimensional

%hx: Dimens�o do pilar na dire��o x (cm)
%hy: Dimens�o do pilar na dire��o y (cm)
%Mx=[coluna1 coluna2]; My=[coluna1 coluna2];
%Coluna 1:momento na base do pilar; Coluna 2:momento no topo do pilar

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
   disp('lambdax � maior que 90. O pilar � esbelto')
else
   e2x=(lex^2*0.005)/(10*(ni0+0.5)*hx);
end
if lambday>90 
   disp('lambday � maior que 90. O pilar � esbelto')
else
   e2y=(ley^2*0.005)/(10*(ni0+0.5)*hy);
end

%Excentricidades finais
%Primeira situacao de c�lculo
ex=e1x+e2x;
%Segunda situacao de calculo
ey=e1y+e2y;

case 2 %------------------------------------PILAR DE EXTREMIDADE ou lateral
%Excentricidades iniciais
%Secao de extremidade (direcao x)
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

eiy=0;

%Excentricidades acidentais
eax=lex/400;
eay=ley/400;

%Excentricidades m�nimas
e1xmin=1.5+0.03*hx;
e1ymin=1.5+0.03*hy;

temporario=[eixext+eax e1xmin];
e1xext=max(temporario);

temporario=[eixint+eax e1xmin];
e1xint=max(temporario);

temporario=[eiy+eay e1ymin];
e1y=max(temporario);

%Excentricidades de segunda ordem
if lambdax>90
   disp('lambdax � maior que 90. O pilar � esbelto')
else
   e2xext=0; 
   e2xint=(lex^2*0.005)/(10*(ni0+0.5)*hx);
end
if lambday>90
   disp('lambday � maior que 90. O pilar � esbelto')
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
    
otherwise %-------------------------------------------------PILAR DE CANTO
%Nos vetores (excentricidades) abaixo:
%a coluna 1 � a primeira situacao de calculo e
%a coluna 2 � a segunda situacao de calculo. 
 
%Excentricidades iniciais
%Dire��o x
eiax=Msx(1,1)/Ns;%******A LINHA DEVE IDENTIFICAR O PILAR
eibx=Msx(1,2)/Ns;%******A LINHA DEVE IDENTIFICAR O PILAR
temporario=[abs(eiax) abs(eibx)];
eix=max(temporario);

%Dire��o y
eiay=Msy(1,1)/Ns;%******A LINHA DEVE IDENTIFICAR O PILAR
eiby=Msy(1,2)/Ns;%******A LINHA DEVE IDENTIFICAR O PILAR
temporario=[abs(eiay) abs(eiby)];
eiy=max(temporario);

%Excentricidades acidentais
eax=[lex/400 0];
eay=[0 ley/400];

%Excentricidades m�nimas
e1xmin=1.5+0.03*hx;
e1ymin=1.5+0.03*hy;

temporario=[eix+eax(1) eix+eax(2)
            e1xmin e1xmin];
e1x=max(temporario);
%e1x:vetor (2x1)
temporario=[eiy+eay(1) eiy+eay(2)
            e1ymin e1ymin];
e1y=max(temporario);
%e1y:vetor (2x1)

%Excentricidades de segunda ordem
if lambdax>90 || lambday>90
disp('lambda � maior que 90. O pilar � esbelto')
else
e2x=[(lex^2*0.005)/(10*(ni0+0.5)*hx) 0];
e2y=[0 (ley^2*0.005)/(10*(ni0+0.5)*hy)];
end

%Excentricidades finais
%Vetor ex:
%Coluna 1-primeira situacao de calculo
%Coluna 2-segunda situa��o de c�lculo
%Vetor ey:
%Coluna 1-primeira situacao de calculo
%Coluna 2-segunda situa��o de c�lculo
ex=[e1x(1)+e2x(1) e1x(2)+e2x(2)];
ey=[e1y(1)+e2y(1) e1y(2)+e2y(2)];

end %Fim do loop switch
   
end

 







            