%FUN��O QUE COMPARA A �REA DE A�O LONGITUDINAL CALCULADA COM A M�NIMA E A M�XIMA 

function[As]=PILAR20(Realizacao,Npilar,As,Asmin,Asmax)
%Asmin:  Armadura longitudinal m�nima (cm2)
%Asmax:  Armadura longitudinal m�xima (cm2)
%As:     �rea de a�o calculada da armadura longitudinal(cm2)
%Npilar: N�mero do pilar
if As<Asmin
    As=Asmin;
end

if As>Asmax
disp(['Realizacao: ',num2str(Realizacao),' - PILAR ',num2str(Npilar)])       
disp('A armadura longitudinal em pilares n�o deve ter valor maior que 8%Ac')
end




 

    








 

 







            