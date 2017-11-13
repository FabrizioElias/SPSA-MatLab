%FUNÇÃO QUE DETERMINA A ÁREA DE AÇO TRANSVERSAL USADA

function[AswSdP,nestribos,fiTP]=PILAR26(Realizacao,Npilar,AswS,lpilar)

%AswS      Armadura transversal calculada (cm2/m).NBR6118-17.4.2.2
%AswSdP    Armadura transversal usada no pilar(cm2/m).
%nestribos Número de estribos do pilar
%fiTP      Diâmetro do estribo do pilar (cm)

%Intervalos para especificar a armadura transversal usada:
    if AswS<=2.5                 
       AswSdP=2.62;%ferro de 5 a cada 15
       fiTP=0.5; %(cm)
       nestribos=lpilar/15;
    end
     if 2.5<AswS && AswS<=3                
       AswSdP=3.12;%ferro de 6.3 a cada 20
       fiTP=0.63; %(cm)
       nestribos=lpilar/20;
     end 
    if 3<AswS && AswS<=4                 
       AswSdP=4.16;%ferro de 6.3 a cada 15
       fiTP=0.63; %(cm)
       nestribos=lpilar/15;
    end
     if 4<AswS && AswS<=5     
       AswSdP=5.03;%ferro de 8 a cada 20
       fiTP=0.8; %(cm)
       nestribos=lpilar/20;
    end
    if 5<AswS && AswS<=6     
       AswSdP=6.7;%ferro de 8 a cada 15
       fiTP=0.8; %(cm)
       nestribos=lpilar/15;
    end
    if 6<AswS && AswS<=7    
       AswSdP=7.85;%ferro de 10 a cada 20
       fiTP=1; %(cm)
       nestribos=lpilar/20;
    end
    if 7<AswS && AswS<=10    
       AswSdP=10.47;%ferro de 10 a cada 15
       fiTP=1; %(cm)
       nestribos=lpilar/15;
    end
    if 10<AswS && AswS<=13    
       AswSdP=13.09;%ferro de 10 a cada 12
       fiTP=1; %(cm)
       nestribos=lpilar/12;
    end
    if 13<AswS && AswS<=16    
       AswSdP=16.36;%ferro de 12.5 a cada 15
       fiTP=1.25; %(cm)
       nestribos=lpilar/15;
    end
    if AswS>16
       disp(['Realizacao: ',num2str(Realizacao),' - PILAR ',num2str(Npilar)])       
       disp('São necessários estribos maiores que barras de 12.5mm a cada 15')
    end
end 

 







            