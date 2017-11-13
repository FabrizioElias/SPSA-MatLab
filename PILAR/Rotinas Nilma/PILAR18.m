%FUNÇÃO QUE CALCULA AS ÁREAS DE AÇO MÍNIMA E MÁXIMA 

function[Asmin,Asmax]=PILAR18(Nsd,fyd,Ac)
%NBR6118-17.3.5.3 Valores limites para armaduras longitudinais de pilares
%NBR6118-17.3.5.3.1 Valores mínimos
%A armadura longitudinal mínima deve ser:
temporario=[(0.15*Nsd/fyd) (0.004*Ac)];
Asmin=max(temporario);

%Nsd: Força normal solicitante de cálculo(KN)
%Ac:  Área da seção transversal de concreto (cm2)
%fyd: Resist. de cálculo ao escoamento do aço de armadura passiva(KN/cm2)

%NBR6118-17.3.5.3.2 Valores máximos
%A maior armadura possível em pilares deve ser 8% da seção real:
Asmax=8/100*Ac;

end




 

    








 

 







            