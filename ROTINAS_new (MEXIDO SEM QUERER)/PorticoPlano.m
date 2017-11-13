function [MOMENTO, CORTANTE, NORMAL, VIGA, PILAR, DADOS, PAR, ELEMENTOS, TRANSX, TRANSZ, ROTACAO]=PorticoPlano(CORTANTE, MOMENTO, NORMAL, TRANSX, TRANSZ, ROTACAO, DADOS, PORTICO, ELEMENTOS, VIGA, PILAR, PAR, ESTRUTURAL, CARGASOLO)
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

global m

D=ESTRUTURAL.D;
s=size(D);
s=s(1);

% Essa rotina servirá para ajustar os coeficientes de mola do solo na
% região do encontro.
%[CS]=correctspring(PORTICO, D);

% 1 - CÁLCULO DO CARREGAMENTO DEVIDO AO PESO PRÓPRIO
[ELEMENTOS]=Calc_PesoProprio(PORTICO, ELEMENTOS, PAR, DADOS);

% 2 - PREENCHIMENTO DO MÓDULO DE ELASTICIDADE EM FUNÇÃO DO TIPO DE
% MATERIAL EM CADA ELEMENTO.
[ELEMENTOS]=Mod_Elast(PORTICO, ELEMENTOS, PAR, DADOS);

% 3 - PROCESSAMENTO DO PÓRTICO PLANO VIA MATLAB - análise linear
% Eu esqueci de substituir o valor de A e I por AV e IV. Por isso
% vou fazer isso agora e não vou trocar a numeração do item 3. Vai demorar
% muito e eu não tenho muito tempo disponível.
ELEMENTOS.A=ELEMENTOS.AV(:,:,m);
ELEMENTOS.I=ELEMENTOS.IV(:,:,m);

% 3.1a - Cálculo da matriz de rigidez da esturtura - alongamento da ponte
PORTICO.springsV=PORTICO.springsAlongV;
[KESTalong, gdle, ngl, KELEM, ROT]=rigidezALONG(PORTICO, ELEMENTOS, PAR, DADOS);
% 3.1a - Cálculo da matriz de rigidez da esturtura - encurtamento da ponte
PORTICO.springsV=PORTICO.springsEncurtV;
[KESTenc, gdle, ngl, KELEM, ROT]=rigidezENCURT(PORTICO, ELEMENTOS, DADOS);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ---------ATENÇÃO LEIA COM CALMA ANTES DE ME CHAMAR DE BURRO!!!!---------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A partir daqui começa uma gambiarra!!! É o seguinte, todas as cargas 
% aplicadas à estrutura eram consideradas simultâneamente e chamadas SC. 
% Porém, devido a dificuldade de avaliar a situação mais desfavorável, foi
% NEcessário criar diversas combinações de carga, o que levou à necessidade
% de criar combinações, todas com fator de segurança igual a  1. Assim, 
% serão feitos tr6es loops a fim de avaliar as seguintes situações:
% g=1 - Considera-se apenas a carga de protensão. Nessa primeira análise
% serão calculados os esforços iinternos e deslocamentos devido ao Peso
% próprio, deformação elástica de protensão, efeitos diferidos e variações
% de temperatura.
% g=2 - Considerar-se a apenas o empuxo de solo
% g=3 - Considerar-se-a apenas o trem tipo.
% Depos ajeita essa gambiarra para ficar um negócio bem feito, mas agora
% estou sem tempo!!!!!!!!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3.2 - Cálculo dos vetores de carga
for g=1:3
    if g==1
        CARGA.lixo=0;
        KEST=KESTenc;
        [Fpp, fepp, Fsc, fesc, FtempPOS, FtempNEG, fetempPOS, fetempNEG, Fcc, Fcs, fecc, fecs,...
        CARGA]=LOAD(PORTICO, ELEMENTOS, KEST, KELEM, ROT, gdle, ngl, CARGA, DADOS, PAR, VIGA, g);
        % 3.3 - Resolução do sistema de equações
        %--------------------------------------------------------- PESO PRÓPRIO    
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
        KEST=KESTalong;
        [cortante, momento, normal, transx, transz, rotacao]=esfinternos(PORTICO, ELEMENTOS, KEST, KELEM,...
            ROT, F, fe, gdle, CARREGAMENTO, D);
        % Preenchimento das "structures" contendo os valores dos esforços
        % internos
        NORMAL.PP(:,:,m)=normal;
        CORTANTE.PP(:,:,m)=cortante;
        MOMENTO.PP(:,:,m)=momento;
        TRANSX.PP(:,:,m)=transx;
        TRANSZ.PP(:,:,m)=transz;
        ROTACAO.PP(:,:,m)=rotacao;

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
        KEST=KESTenc;
        [cortante, momento, normal, transx, transz, rotacao]=esfinternos(PORTICO, ELEMENTOS, KEST, KELEM,...
            ROT, F, fe, gdle, CARREGAMENTO, D);
        % Preenchimento das "structures"
        NORMAL.PROT(:,:,m)=normal;
        CORTANTE.PROT(:,:,m)=cortante;
        MOMENTO.PROT(:,:,m)=momento;
        TRANSX.PROT(:,:,m)=transx;
        TRANSZ.PROT(:,:,m)=transz;
        ROTACAO.PROT(:,:,m)=rotacao;
        %-------------------------------------------- EFEITOS DIFERIDOS DO CONCRETO    
        % Esforços de engastamento perfeito
        F=Fcc+Fcs;      % <-- Esf. de engastamento perfeito estrutura ref. global
        fe=fecc+fecs;   % <-- Esf. de engastamento perfeito estrutura ref. local
        % Calcula os esforços internos
        KEST=KESTenc;
        if DADOS.op_time==1
            [cortante, momento, normal, transx, transz, rotacao]=esfinternos(PORTICO, ELEMENTOS, KEST, KELEM,...
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
        NORMAL.NTD(:,:,m)=normal;
        CORTANTE.VTD(:,:,m)=cortante;
        MOMENTO.MTD(:,:,m)=momento;
        TRANSX.TD(:,:,m)=transx;
        TRANSZ.TD(:,:,m)=transz;
        ROTACAO.TD(:,:,m)=rotacao;
        %--------------------------------- EFEITOS VARIAÇÃO POSITIVA DE TEMPERATURA   
        % Esforços de engastamento perfeito
        F=FtempPOS;      % <-- Esf. de engastamento perfeito estrutura ref. global
        fe=fetempPOS;   % <-- Esf. de engastamento perfeito estrutura ref. local
        % Criação do vetor de carga - seleciona o carregamento proveniente da
        % SC na estrutura
        CARREGAMENTO.qy=0*CARGA.SCqy;
        CARREGAMENTO.qx=0*CARGA.SCqx;
        CARREGAMENTO.Px=0*CARGA.SCPx;
        CARREGAMENTO.a=0*CARGA.SCa;
        CARREGAMENTO.Py=0*CARGA.SCPy;
        CARREGAMENTO.b=0*CARGA.SCb;
        % Calcula os esforços internos
        KEST=KESTalong;
        if DADOS.op_temp==1
            [cortante, momento, normal, transx, transz, rotacao]=esfinternos(PORTICO, ELEMENTOS, KEST, KELEM,...
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
        NORMAL.NTempPOS(:,:,m)=normal;
        CORTANTE.VTempPOS(:,:,m)=cortante;
        MOMENTO.MTempPOS(:,:,m)=momento;
        TRANSX.TempPOS(:,:,m)=transx;
        TRANSZ.TempPOS(:,:,m)=transz;
        ROTACAO.TempPOS(:,:,m)=rotacao;
        %--------------------------------- EFEITOS VARIAÇÃO NEGATIVA DE TEMPERATURA     
        % Esforços de engastamento perfeito
        F=FtempNEG;     % <-- Esf. de engastamento perfeito estrutura ref. global
        fe=fetempNEG;   % <-- Esf. de engastamento perfeito estrutura ref. local
        % Calcula os esforços internos
        KEST=KESTenc;
        if DADOS.op_temp==1
            [cortante, momento, normal, transx, transz, rotacao]=esfinternos(PORTICO, ELEMENTOS, KEST, KELEM,...
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
        NORMAL.NTempNEG(:,:,m)=normal;
        CORTANTE.VTempNEG(:,:,m)=cortante;
        MOMENTO.MTempNEG(:,:,m)=momento;
        TRANSX.TempNEG(:,:,m)=transx;
        TRANSZ.TempNEG(:,:,m)=transz;
        ROTACAO.TempNEG(:,:,m)=rotacao;
    elseif g==2
        % Empuxo de solo
        [Fpp, fepp, Fsc, fesc, FtempPOS, FtempNEG, fetempPOS, fetempNEG, Fcc, Fcs, fecc, fecs...
    CARGA]=LOAD(PORTICO, ELEMENTOS, KEST, KELEM, ROT, gdle, ngl, CARGA, DADOS, PAR, VIGA, g, CARGASOLO);
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
        KEST=KESTenc;
        [cortante, momento, normal, transx, transz, rotacao]=esfinternos(PORTICO, ELEMENTOS, KEST, KELEM,...
            ROT, F, fe, gdle, CARREGAMENTO, D);
        % Preenchimento das "structures"
        NORMAL.EMPSOLO(:,:,m)=normal;
        CORTANTE.EMPSOLO(:,:,m)=cortante;
        MOMENTO.EMPSOLO(:,:,m)=momento;
        TRANSX.EMPSOLO(:,:,m)=transx;
        TRANSZ.EMPSOLO(:,:,m)=transz;
        ROTACAO.EMPSOLO(:,:,m)=rotacao;
        
    elseif g==3
        % TREM TIPO
        [Fpp, fepp, Fsc, fesc, FtempPOS, FtempNEG, fetempPOS, fetempNEG, Fcc, Fcs, fecc, fecs,...
        CARGA]=LOAD(PORTICO, ELEMENTOS, KEST, KELEM, ROT, gdle, ngl, CARGA, DADOS, PAR, VIGA, g);
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
        KEST=KESTalong;
        [cortante, momento, normal, transx, transz, rotacao]=esfinternos(PORTICO, ELEMENTOS, KEST, KELEM,...
            ROT, F, fe, gdle, CARREGAMENTO, D);
        % Preenchimento das "structures"
        NORMAL.TREMTIPO(:,:,m)=normal;
        CORTANTE.TREMTIPO(:,:,m)=cortante;
        MOMENTO.TREMTIPO(:,:,m)=momento;
        TRANSX.TREMTIPO(:,:,m)=transx;
        TRANSZ.TREMTIPO(:,:,m)=transz;
        ROTACAO.TREMTIPO(:,:,m)=rotacao;
    end
end
%----------------------------------------------------------- VALORES TOTAIS    
fclose all;



% %     % Esforços internos
% s=size(D);
% s=s(1);
% for i=1:s
%     CORTANTE.TOTAL{i,:,m}=CORTANTE.PP{i,:,m}+CORTANTE.SC{i,:,m}+CORTANTE.VTD{i,:,m};
%     MOMENTO.TOTAL{i,:,m}=MOMENTO.PP{i,:,m}+MOMENTO.SC{i,:,m}+MOMENTO.MTD{i,:,m};
%     NORMAL.TOTAL{i,:,m}=NORMAL.PP{i,:,m}+NORMAL.SC{i,:,m}+NORMAL.NTD{i,:,m};
%     TRANSX.TOTAL{i,:,m}=TRANSX.PP{i,:,m}+TRANSX.SC{i,:,m}+TRANSX.TD{i,:,m};
%     TRANSZ.TOTAL{i,:,m}=TRANSZ.PP{i,:,m}+TRANSZ.SC{i,:,m}+TRANSZ.TD{i,:,m};
%     ROTACAO.TOTAL{i,:,m}=ROTACAO.PP{i,:,m}+ROTACAO.SC{i,:,m}+ROTACAO.TD{i,:,m};
% end
