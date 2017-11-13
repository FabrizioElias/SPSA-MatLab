%FUNÇÃO QUE CALCULA A ÁREA DE FORMA

function[FormaP]=PILAR36(hx,hy,lo)
%hx       Dimensão do pilar na direção x (cm)
%hy       Dimensão do pilar na direção y (cm)
%lo       Altura do pilar medida entre as faces internas das lajes (cm)
%FormaP   Área de forma do pilar (m2)

FormaP=2*(hx*lo+hy*lo)/10000;%(m2)
%Divide-se por 10000 para transformar cm2 em m2.
