%FUN��O QUE CALCULA AS �REAS DE A�O M�NIMA E M�XIMA 

function[Asmin,Asmax]=PILAR18(Nsd,fyd,Ac)
%NBR6118-17.3.5.3 Valores limites para armaduras longitudinais de pilares
%NBR6118-17.3.5.3.1 Valores m�nimos
%A armadura longitudinal m�nima deve ser:
temporario=[(0.15*Nsd/fyd) (0.004*Ac)];
Asmin=max(temporario);

%Nsd: For�a normal solicitante de c�lculo(KN)
%Ac:  �rea da se��o transversal de concreto (cm2)
%fyd: Resist. de c�lculo ao escoamento do a�o de armadura passiva(KN/cm2)

%NBR6118-17.3.5.3.2 Valores m�ximos
%A maior armadura poss�vel em pilares deve ser 8% da se��o real:
Asmax=8/100*Ac;

end




 

    








 

 







            