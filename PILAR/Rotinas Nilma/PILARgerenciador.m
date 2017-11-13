function PILARgerenciador(Realizacao,Npilar,fyV,fywV,rsV,~,~,fccV,fctV,finfV,~,hpxV,hpyV,...
         N,Mxtopo,Mxbase,Mytopo,Mybase,Vx,Vy,POSPILAR,eixo)

%CONTROLA A ORDEM DE CHAMADA DE TODAS AS OUTRAS FUNÇÕES DO MODELO PILAR

%COEFICIENTES DE PONDERAÇÃO
global gamac gamas;
global gamar;

%REDUÇÃO DAS RESISTÊNCIAS DO AÇO E DO CONCRETO ATRAVÉS DOS COEFICIENTES DE
%PONDERAÇÃO:
%Os coeficientes de ponderação são informados no arquivo DADOS.in.
%Eles são iguais a 1 nos casos onde as variáveis são aleatórias.  Nos casos
%onde as variáveis são determinísticas, há exemplos onde usei gamac=1.4,
%gamas=1.15 e gamar=1.4 para comparar com os resultados do CYPECAD.
%AÇO (divide-se as resistências por gamas)
%CONCRETO (divide-se as resistências por gamac)

%MUDANÇA PARA A NOMENCLATURA USADA NO MODELO_PILAR
fyd=fyV/gamas;   %Resistência ao escoamento do aço de armadura passiva  (KN/cm2)
fywk=fywV;       %Resistência ao escoamento do aço da armad. transversal(KN/cm2)
fywd=fywV/gamas; %Tensão na armadura transversal passiva                (KN/cm2)
rs=rsV;          %Massa específica do aço                               (kg/cm3)
%eyd=eyV;         %Deformação específica de escoamento do aço  
%Es=EsV;          %Módulo de elasticidade do aço                         (KN/cm2)
fcd=fccV/gamac;  %Resistência à compressão do concreto                  (KN/cm2)
fctm=fctV;       %Resistência à tração do concreto                      (KN/cm2) 
fctd=finfV/gamac;%NBR6118 - 8.2.5                                       (KN/cm2) 
%fbd=fbV/gamac;   %Res. de aderência entre armadura e concreto           (KN/cm2)  
hx=hpxV;         %Dimensão do pilar na direção x                        (cm)
hy=hpyV;         %Dimensão do pilar na direção y                        (cm)

fck=10*fccV;%fck está sendo usado apenas em PILAR24.m.  Nesta função, a unidade
%de fck é MPa, por isso fccV foi multiplicado por 10, já que fccV está em KN/cm2

%VARIÁVEIS GLOBAIS
%CARACTERÍSTICAS GEOMÉTRICAS
global cobp lo;

%COEFICIENTES DE PONDERAÇÃO
%global gamar;     

%OUTROS DADOS                 
%global romin alfaanc alfaest;
global alfaest;

%PESO DO AÇO
global PesoacoP;

%VOLUME DE CONCRETO
global VolconP;

%FORMA DO PILAR
global FormaP;

%Função PILAR14_B:%Nesta função, a metodologia de cálculo das excentricidades
%para os pilares central (ou intermediário) e de extremidade (ou lateral)foi
%retirada do livro CURSO DE CONCRETO ARMADO José Milton Araujo VOLUME 3.
%A metodologia de cálculo das excentricidades para pilares de canto foi
%adaptada daquela para pilares de extremidade.

%Função PILAR16_B:Nesta função, a metodologia de cálculo de As para os pilares
%central (ou intermediário), de extremidade (ou lateral) foi retirada do
%livro CURSO DE CONCRETO ARMADO José Milton Araujo VOLUME 3.
%A metodologia de cálculo de As para os pilares de canto foi adaptada
%daquela para pilares de extremidade.

% %FUNÇÃO QUE FORNECE A SEÇÃO TRANSVERSAL DO PILAR
%[hx,hy]=PILAR4;

% %FUNÇÃO QUE FORNECE OS DADOS DO PROBLEMA
% [Es,fck,fy,fywk,rs,cobp,lo,gamac,gamas,gamar,romin,...
%          teta,beta,neta1,neta2,neta3,alfaanc,alfaest,POSPILAR...
%          N,Vx,Vy,Mxbase,Mxtopo,Mybase,Mytopo,eixo]=PILAR6;

%FUNÇÃO QUE FORNECE OS ESFORÇOS SOLICITANTES
[Ns,Msx,Msy,Vsx,Vsy]=PILAR8(N,Mxtopo,Mxbase,Mytopo,Mybase,Vx,Vy);

%FUNÇÃO QUE CALCULA PARÂMETROS UTILIZADOS NOS CÁLCULOS
%[Ac,cestribo,lpilar,Nsd,Vsxd,Vsyd,Msx,Msxd,Msy,Msyd,ni0]=...
%        PILAR10(fcd,hx,hy,cobp,gamar,Ns,Msx,Msy,Vsx,Vsy,lo);
[Ac,cestribo,lpilar,Nsd,Vsxd,Vsyd,Msx,~,Msy,~,ni0]=...
        PILAR10(fcd,hx,hy,cobp,gamar,Ns,Msx,Msy,Vsx,Vsy,lo);
    
%FUNÇÃO QUE CALCULA:MOMENTO DE INÉRCIA,RAIO DE GIRAÇÃO,COMPRIMENTO DE
%FLAMBAGEM E ÍNDICE DE ESBELTEZ
%[Ix,Iy,raiox,raioy,lex,ley,lambdax,lambday]=PILAR12(hx,hy,lo);
[~,~,~,~,lex,ley,lambdax,lambday]=PILAR12(hx,hy,lo);

%FUNÇÃO QUE CALCULA AS EXCENTRICIDADES
[ex,ey]=PILAR14_B(Realizacao,Npilar,POSPILAR,lex,ley,hx,hy,lambdax,lambday,ni0,Ns,Msx,Msy,eixo);

%FUNCAO QUE CALCULA A ÁREA DE AÇO LONGITUDINAL
%[As,nbarras]=PILAR16_B(Realizacao,Npilar,Nsd,fcd,cobp,ex,ey,hx,hy,POSPILAR,fyd);
[As,~]=PILAR16_B(Realizacao,Npilar,Nsd,fcd,cobp,ex,ey,hx,hy,POSPILAR,fyd);

%FUNÇÃO QUE CALCULA AS ÁREAS DE AÇO MÍNIMA E MÁXIMA
[Asmin,Asmax]=PILAR18(Nsd,fyd,Ac);

%FUNÇÃO QUE COMPARA A ÁREA DE AÇO LONGITUDINAL CALCULADA COM A MÍNIMA E A MÁXIMA
[As]=PILAR20(Realizacao,Npilar,As,Asmin,Asmax);

%FUNÇÃO QUE DEFINE A ARMADURA LONGITUDINAL USADA
%[AsdP,fiLP,NB]=PILAR22(Realizacao,Npilar,As,hx,hy,cobp);
[AsdP,~,~]=PILAR22(Realizacao,Npilar,As,hx,hy,cobp);

%FUNÇÃO QUE CALCULA A ÁREA DE AÇO TRANSVERSAL
%[AswS,AswSmin]=PILAR24(Realizacao,Npilar,hx,hy,fck,Vsxd,Vsyd,fcd,fywk,fctm,fctd,fywd,alfaest,cobp);
[AswS,~]=PILAR24(Realizacao,Npilar,hx,hy,fck,Vsxd,Vsyd,fcd,fywk,fctm,fctd,fywd,alfaest,cobp);

%FUNÇÃO QUE DETERMINA A ÁREA DE AÇO TRANSVERSAL USADA
%[AswSdP,nestribos,fiTP]=PILAR26(Realizacao,Npilar,AswS,lpilar);
[~,nestribos,fiTP]=PILAR26(Realizacao,Npilar,AswS,lpilar);

%FUNÇÃO QUE CALCULA O COMPRIMENTO DE ANCORAGEM 
%[lbPnec]=PILAR28(fyd,fbd,As,AsdP,fiLP,alfaanc);

%FUNÇÃO QUE CALCULA O VOLUME DO AÇO
[Vaco_P,Vlong,Vtrans]=PILAR30(AsdP,lpilar,nestribos,fiTP,cestribo);

%FUNÇÃO QUE CALCULA O PESO DO AÇO
[PesoacoP]=PILAR32(Vaco_P,Vlong,Vtrans,rs);

%FUNÇÃO QUE CALCULA O VOLUME DO CONCRETO
[VolconP]=PILAR34(hx,hy,lo);

%FUNÇÃO QUE CALCULA A ÁREA DE FORMA
[FormaP]=PILAR36(hx,hy,lo);

%FUNÇÃO QUE CRIA ARQUIVO doc COM OS RESULTADOS
%PILAR38;


