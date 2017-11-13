%FUNÇÃO QUE FORNECE OS ESFORÇOS SOLICITANTES

function[Ns,Msx,Msy,Vsx,Vsy]=PILAR8(N,Mxtopo,Mxbase,Mytopo,Mybase,Vx,Vy)
%Ns    Força normal solicitante(KN)
%Vsx   Força cortante solicitante na direção x (KN)
%Vsy   Força cortante solicitante na direção y (KN)
%Mx    Momento fletor solicitante na direção x (em torno de y) (KNm)
%My    Momento fletor solicitante na direção y (em torno de x) (KNm)
%Ms    Momento fletor solicitante(KNm)
%Coluna 1:momento na base do pilar
%Coluna 2:momento no topo do pilar

Ns=abs(N);
Vsx=Vx;
Vsy=Vy;
Mx=[Mxbase Mxtopo];
My=[Mybase Mytopo];
Vsy=Vy;
Msx=Mx;
Msy=My;



