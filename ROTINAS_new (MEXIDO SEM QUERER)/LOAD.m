function [Fpp, fepp, Fsc, fesc, FtempPOS, FtempNEG, fetempPOS, fetempNEG, Fcc, Fcs, fecc, fecs...
    CARGA]=LOAD(PORTICO, ELEMENTOS, KEST, KELEM, ROT, gdle, ngl, CARGA, DADOS, PAR, VIGA, g, CARGASOLO)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIENCIAS
% PROGRAMA DE POS-GRADUACAO EM ENGENHARIA CIVIL        - AREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELECAO DE  MEDIA FIDELIDADE  PARA  ANALISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO
% ALUNA       Sérgio José Priori Jovino Marques Filho
% ORIENTADOR  Prof. Ezio da Rocha Araujo
% -------------------------------------------------------------------------
% DESCRICAO
% Rotina para calculo dos vetores de carga
% -------------------------------------------------------------------------
% Criada      01-fevereiro-2016                 SÉRGIO MARQUES
% -------------------------------------------------------------------------
global nomearquivoTremTipo nomearquivoEmpSolo

if g==1
    % VETOR DE CARGA DEVIDO AO PESO PRÓPRIO DA ESTRUTURA
    [Fpp, fepp, CARGA]=loadPP(PORTICO, ELEMENTOS, ROT, gdle, ngl, CARGA);

    % VETOR DE CARGA DEVIDO À SOBRECARGA ATUANTE NA ESTRUTURA
    [Fsc, fesc, CARGA]=loadSC(PORTICO, ROT, gdle, ngl, CARGA);

    % VETOR DE CARGA DEVIDO AOS EFEITOS DIFERIDOS DO CONCRETO
    % efnormal é uma adaptação da rotina PorticoPlano que serve apenas para o
    % cálculo no esforço noral no pórtico
    if DADOS.op_time==1
        % Calcula o esforço normal no pórtico, análise elástica linear
        [N]=esfnormal(PORTICO, ELEMENTOS, KEST, KELEM, ROT, Fsc, fesc, Fpp, fepp, gdle, CARGA);
        % Cálculo das deformações por retração e fluência
        [Fcc, Fcs, fecc, fecs]=timedependet(PAR, PORTICO, ELEMENTOS, VIGA, N, DADOS, ngl, gdle, ROT);
    else
        Fcc=zeros(1,ngl);
        Fcs=zeros(1,ngl);
        fecc=zeros(6,PORTICO.nelem);
        fecs=zeros(6,PORTICO.nelem);
    end

    % VETOR DE CARGA DEVIDO À VARIAÇÃO UNIFORME DE TEMPERATURA
    if DADOS.op_temp==1             % <-- Considera os efeitos térmicos
        [FtempPOS, FtempNEG, fetempPOS, fetempNEG]=temperature(PAR, PORTICO, ELEMENTOS, VIGA, ngl, ROT, gdle);
    else
        FtempPOS=zeros(1,ngl);
        FtempNEG=zeros(1,ngl);
        fetempPOS=zeros(6,PORTICO.nelem);
        fetempNEG=zeros(6,PORTICO.nelem);
    end
elseif g==2
    % Empuxo do solo
    arquivoinput=(nomearquivoEmpSolo);
    [PORTICO]=Le_DadosGAMB(DADOS, arquivoinput, PORTICO);
    % VETOR DE CARGA DEVIDO À SOBRECARGA ATUANTE NA ESTRUTURA
    [Fsc, fesc, CARGA]=loadSCsolo(PORTICO, ROT, gdle, ngl, CARGA, CARGASOLO);
    Fpp=0;
    fepp=0;
    FtempPOS=0;
    FtempNEG=0;
    fetempPOS=0;
    fetempNEG=0;
    Fcc=0;
    Fcs=0;
    fecc=0;
    fecs=0;
elseif g==3
    % Trem Tipo
    arquivoinput=(nomearquivoTremTipo);
    [PORTICO]=Le_DadosGAMB(DADOS, arquivoinput, PORTICO);
    % VETOR DE CARGA DEVIDO À SOBRECARGA ATUANTE NA ESTRUTURA
    [Fsc, fesc, CARGA]=loadSC(PORTICO, ROT, gdle, ngl, CARGA);
    Fpp=0;
    fepp=0;
    FtempPOS=0;
    FtempNEG=0;
    fetempPOS=0;
    fetempNEG=0;
    Fcc=0;
    Fcs=0;
    fecc=0;
    fecs=0;
    
end
