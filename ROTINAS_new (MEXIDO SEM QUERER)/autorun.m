% -------------------------------------------------------------------------
% Rotina criada para automatizar a análise de todos os pórtico planos a
% serem avaliados variando o valor do número de Monnte Carlo
%
tic
clc
clear variables global

% Variável global que irá variar a "rodada",ou seja o nome do arquivo. Em
% cada rodada um conjunto de arquivos de entrada diferentes serão lidos de
% forma que apenas uma das variáveis de projeto será tratada como uma
% variável aleatória.
global J

% Variável global que irá variar o número de Monte Carlo. Cada rodada será
% processada 7 vezes onde em cada uma delas o número de Monte Carlo irá
% variar em 100, 500, 1000, 5000, 10.000, 20.000 e 50.000. A idéia é
% avaliar qual o menor valor de NMC que pode ser utilizado sem perda da
% precisão estatística da análise.
global I

% Variável global contendo os valores do NMC
global v
%v=[5];
v=[100 500 1000 5000 10000];

% Variáveis globais - nome dos arquivos
global nomearquivoinput nomearquivodadosconc nomearquivodadosconcTD
global nomearquivodadosaco nomearquivodadossteel nomearquivodadoseco nomearquivo
global nomearquivoTremTipo nomearquivoEmpSolo

for J=15:15
    rod=num2str(J);
    nomearquivoinput=['ROD-',rod,'-Prot-PortINPUTponte1.txt'];
    nomearquivodadosconc=['ROD-',rod,'-parconc.txt'];
    nomearquivodadosconcTD=['ROD-',rod,'-parconcTD.txt'];
    nomearquivodadosaco=['ROD-',rod,'-paraco.txt'];
    nomearquivodadossteel=['ROD-',rod,'-parsteel.txt'];
    nomearquivodadoseco=['ROD-',rod,'-pareco.txt'];
    nomearquivoTremTipo=['ROD-',rod,'-TREMTIPO-PortINPUTponte1.txt'];
    nomearquivoEmpSolo=['ROD-',rod,'-rEMPSOLO-PortINPUTponte1.txt'];
    
    s=size(v);
    s=s(2);

    for I=1:s
        nmc=num2str(v(I));
        nomearquivo=['Ponte1_ROD-',rod,'-NMC=',nmc,];
    %     clc
    %     clear variables global
        Fprincipalautorun
    end
end
toc
    