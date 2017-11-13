%FUN��O QUE FORNECE OS ESFOR�OS SOLICITANTES

function[Ns,Msx,Msy,Vsx,Vsy]=PILAR8(N,Mxtopo,Mxbase,Mytopo,Mybase,Vx,Vy)
%Ns    For�a normal solicitante(KN)
%Vsx   For�a cortante solicitante na dire��o x (KN)
%Vsy   For�a cortante solicitante na dire��o y (KN)
%Mx    Momento fletor solicitante na dire��o x (em torno de y) (KNm)
%My    Momento fletor solicitante na dire��o y (em torno de x) (KNm)
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



