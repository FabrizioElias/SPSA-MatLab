% -------------------------------------------------------------------------
% Rotina criada para automatizar a an�lise de todos os p�rtico planos a
% serem avaliados variando o valor do n�mero de Monnte Carlo
%
tic
clc
clear variables global

% Vari�vel global que ir� variar a "rodada",ou seja o nome do arquivo. Em
% cada rodada um conjunto de arquivos de entrada diferentes ser�o lidos de
% forma que apenas uma das vari�veis de projeto ser� tratada como uma
% vari�vel aleat�ria.
global J

% Vari�vel global que ir� variar o n�mero de Monte Carlo. Cada rodada ser�
% processada 7 vezes onde em cada uma delas o n�mero de Monte Carlo ir�
% variar em 100, 500, 1000, 5000, 10.000, 20.000 e 50.000. A id�ia �
% avaliar qual o menor valor de NMC que pode ser utilizado sem perda da
% precis�o estat�stica da an�lise.
global I

% Vari�vel global contendo os valores do NMC
global v
%v=[5];
v=[100 500 1000 5000 10000];

% Vari�veis globais - nome dos arquivos
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
    