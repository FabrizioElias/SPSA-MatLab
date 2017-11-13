b=2.5;
sigmab=0.007;
h=0.35;
sigmah=0.014;
z=randn(1,1000);
Av=zeros(1,1000);
Iv=zeros(1,1000);
for i=1:1000
    bv=b+z(i)*sigmab;
    hv=h+z(i)*sigmah;
    Av(i)=bv*hv;
    Iv(i)=bv*hv^3/12;
end

hist(Av,200)
mediaA=mean(Av)
despadA=std(Av)
mediaI=mean(Iv)
despadI=std(Iv)