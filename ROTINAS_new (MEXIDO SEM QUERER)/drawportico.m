function drawportico(PORTICO, ELEMENTOS, DADOS)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%-----------SCREEN MODEL - P�RTICO PLANO------------%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% PLOTAGEM DO P�RTICO PLANO

figure              % Abertura da janela de plotagem
hold on             % Segura as plotagens j� realizadas na janela de plotagem
grid off            % N�o desenha as linhas auxiliares da grelha  
box off             % N�o desenha a caixa do contorno

for i=1:PORTICO.nelem
    xpi=PORTICO.x(PORTICO.noinicial(i));
    ypi=PORTICO.z(PORTICO.noinicial(i));
    xpf=PORTICO.x(PORTICO.nofinal(i))+2*10^-5;
    ypf=PORTICO.z(PORTICO.nofinal(i));
    a=(ypf-ypi)/(xpf-xpi);
    b=ypi-a*xpi;
    x=linspace(xpi,xpf,10);
    y=a*x+b;
    plot (x,y);
end

% Ajusta os limites da janela de plotagem
v=axis;
axis([v(1)-0.5 v(2) v(3)-0.5 v(4)]);

% Plota as condi��es de contorno do p�rtico
s= size(PORTICO.nosrestritos);
for i=1:s(1)
    r(1)= PORTICO.restricao(i,1);
    r(2)= PORTICO.restricao(i,3);
    r(3)= PORTICO.restricao(i,4);
    x=PORTICO.x(PORTICO.nosrestritos(i));
    y=PORTICO.z(PORTICO.nosrestritos(i));
     if r(1)==1 & r(2)==1 & r(3)==1
         plot(x,y, 'b s')
     end
     if r(1)==1 & r(2)==1 & r(3)==0
         plot(x,y, 'b ^')
     end
     if r(1)==0 & r(2)==1 & r(3)==0
         plot(x,y, 'b o')
     end
end
         
    

