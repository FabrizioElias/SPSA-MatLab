function [PILAR]=plotdiag(PILAR, COMBColumn)
%P=PILAR.Pn;
P=PILAR.NIn;
%M=PILAR.Mn;
M=PILAR.MIn;
%plot(M,P,'-ro','LineWidth',5','MarkerSize',10)
plot(M,P,'-ro','LineWidth',5')
%plot(M,P)
hold on