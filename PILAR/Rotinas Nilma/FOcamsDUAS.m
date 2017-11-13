%Apostila ESTRUTURAS DE CONCRETO: ÁBACOS PARA FLEXÃO OBLÍQUA
%Libânio Miranda Pinheiro-Lívio Túlio Baraldi-Marcelo Eduardo Porem
%Aço CA-50 A
%Número de camadas:2

%***************ESTA FUNÇÃO ESTÁ INCOMPLETA********************************

function[omega]=FOcamsDUAS(ni,mix,miy,comb)
%omega: taxa mecânica de armadura

%Busca do intervalo que contém mix
if 0<=mix && mix<=0.05
MIx=[0 0.05];
c=[1 2];
end
if 0.05<mix && mix<=0.10
MIx=[0.05 0.10];
c=[2 3];
end
if 0.10<mix && mix<=0.15
MIx=[0.10 0.15];
c=[3 4];
end
if 0.15<mix && mix<=0.20
MIx=[0.15 0.20];
c=[4 5];
end
if 0.20<mix && mix<=0.25
MIx=[0.20 0.25];
c=[5 6];
end
if 0.25<mix && mix<=0.30
MIx=[0.25 0.30];
c=[6 7];
end
if 0.30<mix && mix<=0.35
MIx=[0.30 0.35];
c=[7 8];
end
if 0.35<mix && mix<=0.40
MIx=[0.35 0.40];
c=[8 9];
end
if 0.40<mix && mix<=0.45
MIx=[0.40 0.45];
c=[9 10];
end
if 0.45<mix && mix<=0.50
MIx=[0.45 0.50];
c=[10 11];
end

%Busca do intervalo que contém MIy
if 0<=miy && miy<=0.05
MIy=[0 0.05];
l=[1 2];
end
if 0.05<miy && miy<=0.10
MIy=[0.05 0.10];
l=[2 3];
end
if 0.10<miy && miy<=0.15
MIy=[0.10 0.15];
l=[3 4];
end
if 0.15<miy && miy<=0.20
MIy=[0.15 0.20];
l=[4 5];
end
if 0.20<miy && miy<=0.25
MIy=[0.20 0.25];
l=[5 6];
end
if 0.25<miy && miy<=0.30
MIy=[0.25 0.30];
l=[6 7];
end
if 0.30<miy && miy<=0.35
MIy=[0.30 0.35];
l=[7 8];
end
if 0.35<miy && miy<=0.40
MIy=[0.35 0.40];
l=[8 9];
end
if 0.40<miy && miy<=0.45
MIy=[0.40 0.45];
l=[9 10];
end
if 0.45<miy && miy<=0.50
MIy=[0.45 0.50];
l=[10 11];
end

%ESCOLHA DA TABELA: em função de deltax, deltay e ni
switch comb
    
case 1
if ni==0
%Ábaco 3 (ni=0) 
w=[];
end
if ni==0.20
%Ábaco 3 (ni=0.20) 
w=[];
end
if ni==0.40
%Ábaco 3 (ni=0.40) 
w=[];
end
if ni==0.60
%Ábaco 3 (ni=0.60) 
w=[];
end
if ni==0.80
%Ábaco 3 (ni=0.80) 
w=[];
end
if ni==1.0
%Ábaco 3 (ni=1.0) 
w=[];
end
if ni==1.20
%Ábaco 3 (ni=1.20) 
w=[];
end
if ni==1.40
%Ábaco 3 (ni=1.40) 
w=[];
end

-----Em cada case preciso colocar(como acima),as 8 opções de ni. 

case 2
%Tabela 
w=[];
    
case 3
%Tabela
w=[];

case 4
%Tabela
w=[];

case 5
%Tabela
w=[];

case 6
%Tabela
w=[];

case 7
%Tabela
w=[];

case 8
%Tabela
w=[];

case 9
%Tabela
w=[];

otherwise
%Tabela
w=[];

end
  
 %Interpolação entre as colunas:
 A=(w(:,c(2))-w(:,c(1)))*(mix-MIx(1))/(MIx(2)-MIx(1));
 I=w(:,c(1))+A;
   
 %Interpolação entre as linhas:
 B=(I(l(2))-I(l(1)))*(miy-MIy(1))/(MIy(2)-MIy(1));
 
 %Após as interpolações:
 omega=I(l(1))+B;
  
end






   
   
    
 










            