%FUN��O QUE DEFINE A ARMADURA LONGITUDINAL USADA

function[AsdP,fiLP,NB]=PILAR22(Realizacao,Npilar,As,hx,hy,cobp)
%As    �rea de a�o calculada da armadura longitudinal(cm2)
%hx    Dimens�o do pilar na dire��o x (cm)
%hy    Dimens�o do pilar na dire��o y (cm)
%cobp  Cobrimento das armaduras(cm)
%AsdP  �rea de a�o usada na armadura longitudinal do pilar (cm2)
%fiLP  Barra de a�o da armadura longitudinal do pilar (cm)
%NB    N�mero de barras da armadura longitudinal usada
%H     Maior dimens�o da se��o transversal do pilar

%NBR6118-18.4.2.1 Di�metro m�nimo e taxa de armadura
%Di�metro m�nimo (cm):10mm. Como n�o vou usar barras de 10mm, n�o preciso
%especificar o di�metro m�nimo.
%Di�metro m�ximo (cm):1/8*hx (1/8 da menor dimens�o transversal)
%Neste programa a dimens�o m�nima ser� de 20cm. Assim, o di�metro m�ximo
%pode ir at� 25mm.

%NBR6118-18.4.2.2 Distribui��o transversal
%O espa�amento m�nimo livre entre as faces das barras longitudinais,...,
%deve ser igual ou superior ao maior dos seguintes valores:
%20 mm;
%di�metro da barra;
%1,2 vez a dimens�o m�xima caracter�stica do agregado gra�do.

%Neste programa o espa�amento m�nimo livre ser� adotado como 25mm.

%O espa�amento m�ximo entre eixos das barras, ..., deve ser menor ou igual
%a duas vezes a menor dimens�o da se��o no trecho considerado, sem exceder
%400 mm.

if hx<=hy
    H=hy;
else
    H=hx;
end

%1 - VERIFICA��O DO ESPA�AMENTO M�NIMO ENTRE AS BARRAS (H<=40)
%Para valores de H menores que 40cm, � necess�rio verificar o espa�amento
%entre as barras, para que este n�o seja menor que o m�nimo admitido.

%Se H>40cm, mesmo utilizando-se 6 camadas, o espa�amento entre as barras
%� maior que o m�nimo.

%Para H<=21, se forem usadas mais que 2 camadas, o espa�amento m�nimo n�o
%ser� atendido. Neste loop, as �reas correspondem a apenas duas camadas.
if H<=21
    if As<=4.91
    fiLP=1.25;
    AsdP=4.91; %4 barras de 12.5mm
    NB=4;
    end
    if 4.91<As && As<=8.04
    fiLP=1.6;
    AsdP=8.04; %4 barras de 16mm
    NB=4;
    end
    if 8.04<As && As<=12.57
    fiLP=2;
    AsdP=12.57; %4 barras de 20mm
    NB=4;
    end
    if 12.57<As && As<=19.63
    fiLP=2.5;
    AsdP=19.63; %4 barras de 25mm
    NB=4;
    end
    if As>19.63
    disp(['Realizacao: ',num2str(Realizacao),' - PILAR ',num2str(Npilar)])       
    disp('A armadura longitudinal � maior que 19,63cm2 (4 barras de 25mm). S�o necess�rias mais que 2 camadas, mas como H<21cm, o espa�amento m�nimo entre barras n�o ser� atendido.')
    end
end

%Para 21<H<=26, se forem usadas mais que 3 camadas, o espa�amento m�nimo n�o
%ser� atendido. Neste loop, as �reas correspondem a 2 e 3 camadas.
if 21<H && H<=26
    if As<=4.91
    fiLP=1.25;
    AsdP=4.91; %4 barras de 12,5mm
    NB=4;
    end
    if 4.91<As && As<=7.36
    AsdP=7.36; %6 barras de 12,5mm
    fiLP=1.25;
    NB=6;
    end
    if 7.36<As && As<=8.04
    AsdP=8.04; %4 barras de 16mm
    fiLP=1.6;
    NB=4;
    end
    if 8.04<As && As<=12.06
    AsdP=12.06; %6 barras de 16mm
    fiLP=1.6;
    NB=6;
    end
    if 12.06<As && As<=12.57
    AsdP=12.57; %4 barras de 20mm
    fiLP=2;
    NB=4;
    end
    if 12.57<As && As<=18.85
    AsdP=18.85; %6 barras de 20mm
    fiLP=2;
    NB=6;
    end
    if 18.85<As && As<=19.63
    AsdP=19.63; %4 barras de 25mm
    fiLP=2.5;
    NB=4;
    end
    if 19.63<As && As<=29.45
    AsdP=29.45; %6 barras de 25mm
    fiLP=2.5;
    NB=6;
    end
    if As>29.45
    disp(['Realizacao: ',num2str(Realizacao),' - PILAR ',num2str(Npilar)])       
    disp('A armadura longitudinal � maior que 29.45cm2 (6 barras de 25mm). S�o necess�rias mais que 3 camadas, mas como H<26cm, o espa�amento m�nimo entre barras n�o ser� atendido')
    end
end

%Para 26<H<=30, se forem usadas mais que 4 camadas, o espa�amento m�nimo n�o
%ser� atendido. Neste loop, as �reas correspondem a 2,3 e 4 camadas.
if 26<H && H<=30
    if As<=4.91
    AsdP=4.91; %4 barras de 12,5mm
    fiLP=1.25;
    NB=4;
    end
    if 4.91<As && As<=7.36
    AsdP=7.36; %6 barras de 12,5mm
    fiLP=1.25;
    NB=6;
    end
    if 7.36<As && As<=8.04
    AsdP=8.04; %4 barras de 16mm
    fiLP=1.6;
    NB=4;
    end
    if 8.04<As && As<=9.82
    AsdP=9.82; %8 barras de 12,5mm
    fiLP=1.25;
    NB=8;
    end
    if 9.82<As && As<=12.06
    AsdP=12.06; %6 barras de 16mm
    fiLP=1.6;
    NB=6;
    end
    if 12.06<As && As<=12.57
    AsdP=12.57; %4 barras de 20mm
    fiLP=2;
    NB=4;
    end
    if 12.57<As && As<=16.08
    AsdP=16.08; %8 barras de 16mm
    fiLP=1.6;
    NB=8;
    end
    if 16.08<As && As<=18.85
    AsdP=18.85; %6 barras de 20mm
    fiLP=2;
    NB=6;
    end
    if 18.85<As && As<=19.63
    AsdP=19.63; %4 barras de 25mm
    fiLP=2.5;
    NB=4;
    end
    if 19.63<As && As<=25.13
    AsdP=25.13; %8 barras de 20mm
    fiLP=2;
    NB=8;
    end
    if 25.13<As && As<=29.45
    AsdP=29.45; %6 barras de 25mm
    fiLP=2.5;
    NB=6;
    end
    if 29.45<As && As<=39.27
    AsdP=39.27; %8 barras de 25mm
    fiLP=2.5;
    NB=8;
    end
    if As>39.27
    disp(['Realizacao: ',num2str(Realizacao),' - PILAR ',num2str(Npilar)])       
    disp('A armadura longitudinal � maior que 39.27cm2 (8 barras de 25mm). S�o necess�rias mais que 4 camadas, mas como H<30cm, o espa�amento m�nimo entre barras n�o ser� atendido')
    end
end

%Para 30<H<=40, se forem usadas mais que 5 camadas, o espa�amento m�nimo n�o
%ser� atendido. Neste loop, as �reas correspondem a 2,3,4 e 5 camadas.
if 30<H && H<=40
    if As<=4.91
    AsdP=4.91; %4 barras de 12,5mm
    fiLP=1.25;
    NB=4;
    end
    if 4.91<As && As<=7.36
    AsdP=7.36; %6 barras de 12,5mm
    fiLP=1.25;
    NB=6;
    end
    if 7.36<As && As<=8.04
    AsdP=8.04; %4 barras de 16mm
    fiLP=1.6;
    NB=4;
    end
    if 8.04<As && As<=9.82
    AsdP=9.82; %8 barras de 12,5mm
    fiLP=1.25;
    NB=8;
    end
    if 9.82<As && As<=12.06
    AsdP=12.06; %6 barras de 16mm
    fiLP=1.6;
    NB=6;
    end
    if 12.06<As && As<=12.27
    AsdP=12.27; %10 barras de 12,5mm
    fiLP=1.25;
    NB=10;
    end
    if 12.27<As && As<=12.57
    AsdP=12.57; %4 barras de 20mm
    fiLP=2;
    NB=4;
    end
    if 12.57<As && As<=16.08
    AsdP=16.08; %8 barras de 16mm
    fiLP=1.6;
    NB=8;
    end
    if 16.08<As && As<=18.85
    AsdP=18.85; %6 barras de 20mm
    fiLP=2;
    NB=6;
    end
    if 18.85<As && As<=19.63
    AsdP=19.63; %4 barras de 25mm
    fiLP=2.5;
    NB=4;
    end
    if 19.63<As && As<=20.11
    AsdP=20.11; %10 barras de 16mm
    fiLP=1.6;
    NB=10;
    end
    if 20.11<As && As<=25.13
    AsdP=25.13; %8 barras de 20mm
    fiLP=2;
    NB=8;
    end
    if 25.13<As && As<=29.45
    AsdP=29.45; %6 barras de 25mm
    fiLP=2.5;
    NB=6;
    end
    if 29.45<As && As<=31.42
    AsdP=31.42; %10 barras de 20mm
    fiLP=2;
    NB=10;
    end
    if 31.42<As && As<=39.27
    AsdP=39.27; %8 barras de 25mm
    fiLP=2.5;
    NB=8;
    end
    if 39.27<As && As<=49.09
    AsdP=49.09; %10 barras de 25mm
    fiLP=2.5;
    NB=10;
    end
    if As>49.09
    disp(['Realizacao: ',num2str(Realizacao),' - PILAR ',num2str(Npilar)])       
    disp('A armadura longitudinal � maior que 49.09cm2 (10 barras de 25mm). S�o necess�rias mais que 5 camadas, mas como H40<cm, o espa�amento m�nimo entre barras n�o ser� atendido')
    end
end

%2 - VERIFICA��O DO ESPA�AMENTO M�XIMO ENTRE AS BARRAS (H>40)
%Para valores de H maiores que 40cm, � necess�rio verificar o espa�amento
%entre as barras, para que este n�o seja maior que o m�ximo admitido.

%Se H<40cm, mesmo utilizando-se apenas 2 camadas, o espa�amento entre as
%barras � menor que o m�ximo.

if H>40
    %Para (H-2*cobp)<=40, mesmo usando-se apenas 2 camadas, o espa�amento
    %n�o ser� maior que o m�ximo permitido, e mesmo utilizando-se 6
    %camadas, o espa�amento n�o ser� menor que o m�nimo permitido.
    %No loop a seguir, as �reas correspondem a 2,3,4, 5 e 6 camadas.
    if (H-2*cobp)<=40
        if As<=4.91
            AsdP=4.91; %4 barras de 12.5mm
            fiLP=1.25;
            NB=4;
        end
        if 4.91<As && As<=7.36
            AsdP=7.36; %6 barras de 12.5mm
            fiLP=1.25;
            NB=6;
        end
        if 7.36<As && As<=8.04
            AsdP=8.04; %4 barras de 16mm
            fiLP=1.6;
            NB=4;
        end
        if 8.04<As && As<=9.82
            AsdP=9.82; %8 barras de 12.5mm
            fiLP=1.25;
            NB=8;
        end
        if 9.82<As && As<=12.06
            AsdP=12.06; %6 barras de 16mm
            fiLP=1.6;
            NB=6;
        end
        if 12.06<As && As<=12.27
            AsdP=12.27; %10 barras de 12.5mm
            fiLP=1.25;
            NB=10;
        end
        if 12.27<As && As<=12.57
            AsdP=12.57; %4 barras de 20mm
            fiLP=2;
            NB=4;
        end
        if 12.57<As && As<=14.73
            AsdP=14.73; %12 barras de 12.5mm
            fiLP=1.25;
            NB=12;
        end
        if 14.73<As && As<=16.08
            AsdP=16.08; %8 barras de 16mm
            fiLP=1.6;
            NB=8;
        end
        if 16.08<As && As<=18.85
            AsdP=18.85; %6 barras de 20mm
            fiLP=2;
            NB=6;
        end
        if 18.85<As && As<=19.63
            AsdP=19.63; %4 barras de 25mm
            fiLP=2.5;
            NB=4;
        end
        if 19.63<As && As<=20.11
            AsdP=20.11; %10 barras de 16mm
            fiLP=1.6;
            NB=10;
        end
        if 20.11<As && As<=24.13
            AsdP=24.13; %12 barras de 16mm
            fiLP=1.6;
            NB=12;
        end
        if 24.13<As && As<=25.13
            AsdP=25.13; %8 barras de 20mm
            fiLP=2;
            NB=8;
        end
        if 25.13<As && As<=29.45
            AsdP=29.45; %6 barras de 25mm
            fiLP=2.5;
            NB=6;
        end
        if 29.45<As && As<=31.42
            AsdP=31.42; %10 barras de 20mm
            fiLP=2;
            NB=10;
        end
        if 31.42<As && As<=37.7
            AsdP=37.7; %12 barras de 20mm
            fiLP=2;
            NB=12;
        end
        if 37.7<As && As<=39.27
            AsdP=39.27; %8 barras de 25mm
            fiLP=2.5;
            NB=8;
        end
        if 39.27<As && As<=49.09
            AsdP=49.09; %10 barras de 25mm
            fiLP=2.5;
            NB=10;
        end
        if 49.09<As && As<=58.90
            AsdP=58.90; %12 barras de 25mm
            fiLP=2.5;
            NB=12;
        end
        if 58.90<As
        disp(['Realizacao: ',num2str(Realizacao),' - PILAR ',num2str(Npilar)])       
        disp('A armadura longitudinal � maior que 58.90cm2 (12 barras de 25mm). ')
        end
    end %Fim do loop: if (H-2*cobp)<=40
 
    %Para (H-2*cobp)>40 , usando-se apenas 2 camadas, o espa�amento ser�
    %maior que o m�ximo permitido.
    %No loop a seguir, as �reas correspondem a 3,4, 5 e 6 camadas.
    if 40<(H-2*cobp) && (H-2*cobp)/2<=40
        if As<=7.36
            AsdP=7.36; %6 barras de 12.5mm
            fiLP=1.25;
            NB=6;
        end
        if 7.36<As && As<=9.82
            AsdP=9.82; %8 barras de 12.5mm
            fiLP=1.25;
            NB=8;
        end
        if 9.82<As && As<=12.06
            AsdP=12.06; %6 barras de 16mm
            fiLP=1.6;
            NB=6;
        end
        if 12.06<As && As<=12.27
            AsdP=12.27; %10 barras de 12.5mm
            fiLP=1.25;
            NB=10;
        end
        if 12.27<As && As<=14.73
            AsdP=14.73; %12 barras de 12.5mm
            fiLP=1.25;
            NB=12;
        end
        if 14.73<As && As<=16.08
            AsdP=16.08; %8 barras de 16mm
            fiLP=1.6;
            NB=8;
        end
        if 16.08<As && As<=18.85
            AsdP=18.85; %6 barras de 20mm
            fiLP=2;
            NB=6;
        end
        if 18.85<As && As<=20.11
            AsdP=20.11; %10 barras de 16mm
            fiLP=1.6;
            NB=10;
        end
        if 20.11<As && As<=24.13
            AsdP=24.13; %12 barras de 16mm
            fiLP=1.6;
            NB=12;
        end
        if 24.13<As && As<=25.13
            AsdP=25.13; %8 barras de 20mm
            fiLP=2;
            NB=8;
        end
        if 25.13<As && As<=29.45
            AsdP=29.45; %6 barras de 25mm
            fiLP=2.5;
            NB=6;
        end
        if 29.45<As && As<=31.42
            AsdP=31.42; %10 barras de 20mm
            fiLP=2;
            NB=10;
        end
        if 31.42<As && As<=37.7
            AsdP=37.7; %12 barras de 20mm
            fiLP=2;
            NB=12;
        end
        if 37.7<As && As<=39.27
            AsdP=39.27; %8 barras de 25mm
            fiLP=2.5;
            NB=8;
        end
        if 39.27<As && As<=49.09
            AsdP=49.09; %10 barras de 25mm
            fiLP=2.5;
            NB=10;
        end
        if 49.09<As && As<=58.90
            AsdP=58.90; %12 barras de 25mm
            fiLP=2.5;
            NB=12;
        end
        if 58.90<As
            disp(['Realizacao: ',num2str(Realizacao),' - PILAR ',num2str(Npilar)])       
            disp('A armadura longitudinal � maior que 58.90cm2 (12 barras de 25mm). ')
        end
    end %Fim do loop 40<(H-2*cobp) && (H-2*cobp)/2<=40
    
    %Para (H-2*cobp)/2>40 , usando-se apenas 2 ou 3 camadas, o espa�amento ser�
    %maior que o m�ximo permitido.
    %No loop a seguir, as �reas correspondem a 4, 5 e 6 camadas.
     if 40<(H-2*cobp)/2 && (H-2*cobp)/3<=40
        if As<=9.82
            AsdP=9.82; %8 barras de 12.5mm
            fiLP=1.25;
            NB=8;
        end
        if 9.82<As && As<=12.27
            AsdP=12.27; %10 barras de 12.5mm
            fiLP=1.25;
            NB=10;
        end
        if 12.27<As && As<=14.73
            AsdP=14.73; %12 barras de 12.5mm
            fiLP=1.25;
            NB=12;
        end
        if 14.73<As && As<=16.08
            AsdP=16.08; %8 barras de 16mm
            fiLP=1.6;
            NB=8;
        end
        if 16.08<As && As<=20.11
            AsdP=20.11; %10 barras de 16mm
            fiLP=1.6;
            NB=10;
        end
        if 20.11<As && As<=24.13
            AsdP=24.13; %12 barras de 16mm
            fiLP=1.6;
            NB=12;
        end
        if 24.13<As && As<=25.13
            AsdP=25.13; %8 barras de 20mm
            fiLP=2;
            NB=8;
        end
        if 25.13<As && As<=31.42
            AsdP=31.42; %10 barras de 20mm
            fiLP=2;
            NB=10;
        end
        if 31.42<As && As<=37.7
            AsdP=37.7; %12 barras de 20mm
            fiLP=2;
            NB=12;
        end
        if 37.7<As && As<=39.27
            AsdP=39.27; %8 barras de 25mm
            fiLP=2.5;
            NB=8;
        end
        if 39.27<As && As<=49.09
            AsdP=49.09; %10 barras de 25mm
            fiLP=2.5;
            NB=10;
        end
        if 49.09<As && As<=58.90
            AsdP=58.90; %12 barras de 25mm
            fiLP=2.5;
            NB=12;
        end
        if 58.90<As
            disp(['Realizacao: ',num2str(Realizacao),' - PILAR ',num2str(Npilar)])       
            disp('A armadura longitudinal � maior que 58.90cm2 (12 barras de 25mm). ')
        end
     end %Fim do loop 40<(H-2*cobp)/2 && (H-2*cobp)/3<=40 
     
    %Para (H-2*cobp)/3>40 , usando-se apenas 2, 3 ou 4 camadas, o espa�amento ser�
    %maior que o m�ximo permitido.
    %No loop a seguir, as �reas correspondem a 5 e 6 camadas.
     if 40<(H-2*cobp)/3 && (H-2*cobp)/4<=40
        if As<=12.27
            AsdP=12.27; %10 barras de 12.5mm
            fiLP=1.25;
            NB=10;
        end
        if 12.27<As && As<=14.73
            AsdP=14.73; %12 barras de 12.5mm
            fiLP=1.25;
            NB=12;
        end
        if 14.73<As && As<=20.11
            AsdP=20.11; %10 barras de 16mm
            fiLP=1.6;
            NB=10;
        end
        if 20.11<As && As<=24.13
            AsdP=24.13; %12 barras de 16mm
            fiLP=1.6;
            NB=12;
        end
        if 24.13<As && As<=31.42
            AsdP=31.42; %10 barras de 20mm
            fiLP=2;
            NB=10;
        end
        if 31.42<As && As<=37.7
            AsdP=37.7; %12 barras de 20mm
            fiLP=2;
            NB=12;
        end
        if 37.7<As && As<=49.09
            AsdP=49.09; %10 barras de 25mm
            fiLP=2.5;
            NB=10;
        end
        if 49.09<As && As<=58.90
            AsdP=58.90; %12 barras de 25mm
            fiLP=2.5;
            NB=12;
        end
        if 58.90<As
            disp(['Realizacao: ',num2str(Realizacao),' - PILAR ',num2str(Npilar)])       
            disp('A armadura longitudinal � maior que 58.90cm2 (12 barras de 25mm). ')
        end
     end %Fim do loop 40<(H-2*cobp)/3 && (H-2*cobp)/4<=40 
     
    %Para (H-2*cobp)/4>40 , usando-se apenas 2, 3, 4 ou 5 camadas, o espa�amento ser�
    %maior que o m�ximo permitido.
    %No loop a seguir, as �reas correspondem a 6 camadas.
     if 40<(H-2*cobp)/4 && (H-2*cobp)/5<=40
        if As<=14.73
            AsdP=14.73; %12 barras de 12.5mm
            fiLP=1.25;
            NB=12;
        end
        if 14.73<As && As<=24.13
            AsdP=24.13; %12 barras de 16mm
            fiLP=1.6;
            NB=12;
        end
        if 24.13<As && As<=37.7
            AsdP=37.7; %12 barras de 20mm
            fiLP=2;
            NB=12;
        end
        if 37.7<As && As<=58.90
            AsdP=58.90; %12 barras de 25mm
            fiLP=2.5;
            NB=12;
        end
        if 58.90<As
            disp(['Realizacao: ',num2str(Realizacao),' - PILAR ',num2str(Npilar)])       
            disp('A armadura longitudinal � maior que 58.90cm2 (12 barras de 25mm). ')
        end
     end %Fim do loop 40<(H-2*cobp)/4 && (H-2*cobp)/5<=40
    
end %Fim do loop: if H>40 
   
end %Fim da fun��o
    
%**************************************************************************
%ABAIXO, O ARRANJO DAS BARRAS EST� EM ORDEM CRESCENTE DE �REA DE A�O
    
% if As<=4.91
%     AsdP=4.91; %4 barras de 12.5mm
%     fiLP=1.25;
%     NB=4;
% end
% if 4.91<As && As<=7.36
%     AsdP=7.36; %6 barras de 12.5mm
%     fiLP=1.25;
%     NB=6;
% end
% if 7.36<As && As<=8.04
%     AsdP=8.04; %4 barras de 16mm
%     fiLP=1.6;
%     NB=4;
% end
% if 8.04<As && As<=9.82
%     AsdP=9.82; %8 barras de 12.5mm
%     fiLP=1.25;
%     NB=8;
% end
% if 9.82<As && As<=12.06
%     AsdP=12.06; %6 barras de 16mm
%     fiLP=1.6;
%     NB=6;
% end
% if 12.06<As && As<=12.27
%     AsdP=12.27; %10 barras de 12.5mm
%     fiLP=1.25;
%     NB=10;
% end
% if 12.27<As && As<=12.57
%     AsdP=12.57; %4 barras de 20mm
%     fiLP=2;
%     NB=4;
% end
% if 12.57<As && As<=14.73
%     AsdP=14.73; %12 barras de 12.5mm
%     fiLP=1.25;
%     NB=12;
% end
% if 14.73<As && As<=16.08
%     AsdP=16.08; %8 barras de 16mm
%     fiLP=1.6;
%     NB=8;
% end
% if 16.08<As && As<=18.85
%     AsdP=18.85; %6 barras de 20mm
%     fiLP=2;
%     NB=6;
% end
% if 18.85<As && As<=19.63
%     AsdP=19.63; %4 barras de 25mm
%     fiLP=2.5;
%     NB=4;
% end
% if 19.63<As && As<=20.11
%     AsdP=20.11; %10 barras de 16mm
%     fiLP=1.6;
%     NB=10;
% end
% if 20.11<As && As<=24.13
%     AsdP=24.13; %12 barras de 16mm
%     fiLP=1.6;
%     NB=12;
% end
% if 24.13<As && As<=25.13
%     AsdP=25.13; %8 barras de 20mm
%     fiLP=2;
%     NB=8;
% end
% if 25.13<As && As<=29.45
%     AsdP=29.45; %6 barras de 25mm
%     fiLP=2.5;
%     NB=6;
% end
% if 29.45<As && As<=31.42
%     AsdP=31.42; %10 barras de 20mm
%     fiLP=2;
%     NB=10;
% end
% if 31.42<As && As<=37.7
%     AsdP=37.7; %12 barras de 20mm
%     fiLP=2;
%     NB=12;
% end
% if 37.7<As && As<=39.27
%     AsdP=39.27; %8 barras de 25mm
%     fiLP=2.5;
%     NB=8;
% end
% if 39.27<As && As<=49.09
%     AsdP=49.09; %10 barras de 25mm
%     fiLP=2.5;
%     NB=10;
% end
% if 49.09<As && As<=58.90
%     AsdP=58.90; %12 barras de 25mm
%     fiLP=2.5;
%     NB=12;
% end
% if 58.90<As 
%     disp('A armadura longitudinal � maior que 58.90cm2 (12 barras de 25mm). ')
% end
% 
% end

%**************************************************************************

%**************************************************************************
%ABAIXO, O ARRANJO DAS BARRAS EST� EM FUN��O DO N�MERO DE BARRAS DEFINIDO
%NA FUN��O PILAR16_B.m

% if nbarras==4
%         if As<=4.91
%         fiLP=1.25;
%         AsdP=4.91; %4 barras de 12.5mm
%         end
%         if 4.91<As && As<=8.04
%         fiLP=1.6;
%         AsdP=8.04; %4 barras de 16mm
%         end
%         if 8.04<As && As<=12.57
%         fiLP=2;
%         AsdP=12.57; %4 barras de 20mm
%         end
%         if 12.57<As && As<=19.63
%         fiLP=2.5;
%         AsdP=19.63; %4 barras de 25mm
%         end
%         if As>19.63
%             nbarras=6;
%             %Usando 4 barras de a�o, a maior �rea da armadura longitudinal
%             %� 19,63cm2 (4 barras de 25mm). Se As>19,63cm2, deve-se usar o
%             %arranjo com 6 barras.
%         end
% end
% 
% if nbarras==6
%         if As<=7.36
%         fiLP=1.25;
%         AsdP=7.36;   %6 barras de 12.5mm
%         end
%         if 7.36<As && As<=12.06
%         fiLP=1.6;
%         AsdP=12.06;  %6 barras de 16mm
%         end
%         if 12.06<As && As<=18.85
%         fiLP=2;
%         AsdP=18.85;  %6 barras de 20mm
%         end
%         if 18.85<As && As<=29.45
%         fiLP=2.5;
%         AsdP=29.45;  %6 barras de 25mm
%         end
%         if As>29.45
%             nbarras=8;
%             %Usando 6 barras de a�o, a maior �rea da armadura longitudinal
%             %� 29,45cm2 (6 barras de 25mm). Se As>29,45cm2, deve-se usar o
%             %arranjo com 8 barras.
%             if H<25.5
%                 disp('A armadura longitudinal � maior que 29,45cm2 (6 barras de 25mm). S�o necess�rias mais que 6 barras, mas como H<25,5cm, o espa�amento m�nimo entre barras n�o ser� atendido')
%             end    
%         end
% end
% 
% if nbarras==8
%         if As<=9.82
%         fiLP=1.25;
%         AsdP=9.82;   %8 barras de 12.5mm
%         end
%         if 9.82<As && As<=16.08
%         fiLP=1.6;
%         AsdP=16.08;  %8 barras de 16mm
%         end
%         if 16.08<As && As<=25.13
%         fiLP=2;
%         AsdP=25.13;  %8 barras de 20mm
%         end
%         if 25.13<As && As<=39.27
%         fiLP=2.5;
%         AsdP=39.27;  %8 barras de 25mm
%         end
%         if As>39.27
%             nbarras=10;
%             %Usando 8 barras de a�o, a maior �rea da armadura longitudinal
%             %� 39,27cm2 (8 barras de 25mm). Se As>39,27cm2, deve-se usar o
%             %arranjo com 10 barras.
%             if H<30
%                 disp('A armadura longitudinal � maior que 39,27cm2 (8 barras de 25mm). S�o necess�rias mais que 8 barras, mas como H<30cm, o espa�amento m�nimo entre barras n�o ser� atendido')
%             end    
%         end
% end
% 
% if nbarras==10
%         if As<=12.27
%         fiLP=1.25;
%         AsdP=12.27;   %10 barras de 12.5mm
%         end
%         if 12.27<As && As<=20.11
%         fiLP=1.6;
%         AsdP=20.11;  %10 barras de 16mm
%         end
%         if 20.11<As && As<=31.42
%         fiLP=2;
%         AsdP=31.42;  %10 barras de 20mm
%         end
%         if 31.42<As && As<=49.09
%         fiLP=2.5;
%         AsdP=49.09;  %10 barras de 25mm
%         end
%         if As>49.09
%             nbarras=12;
%             %Usando 10 barras de a�o, a maior �rea da armadura longitudinal
%             %� 49,09cm2 (10 barras de 25mm). Se As>49,09cm2, deve-se usar o
%             %arranjo com 12 barras.
%             if H<35.5
%                 disp('A armadura longitudinal � maior que 49,09cm2 (10 barras de 25mm). S�o necess�rias mais que 10 barras, mas como H<35,5cm, o espa�amento m�nimo entre barras n�o ser� atendido')
%             end    
%         end
% end
% 
% if nbarras==12
%         if As<=14.73
%         fiLP=1.25;
%         AsdP=14.73;   %12 barras de 12.5mm
%         end
%         if 14.73<As && As<=24.13
%         fiLP=1.6;
%         AsdP=24.13;   %12 barras de 16mm
%         end
%         if 24.13<As && As<=37.7
%         fiLP=2;
%         AsdP=37.7;   %12 barras de 20mm
%         end
%         if 37.7<As && As<=58.9
%         fiLP=2.5;
%         AsdP=58.9;   %12 barras de 25mm
%         end
%         if As>58.9
%             %Usando 12 barras de a�o, a maior �rea da armadura longitudinal
%             %� 58,90cm2 (12 barras de 25mm). 
%             disp('A armadura longitudinal � maior que 58,90cm2 (12 barras de 25mm).')
%         end
% end
   
%**************************************************************************











            