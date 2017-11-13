function PILARgerenciador(Realizacao,Npilar,fyV,fywV,rsV,~,~,fccV,fctV,finfV,~,hpxV,hpyV,...
         N,Mxtopo,Mxbase,Mytopo,Mybase,Vx,Vy,POSPILAR,eixo)

%CONTROLA A ORDEM DE CHAMADA DE TODAS AS OUTRAS FUN��ES DO MODELO PILAR

%COEFICIENTES DE PONDERA��O
global gamac gamas;
global gamar;

%REDU��O DAS RESIST�NCIAS DO A�O E DO CONCRETO ATRAV�S DOS COEFICIENTES DE
%PONDERA��O:
%Os coeficientes de pondera��o s�o informados no arquivo DADOS.in.
%Eles s�o iguais a 1 nos casos onde as vari�veis s�o aleat�rias.  Nos casos
%onde as vari�veis s�o determin�sticas, h� exemplos onde usei gamac=1.4,
%gamas=1.15 e gamar=1.4 para comparar com os resultados do CYPECAD.
%A�O (divide-se as resist�ncias por gamas)
%CONCRETO (divide-se as resist�ncias por gamac)

%MUDAN�A PARA A NOMENCLATURA USADA NO MODELO_PILAR
fyd=fyV/gamas;   %Resist�ncia ao escoamento do a�o de armadura passiva  (KN/cm2)
fywk=fywV;       %Resist�ncia ao escoamento do a�o da armad. transversal(KN/cm2)
fywd=fywV/gamas; %Tens�o na armadura transversal passiva                (KN/cm2)
rs=rsV;          %Massa espec�fica do a�o                               (kg/cm3)
%eyd=eyV;         %Deforma��o espec�fica de escoamento do a�o  
%Es=EsV;          %M�dulo de elasticidade do a�o                         (KN/cm2)
fcd=fccV/gamac;  %Resist�ncia � compress�o do concreto                  (KN/cm2)
fctm=fctV;       %Resist�ncia � tra��o do concreto                      (KN/cm2) 
fctd=finfV/gamac;%NBR6118 - 8.2.5                                       (KN/cm2) 
%fbd=fbV/gamac;   %Res. de ader�ncia entre armadura e concreto           (KN/cm2)  
hx=hpxV;         %Dimens�o do pilar na dire��o x                        (cm)
hy=hpyV;         %Dimens�o do pilar na dire��o y                        (cm)

fck=10*fccV;%fck est� sendo usado apenas em PILAR24.m.  Nesta fun��o, a unidade
%de fck � MPa, por isso fccV foi multiplicado por 10, j� que fccV est� em KN/cm2

%VARI�VEIS GLOBAIS
%CARACTER�STICAS GEOM�TRICAS
global cobp lo;

%COEFICIENTES DE PONDERA��O
%global gamar;     

%OUTROS DADOS                 
%global romin alfaanc alfaest;
global alfaest;

%PESO DO A�O
global PesoacoP;

%VOLUME DE CONCRETO
global VolconP;

%FORMA DO PILAR
global FormaP;

%Fun��o PILAR14_B:%Nesta fun��o, a metodologia de c�lculo das excentricidades
%para os pilares central (ou intermedi�rio) e de extremidade (ou lateral)foi
%retirada do livro CURSO DE CONCRETO ARMADO Jos� Milton Araujo VOLUME 3.
%A metodologia de c�lculo das excentricidades para pilares de canto foi
%adaptada daquela para pilares de extremidade.

%Fun��o PILAR16_B:Nesta fun��o, a metodologia de c�lculo de As para os pilares
%central (ou intermedi�rio), de extremidade (ou lateral) foi retirada do
%livro CURSO DE CONCRETO ARMADO Jos� Milton Araujo VOLUME 3.
%A metodologia de c�lculo de As para os pilares de canto foi adaptada
%daquela para pilares de extremidade.

% %FUN��O QUE FORNECE A SE��O TRANSVERSAL DO PILAR
%[hx,hy]=PILAR4;

% %FUN��O QUE FORNECE OS DADOS DO PROBLEMA
% [Es,fck,fy,fywk,rs,cobp,lo,gamac,gamas,gamar,romin,...
%          teta,beta,neta1,neta2,neta3,alfaanc,alfaest,POSPILAR...
%          N,Vx,Vy,Mxbase,Mxtopo,Mybase,Mytopo,eixo]=PILAR6;

%FUN��O QUE FORNECE OS ESFOR�OS SOLICITANTES
[Ns,Msx,Msy,Vsx,Vsy]=PILAR8(N,Mxtopo,Mxbase,Mytopo,Mybase,Vx,Vy);

%FUN��O QUE CALCULA PAR�METROS UTILIZADOS NOS C�LCULOS
%[Ac,cestribo,lpilar,Nsd,Vsxd,Vsyd,Msx,Msxd,Msy,Msyd,ni0]=...
%        PILAR10(fcd,hx,hy,cobp,gamar,Ns,Msx,Msy,Vsx,Vsy,lo);
[Ac,cestribo,lpilar,Nsd,Vsxd,Vsyd,Msx,~,Msy,~,ni0]=...
        PILAR10(fcd,hx,hy,cobp,gamar,Ns,Msx,Msy,Vsx,Vsy,lo);
    
%FUN��O QUE CALCULA:MOMENTO DE IN�RCIA,RAIO DE GIRA��O,COMPRIMENTO DE
%FLAMBAGEM E �NDICE DE ESBELTEZ
%[Ix,Iy,raiox,raioy,lex,ley,lambdax,lambday]=PILAR12(hx,hy,lo);
[~,~,~,~,lex,ley,lambdax,lambday]=PILAR12(hx,hy,lo);

%FUN��O QUE CALCULA AS EXCENTRICIDADES
[ex,ey]=PILAR14_B(Realizacao,Npilar,POSPILAR,lex,ley,hx,hy,lambdax,lambday,ni0,Ns,Msx,Msy,eixo);

%FUNCAO QUE CALCULA A �REA DE A�O LONGITUDINAL
%[As,nbarras]=PILAR16_B(Realizacao,Npilar,Nsd,fcd,cobp,ex,ey,hx,hy,POSPILAR,fyd);
[As,~]=PILAR16_B(Realizacao,Npilar,Nsd,fcd,cobp,ex,ey,hx,hy,POSPILAR,fyd);

%FUN��O QUE CALCULA AS �REAS DE A�O M�NIMA E M�XIMA
[Asmin,Asmax]=PILAR18(Nsd,fyd,Ac);

%FUN��O QUE COMPARA A �REA DE A�O LONGITUDINAL CALCULADA COM A M�NIMA E A M�XIMA
[As]=PILAR20(Realizacao,Npilar,As,Asmin,Asmax);

%FUN��O QUE DEFINE A ARMADURA LONGITUDINAL USADA
%[AsdP,fiLP,NB]=PILAR22(Realizacao,Npilar,As,hx,hy,cobp);
[AsdP,~,~]=PILAR22(Realizacao,Npilar,As,hx,hy,cobp);

%FUN��O QUE CALCULA A �REA DE A�O TRANSVERSAL
%[AswS,AswSmin]=PILAR24(Realizacao,Npilar,hx,hy,fck,Vsxd,Vsyd,fcd,fywk,fctm,fctd,fywd,alfaest,cobp);
[AswS,~]=PILAR24(Realizacao,Npilar,hx,hy,fck,Vsxd,Vsyd,fcd,fywk,fctm,fctd,fywd,alfaest,cobp);

%FUN��O QUE DETERMINA A �REA DE A�O TRANSVERSAL USADA
%[AswSdP,nestribos,fiTP]=PILAR26(Realizacao,Npilar,AswS,lpilar);
[~,nestribos,fiTP]=PILAR26(Realizacao,Npilar,AswS,lpilar);

%FUN��O QUE CALCULA O COMPRIMENTO DE ANCORAGEM 
%[lbPnec]=PILAR28(fyd,fbd,As,AsdP,fiLP,alfaanc);

%FUN��O QUE CALCULA O VOLUME DO A�O
[Vaco_P,Vlong,Vtrans]=PILAR30(AsdP,lpilar,nestribos,fiTP,cestribo);

%FUN��O QUE CALCULA O PESO DO A�O
[PesoacoP]=PILAR32(Vaco_P,Vlong,Vtrans,rs);

%FUN��O QUE CALCULA O VOLUME DO CONCRETO
[VolconP]=PILAR34(hx,hy,lo);

%FUN��O QUE CALCULA A �REA DE FORMA
[FormaP]=PILAR36(hx,hy,lo);

%FUN��O QUE CRIA ARQUIVO doc COM OS RESULTADOS
%PILAR38;


