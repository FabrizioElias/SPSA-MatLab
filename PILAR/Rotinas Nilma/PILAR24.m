%FUN��O QUE CALCULA A �REA DE A�O TRANSVERSAL

function[AswS,AswSmin]=PILAR24(Realizacao,Npilar,hx,hy,fck,Vsxd,Vsyd,fcd,fywk,fctm,fctd,fywd,alfaest,cobp)
%hx    Dimens�o do pilar na dire��o x (cm)
%hy    Dimens�o do pilar na dire��o y (cm)
%d     Altura �til da se��o(cm).
%fcd   Resist�ncia de c�lculo � compress�o do concreto (KN/cm2).
%fywk  Resist. ao escoamento do a�o da arm. transversal(KN/cm2).NBR6118-17.4.1.1.2
%fctm  Resist�ncia m�dia � tra��o do concreto (KN/cm2).NBR6118-8.2.5.
%fctd  NBR6118-9.3.2.1(KN/cm2)
%fywd  Tens�o na armadura transversal passiva, limitada ao valor fyd, n�o
%      se tomando valores superiores a 435MPa(MPa).NBR6118-17.4.2.2.
%      fywd est� em KN/cm2
%alfaest Inclina��o dos estribos em rela��o ao eixo longitudinal do
%        elemento estrutural. NBR6118-17.4.1.1.2.
%AswS      Armadura transversal calculada (cm2/m).NBR6118-17.4.2.2.
%AswSmin   Armadura transversal m�nima (cm2/m).NBR6118-17.4.1.1.1.

%Vsd     For�a cortante solicitante de c�lculo(KN). NBR6118-17.4.2.1.
%Vsw     Parcela de for�a cortante resistida pela armadura transver.
%Vc0     (NBR 6118 17.4.2.2) (KN)
%Vc      Parcela de for�a cortante (KN)absorvida por mecanismos complementares
%        ao de treli�a.
%VRd2    For�a cortante resistente de c�lculo, relativa � ru�na das dia-
%        gonais comprimidas de concreto (KN) (NBR 6118 17.4.2.1)
%VRd3    For�a cortante resistente de c�lculo, relativa � ru�na por tra��o
%        diagonal (KN) (NBR 6118 17.4.2.1)

%Modelo de C�lculo I (NBR 6118 17.4.2.2)

%1 - ESFOR�O CORTANTE NA DIRE��O x 
bw=hy;      %(cm)
d=hx-cobp;  %(cm)
Vsd=abs(Vsxd); %(KN)

av2=1-fck/250;%A unidade de fck � MPa
VRd2=0.27*av2*fcd*bw*d; %fcd:KN/cm2    bw:cm   d:cm
VRd3=Vsd;   %Como Vsd<=VRd3, ent�o atribui-se a VRd3 o valor de Vsd
if fywd>43.5%A tens�o fyd est� em KN/cm2.fywd n�o pode ser maior que435MPa.
fywd=43.5; %KN/cm2
end
Vc0=0.6*fctd*bw*d; 

%if controlVc==1
%Vc=Vc0;
%else Vc=Vc0*(1+M0/Msdmax)
%if Vc>2*Vc0
%Vc=2*Vc0
%end
%Simplifica��o: Vc pode assumir os valores 0<Vc<2Vc0,de acordo com o item
%17.4.2.2.Por simplifica��o, Vc ser� adotado como Vc0.
Vc=Vc0;
%C�lculo da resist�ncia (NBR 6118 17.4.2.1)
%Vsd deve ser menor ou igual a VRd2

if Vsd>VRd2
   disp(['Realizacao: ',num2str(Realizacao),' - PILAR ',num2str(Npilar)])       
   disp('�REA DE A�O TRANSVERSAL. A for�a cortante solicitante n�o pode ser maior que a for�a cortante resistente.')
end
Vsw=VRd3-Vc; %(item 17.4.2.1)
%Armadura transversal
AswSx=Vsw/(0.9*d*fywd*(sin(alfaest*pi/180)+cos(alfaest*pi/180)))*100;
%Armadura transversal m�nima (NBR 6118 17.4.1.1)
AswSmin=0.2*fctm/fywk*bw*sin(alfaest*pi/180)*100;
if AswSmin>AswSx
   AswSx=AswSmin;
end

%2 - ESFOR�O CORTANTE NA DIRE��O y 
bw=hx;      %(cm)
d=hy-cobp;  %(cm)
Vsd=abs(Vsyd); %(KN)

av2=1-fck/250;%A unidade de fck � MPa
VRd2=0.27*av2*fcd*bw*d; %fcd:KN/cm2    bw:cm   d:cm
VRd3=Vsd;   %Como Vsd<=VRd3, ent�o atribui-se a VRd3 o valor de Vsd
if fywd>43.5%A tens�o fyd est� em KN/cm2.fywd n�o pode ser maior que435MPa.
fywd=43.5; %KN/cm2
end
Vc0=0.6*fctd*bw*d; 

%if controlVc==1
%Vc=Vc0;
%else Vc=Vc0*(1+M0/Msdmax)
%if Vc>2*Vc0
%Vc=2*Vc0
%end
%Simplifica��o: Vc pode assumir os valores 0<Vc<2Vc0,de acordo com o item
%17.4.2.2.Por simplifica��o, Vc ser� adotado como Vc0.
Vc=Vc0;
%C�lculo da resist�ncia (NBR 6118 17.4.2.1)
%Vsd deve ser menor ou igual a VRd2

if Vsd>VRd2
   disp(['Realizacao: ',num2str(Realizacao),' - PILAR ',num2str(Npilar)])       
   disp('�REA DE A�O TRANSVERSAL. Vsd n�o pode ser maior que VRd2')
end
Vsw=VRd3-Vc; %(item 17.4.2.1)
%Armadura transversal
AswSy=Vsw/(0.9*d*fywd*(sin(alfaest*pi/180)+cos(alfaest*pi/180)))*100;
%Armadura transversal m�nima (NBR 6118 17.4.1.1)
AswSmin=0.2*fctm/fywk*bw*sin(alfaest*pi/180)*100;

if AswSmin>AswSy
   AswSy=AswSmin;
end

%3 - ESCOLHA DA MAIOR ARMADURA TRANSVERSAL
%A �rea de a�o deve ser o maior:Asx ou Asy
areas=[AswSx AswSy];
AswS=max(areas); %cm2/m

end

 







            