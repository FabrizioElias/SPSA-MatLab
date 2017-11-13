%FUN��O QUE CALCULA A �REA DE FORMA

function[FormaP]=PILAR36(hx,hy,lo)
%hx       Dimens�o do pilar na dire��o x (cm)
%hy       Dimens�o do pilar na dire��o y (cm)
%lo       Altura do pilar medida entre as faces internas das lajes (cm)
%FormaP   �rea de forma do pilar (m2)

FormaP=2*(hx*lo+hy*lo)/10000;%(m2)
%Divide-se por 10000 para transformar cm2 em m2.
