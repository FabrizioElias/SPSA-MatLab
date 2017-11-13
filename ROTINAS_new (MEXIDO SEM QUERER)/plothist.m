%function plothist(text, v, I)
clear all
clc
text='EST-Haavistonjoki_ROD-4-NMC=1000.mat';
NMC=10000;
I=NMC;
load(text)
textotitulo=(['NMC ',num2str(I)]);
%Custos
costcolumn=COST.CPA+COST.CPC+COST.CPF;
costbeam=COST.CVA+COST.CVC+COST.CVF;
C=[COST.total, costcolumn, costbeam];

% Histograma do custo total da estrutura
hist(COST.total,200)
grid on
box on

title(['Histograma - Custo total da estrutura - ',textotitulo])
arqgrafico=(['CUSTO ESTRUTURA_NMC ',num2str(I),'.bmp']);
saveas(gcf,arqgrafico)
mediaTotal=mean(COST.total);
despadTotal=std(COST.total);

% Histograma do custo dos pilares
costcolumn=COST.CPA+COST.CPC+COST.CPF;
figure
hist(costcolumn,200)
grid on
box on
title(['Histograma - Custo total dos pilares - ',textotitulo])
arqgrafico=(['CUSTO PILARES_NMC ',num2str(I),'.bmp']);
saveas(gcf,arqgrafico)
mediaPil=mean(costcolumn);
despadPil=std(costcolumn);

% Histograma do custo das vigas
figure
hist(costbeam,200)
grid on
box on
title(['Histograma - Custo total das vigas - ',textotitulo])
arqgrafico=(['CUSTO VIGAS_NMC ',num2str(I),'.bmp']);
saveas(gcf,arqgrafico)
mediaVig=mean(costbeam);
despadVig=std(costbeam);

% Cria arquivo para escrever os parâmetros estatísticos da análise
arqtexto=(['ParametrosEstatísticos ',num2str(I),'.txt']);
[tmp, msg] = fopen(arqtexto, 'w');
fprintf(tmp, '%s\n', text);
fprintf(tmp, 'Custo médio da estrutura ');
fprintf(tmp, '%s\n', mediaTotal);
fprintf(tmp, 'Desvio padrão do custo médio da estrutura ');
fprintf(tmp, '%s\n', despadTotal);

fprintf(tmp, 'Custo médio da das vigas ');
fprintf(tmp, '%s\n', mediaVig);
fprintf(tmp, 'Desvio padrão do custo médio das vigas ');
fprintf(tmp, '%s\n', despadVig);

fprintf(tmp, 'Custo médio das Pilares ');
fprintf(tmp, '%s\n', mediaPil);
fprintf(tmp, 'Desvio padrão do custo médio das Pilares ');
fprintf(tmp, '%s\n', despadPil);