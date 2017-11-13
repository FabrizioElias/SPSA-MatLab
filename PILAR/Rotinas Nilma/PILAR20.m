%FUNÇÃO QUE COMPARA A ÁREA DE AÇO LONGITUDINAL CALCULADA COM A MÍNIMA E A MÁXIMA 

function[As]=PILAR20(Realizacao,Npilar,As,Asmin,Asmax)
%Asmin:  Armadura longitudinal mínima (cm2)
%Asmax:  Armadura longitudinal máxima (cm2)
%As:     Área de aço calculada da armadura longitudinal(cm2)
%Npilar: Número do pilar
if As<Asmin
    As=Asmin;
end

if As>Asmax
disp(['Realizacao: ',num2str(Realizacao),' - PILAR ',num2str(Npilar)])       
disp('A armadura longitudinal em pilares não deve ter valor maior que 8%Ac')
end




 

    








 

 







            