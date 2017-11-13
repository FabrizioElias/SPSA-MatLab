%FUNÇÃO QUE CALCULA A ÁREA DE AÇO TRANSVERSAL

function[AswS,AswSmin]=PILAR24(Realizacao,Npilar,hx,hy,fck,Vsxd,Vsyd,fcd,fywk,fctm,fctd,fywd,alfaest,cobp)
%hx    Dimensão do pilar na direção x (cm)
%hy    Dimensão do pilar na direção y (cm)
%d     Altura útil da seção(cm).
%fcd   Resistência de cálculo à compressão do concreto (KN/cm2).
%fywk  Resist. ao escoamento do aço da arm. transversal(KN/cm2).NBR6118-17.4.1.1.2
%fctm  Resistência média à tração do concreto (KN/cm2).NBR6118-8.2.5.
%fctd  NBR6118-9.3.2.1(KN/cm2)
%fywd  Tensão na armadura transversal passiva, limitada ao valor fyd, não
%      se tomando valores superiores a 435MPa(MPa).NBR6118-17.4.2.2.
%      fywd está em KN/cm2
%alfaest Inclinação dos estribos em relação ao eixo longitudinal do
%        elemento estrutural. NBR6118-17.4.1.1.2.
%AswS      Armadura transversal calculada (cm2/m).NBR6118-17.4.2.2.
%AswSmin   Armadura transversal mínima (cm2/m).NBR6118-17.4.1.1.1.

%Vsd     Força cortante solicitante de cálculo(KN). NBR6118-17.4.2.1.
%Vsw     Parcela de força cortante resistida pela armadura transver.
%Vc0     (NBR 6118 17.4.2.2) (KN)
%Vc      Parcela de força cortante (KN)absorvida por mecanismos complementares
%        ao de treliça.
%VRd2    Força cortante resistente de cálculo, relativa à ruína das dia-
%        gonais comprimidas de concreto (KN) (NBR 6118 17.4.2.1)
%VRd3    Força cortante resistente de cálculo, relativa à ruína por tração
%        diagonal (KN) (NBR 6118 17.4.2.1)

%Modelo de Cálculo I (NBR 6118 17.4.2.2)

%1 - ESFORÇO CORTANTE NA DIREÇÃO x 
bw=hy;      %(cm)
d=hx-cobp;  %(cm)
Vsd=abs(Vsxd); %(KN)

av2=1-fck/250;%A unidade de fck é MPa
VRd2=0.27*av2*fcd*bw*d; %fcd:KN/cm2    bw:cm   d:cm
VRd3=Vsd;   %Como Vsd<=VRd3, então atribui-se a VRd3 o valor de Vsd
if fywd>43.5%A tensão fyd está em KN/cm2.fywd não pode ser maior que435MPa.
fywd=43.5; %KN/cm2
end
Vc0=0.6*fctd*bw*d; 

%if controlVc==1
%Vc=Vc0;
%else Vc=Vc0*(1+M0/Msdmax)
%if Vc>2*Vc0
%Vc=2*Vc0
%end
%Simplificação: Vc pode assumir os valores 0<Vc<2Vc0,de acordo com o item
%17.4.2.2.Por simplificação, Vc será adotado como Vc0.
Vc=Vc0;
%Cálculo da resistência (NBR 6118 17.4.2.1)
%Vsd deve ser menor ou igual a VRd2

if Vsd>VRd2
   disp(['Realizacao: ',num2str(Realizacao),' - PILAR ',num2str(Npilar)])       
   disp('ÁREA DE AÇO TRANSVERSAL. A força cortante solicitante não pode ser maior que a força cortante resistente.')
end
Vsw=VRd3-Vc; %(item 17.4.2.1)
%Armadura transversal
AswSx=Vsw/(0.9*d*fywd*(sin(alfaest*pi/180)+cos(alfaest*pi/180)))*100;
%Armadura transversal mínima (NBR 6118 17.4.1.1)
AswSmin=0.2*fctm/fywk*bw*sin(alfaest*pi/180)*100;
if AswSmin>AswSx
   AswSx=AswSmin;
end

%2 - ESFORÇO CORTANTE NA DIREÇÃO y 
bw=hx;      %(cm)
d=hy-cobp;  %(cm)
Vsd=abs(Vsyd); %(KN)

av2=1-fck/250;%A unidade de fck é MPa
VRd2=0.27*av2*fcd*bw*d; %fcd:KN/cm2    bw:cm   d:cm
VRd3=Vsd;   %Como Vsd<=VRd3, então atribui-se a VRd3 o valor de Vsd
if fywd>43.5%A tensão fyd está em KN/cm2.fywd não pode ser maior que435MPa.
fywd=43.5; %KN/cm2
end
Vc0=0.6*fctd*bw*d; 

%if controlVc==1
%Vc=Vc0;
%else Vc=Vc0*(1+M0/Msdmax)
%if Vc>2*Vc0
%Vc=2*Vc0
%end
%Simplificação: Vc pode assumir os valores 0<Vc<2Vc0,de acordo com o item
%17.4.2.2.Por simplificação, Vc será adotado como Vc0.
Vc=Vc0;
%Cálculo da resistência (NBR 6118 17.4.2.1)
%Vsd deve ser menor ou igual a VRd2

if Vsd>VRd2
   disp(['Realizacao: ',num2str(Realizacao),' - PILAR ',num2str(Npilar)])       
   disp('ÁREA DE AÇO TRANSVERSAL. Vsd não pode ser maior que VRd2')
end
Vsw=VRd3-Vc; %(item 17.4.2.1)
%Armadura transversal
AswSy=Vsw/(0.9*d*fywd*(sin(alfaest*pi/180)+cos(alfaest*pi/180)))*100;
%Armadura transversal mínima (NBR 6118 17.4.1.1)
AswSmin=0.2*fctm/fywk*bw*sin(alfaest*pi/180)*100;

if AswSmin>AswSy
   AswSy=AswSmin;
end

%3 - ESCOLHA DA MAIOR ARMADURA TRANSVERSAL
%A área de aço deve ser o maior:Asx ou Asy
areas=[AswSx AswSy];
AswS=max(areas); %cm2/m

end

 







            