%FUNÇÃO QUE CALCULA O VOLUME DO CONCRETO

function[VolconP]=PILAR34(hx,hy,lo)
%hx       Dimensão do pilar na direção x (cm)
%hy       Dimensão do pilar na direção y (cm)
%lo       Altura do pilar medida entre as faces internas das lajes (cm)
%VolconP  Volume de concreto do pilar (m3)

VolconP=hx*hy*lo*10^-6; %(m3)
%Multiplica-se por 10^-6 para transformar cm3 em m3.
