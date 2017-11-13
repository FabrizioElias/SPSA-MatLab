%FUNCAO QUE CALCULA AS EXCENTRICIDADES
%Nesta função, a metodologia de cálculo das excentricidades para os pilares
%central (ou intermediário), de extremidade (ou lateral) e de canto foi
%retirada do livro CURSO DE CONCRETO ARMADO José Milton Araujo VOLUME 3.

function[ex,ey]=PILAR14_A(POSPILAR,lex,ley,hx,hy,lambdax,lambday,ni0,Ns,Msx,Msy)
%lex: Comprimento de flambagem (cm)
%ley: Comprimento de flambagem (cm)
%lambdax: índice de esbeltez 
%lambday: índice de esbeltez 
%ni0: parâmetro usado no cálculo da excentricidade de segunda ordem
%NBR6118-15.8.3.3.2.: ni é a força normal adimensional

%hx: Dimensão do pilar na direção x (cm)
%hy: Dimensão do pilar na direção y (cm)
%Mx=[coluna1 coluna2]; My=[coluna1 coluna2];
%Coluna 1:momento na base do pilar; Coluna 2:momento no topo do pilar

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
   disp('lambdax é maior que 90. O pilar é esbelto')
else
   e2x=(lex^2*0.005)/(10*(ni0+0.5)*hx);
end
if lambday>90 
   disp('lambday é maior que 90. O pilar é esbelto')
else
   e2y=(ley^2*0.005)/(10*(ni0+0.5)*hy);
end

%Excentricidades finais
%Primeira situacao de cálculo
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

%Excentricidades mínimas
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
   disp('lambdax é maior que 90. O pilar é esbelto')
else
   e2xext=0; 
   e2xint=(lex^2*0.005)/(10*(ni0+0.5)*hx);
end
if lambday>90
   disp('lambday é maior que 90. O pilar é esbelto')
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
    
otherwise %-------------------------------------------------PILAR DE CANTO
%Nos vetores (excentricidades) abaixo:
%a coluna 1 é a primeira situacao de calculo e
%a coluna 2 é a segunda situacao de calculo. 
 
%Excentricidades iniciais
%Direção x
eiax=Msx(1,1)/Ns;%******A LINHA DEVE IDENTIFICAR O PILAR
eibx=Msx(1,2)/Ns;%******A LINHA DEVE IDENTIFICAR O PILAR
temporario=[abs(eiax) abs(eibx)];
eix=max(temporario);

%Direção y
eiay=Msy(1,1)/Ns;%******A LINHA DEVE IDENTIFICAR O PILAR
eiby=Msy(1,2)/Ns;%******A LINHA DEVE IDENTIFICAR O PILAR
temporario=[abs(eiay) abs(eiby)];
eiy=max(temporario);

%Excentricidades acidentais
eax=[lex/400 0];
eay=[0 ley/400];

%Excentricidades mínimas
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
disp('lambda é maior que 90. O pilar é esbelto')
else
e2x=[(lex^2*0.005)/(10*(ni0+0.5)*hx) 0];
e2y=[0 (ley^2*0.005)/(10*(ni0+0.5)*hy)];
end

%Excentricidades finais
%Vetor ex:
%Coluna 1-primeira situacao de calculo
%Coluna 2-segunda situação de cálculo
%Vetor ey:
%Coluna 1-primeira situacao de calculo
%Coluna 2-segunda situação de cálculo
ex=[e1x(1)+e2x(1) e1x(2)+e2x(2)];
ey=[e1y(1)+e2y(1) e1y(2)+e2y(2)];

end %Fim do loop switch
   
end

 







            