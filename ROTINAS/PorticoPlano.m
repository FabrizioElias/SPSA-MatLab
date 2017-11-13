function [MOMENTO, CORTANTE, NORMAL, VIGA, PILAR, DADOS, PAR, ELEMENTOS, TRANSX, TRANSZ, ROTACAO]=PorticoPlano(DADOS, PORTICO, ELEMENTOS, VIGA, PILAR, PAR, ESTRUTURAL)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIÊNCIAS
% PROGRAMA DE PÓS-GRADUAÇÃO EM ENGENHARIA CIVIL        - ÁREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELEÇÃO DE  MÉDIA FIDELIDADE  PARA  ANÁLISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO.
% ALUNA       Sérgio José Priori Jovino Marques Filho
% ORIENTADOR  Prof. Ézio da Rocha Araújo
% -------------------------------------------------------------------------
% DESCRIÇÃO
% Rotina para cálculo do esforço normal nos elementos estruturais
% -------------------------------------------------------------------------
% MODIFICAÇÕES:         Modificada em 16/05/2015
%--------------------------------------------------------------------------
% VARIÁVEIS DE ENTRADA: PORTICO, ELEMENTOS, DADOS
% VARIÁVEIS DE SAÍDA:   esf: esforços nodais obtidos à partir do método dos
%                       deslocamentos
%                       CORTANTE, MOMENTO: esforços internos nos elementos
%                       do pórtico.
%--------------------------------------------------------------------------
% CRIADA EM 13-Janeiro-2015
% -------------------------------------------------------------------------

% [D, ELEMPILAR, ELEMVIGA]=reorder(PORTICO, VIGA);
D=ESTRUTURAL.D;
s=size(D);
s=s(1);

% % 2.0.1 - CLASSIFICAÇÃO DOS ELEMENTOS
%      [VIGA, PILAR, DADOS]=Classifica_elem(DADOS, PORTICO, ELEMENTOS, VIGA, PILAR);
    
% 2.0.2 - CÁLCULO DAS PROPRIEDADES GEOMÉTRICAS
    % Cálculo das propriedades da seção transversal dos elementos
    %FAB - Remoção de variáveis sem uso.
    %[ELEMENTOS]=Calc_geom(PORTICO, ELEMENTOS, PAR, DADOS);
    [ELEMENTOS]=Calc_geom(PORTICO, ELEMENTOS);
    
% 2.0.3 - CÁLCULO DO CARREGAMENTO DEVIDO AO PESO PRÓPRIO
    %FAB - Remoção de variáveis sem uso
    %[ELEMENTOS]=Calc_PesoProprio(PORTICO, ELEMENTOS, PAR, DADOS);
    [ELEMENTOS]=Calc_PesoProprio(PORTICO, ELEMENTOS, PAR);
    
% 2.0.4 - PREENCHIMENTO DO MÓDULO DE ELASTICIDADE EM FUNÇÃO DO TIPO DE
% MATERIAL EM CADA ELEMENTO
    [ELEMENTOS]=Mod_Elast(PORTICO, ELEMENTOS, PAR, DADOS);

% 2.0.5 - PROCESSAMENTO DO PÓRTICO PLANO VIA MATLAB - análise linear
    % 2.0.5.1 - Cálculo da matriz de rigidez da esturtura
    [KEST, gdle, ngl, KELEM, ROT]=rigidez(PORTICO, ELEMENTOS, PAR, DADOS);    
    % 2.0.5.2 - Cálculo dos vetores de carga
    CARGA.lixo=0;
    [Fpp, fepp, Fsc, fesc, FtempPOS, FtempNEG, fetempPOS, fetempNEG, Fcc, Fcs, fecc, fecs,...
    CARGA]=LOAD(PORTICO, ELEMENTOS, KEST, KELEM, ROT, gdle, ngl, CARGA, DADOS, PAR, VIGA);
    % 2.0.5.3 - Resolução do sistema de equações
    % Criação de matrizes nulas para armazenar os esforços internos
    [CORTANTE, MOMENTO, NORMAL, TRANSX, TRANSZ, ROTACAO]=null(D);
%------------------------------------------------------------- PESO PRÓPRIO    
    % Esforços de engastamento perfeito
    F=Fpp;      % <-- Esf. de engastamento perfeito estrutura ref. global
    fe=fepp;    % <-- Esf. de engastamento perfeito estrutura ref. local
    % Criação do vetor de carga - seleciona o carregamento proveniente do
    % PP da estrutura
    CARREGAMENTO.qy=CARGA.PPqy;
    CARREGAMENTO.qx=CARGA.PPqx;
    CARREGAMENTO.Px=zeros(1, PORTICO.nelem);
    CARREGAMENTO.a=zeros(1, PORTICO.nelem);
    CARREGAMENTO.Py=zeros(1, PORTICO.nelem);
    CARREGAMENTO.b=zeros(1, PORTICO.nelem);
    % Calcula os esforços internos
    [cortante, momento, normal, transx, transz, rotacao]=esfinternos(PORTICO, ELEMENTOS, KEST, KELEM,...
        ROT, F, fe, gdle, CARREGAMENTO, D);
    % Preenchimento das "structures" contendo os valores dos esforços
    % internos
    NORMAL.PP=normal;
    CORTANTE.PP=cortante;
    MOMENTO.PP=momento;
    TRANSX.PP=transx;
    TRANSZ.PP=transz;
    ROTACAO.PP=rotacao;
    
%--------------------------------------------------------------- SOBRECARGA    
    % Esforços de engastamento perfeito
    F=Fsc;      % <-- Esf. de engastamento perfeito estrutura ref. global
    fe=fesc;    % <-- Esf. de engastamento perfeito estrutura ref. local
    % Criação do vetor de carga - seleciona o carregamento proveniente da
    % SC na estrutura
    CARREGAMENTO.qy=CARGA.SCqy;
    CARREGAMENTO.qx=CARGA.SCqx;
    CARREGAMENTO.Px=CARGA.SCPx;
    CARREGAMENTO.a=CARGA.SCa;
    CARREGAMENTO.Py=CARGA.SCPy;
    CARREGAMENTO.b=CARGA.SCb;
    % Calcula os esforços internos
    [cortante, momento, normal]=esfinternos(PORTICO, ELEMENTOS, KEST, KELEM,...
        ROT, F, fe, gdle, CARREGAMENTO, D);
    % Preenchimento das "structures"
    NORMAL.SC=normal;
    CORTANTE.SC=cortante;
    MOMENTO.SC=momento;
    TRANSX.SC=transx;
    TRANSZ.SC=transz;
    ROTACAO.SC=rotacao;
%-------------------------------------------- EFEITOS DIFERIDOS DO CONCRETO    
    % Esforços de engastamento perfeito
    F=Fcc+Fcs;      % <-- Esf. de engastamento perfeito estrutura ref. global
    fe=fecc+fecs;   % <-- Esf. de engastamento perfeito estrutura ref. local
    % Calcula os esforços internos
    if DADOS.op_time==1
        [cortante, momento, normal]=esfinternos(PORTICO, ELEMENTOS, KEST, KELEM,...
            ROT, F, fe, gdle, CARREGAMENTO, D);
    else
        normal=cell(s,1);
        cortante=cell(s,1);
        momento=cell(s,1);
        for i=1:s
            normal{i,1}=zeros(1,D(i,2)-D(i,1)+2);
            cortante{i,1}=zeros(1,D(i,2)-D(i,1)+2);
            momento{i,1}=zeros(1,D(i,2)-D(i,1)+2);
        end  
    end     
    NORMAL.NTD=normal;
    CORTANTE.VTD=cortante;
    MOMENTO.MTD=momento;
    TRANSX.TD=transx;
    TRANSZ.TD=transz;
    ROTACAO.TD=rotacao;
%--------------------------------- EFEITOS VARIAÇÃO POSITIVA DE TEMPERATURA   
    % Esforços de engastamento perfeito
    F=FtempPOS;      % <-- Esf. de engastamento perfeito estrutura ref. global
    fe=fetempPOS;   % <-- Esf. de engastamento perfeito estrutura ref. local
    % Calcula os esforços internos
    if DADOS.op_temp==1
        [cortante, momento, normal]=esfinternos(PORTICO, ELEMENTOS, KEST, KELEM,...
            ROT, F, fe, gdle, CARREGAMENTO, D);
    else
        normal=cell(s,1);
        cortante=cell(s,1);
        momento=cell(s,1);
        for i=1:s
            normal{i,1}=zeros(1,D(i,2)-D(i,1)+2);
            cortante{i,1}=zeros(1,D(i,2)-D(i,1)+2);
            momento{i,1}=zeros(1,D(i,2)-D(i,1)+2);
        end 
    end
    NORMAL.NTempPOS=normal;
    CORTANTE.VTempPOS=cortante;
    MOMENTO.MTempPOS=momento;
    TRANSX.TempPOS=transx;
    TRANSZ.TempPOS=transz;
    ROTACAO.TempPOS=rotacao;
%--------------------------------- EFEITOS VARIAÇÃO NEGATIVA DE TEMPERATURA     
    % Esforços de engastamento perfeito
    F=FtempNEG;     % <-- Esf. de engastamento perfeito estrutura ref. global
    fe=fetempNEG;   % <-- Esf. de engastamento perfeito estrutura ref. local
    % Calcula os esforços internos
    if DADOS.op_temp==1
        [cortante, momento, normal]=esfinternos(PORTICO, ELEMENTOS, KEST, KELEM,...
            ROT, F, fe, gdle, CARREGAMENTO, D);
    else
        normal=cell(s,1);
        cortante=cell(s,1);
        momento=cell(s,1);
        for i=1:s
            normal{i,1}=zeros(1,D(i,2)-D(i,1)+2);
            cortante{i,1}=zeros(1,D(i,2)-D(i,1)+2);
            momento{i,1}=zeros(1,D(i,2)-D(i,1)+2);
        end 
    end
    NORMAL.NTempNEG=normal;
    CORTANTE.VTempNEG=cortante;
    MOMENTO.MTempNEG=momento;
    TRANSX.TempNEG=transx;
    TRANSZ.TempNEG=transz;
    ROTACAO.TempNEG=rotacao;
%----------------------------------------------------------- VALORES TOTAIS     
    % Esforços internos
    s=size(D);
    for i=1:s(1)
        CORTANTE.TOTAL{i,:}=CORTANTE.PP{i,:}+CORTANTE.SC{i,:}+CORTANTE.VTD{i,:};
        MOMENTO.TOTAL{i,:}=MOMENTO.PP{i,:}+MOMENTO.SC{i,:}+MOMENTO.MTD{i,:};
        NORMAL.TOTAL{i,:}=NORMAL.PP{i,:}+NORMAL.SC{i,:}+NORMAL.NTD{i,:};
        TRANSX.TOTAL{i,:}=TRANSX.PP{i,:}+TRANSX.SC{i,:}+TRANSX.TD{i,:};
        TRANSZ.TOTAL{i,:}=TRANSZ.PP{i,:}+TRANSZ.SC{i,:}+TRANSZ.TD{i,:};
        ROTACAO.TOTAL{i,:}=ROTACAO.PP{i,:}+ROTACAO.SC{i,:}+ROTACAO.TD{i,:};
    end