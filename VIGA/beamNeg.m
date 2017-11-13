function [VIGAresult]=beamNeg(VIGAin, VIGA, NUMVIGAS, VIGAresult)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCIÊNCIAS
% PROGRAMA DE PÓS-GRADUAÇÃO EM ENGENHARIA CIVIL        - ÁREA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELEÇÃO DE  MÉDIA FIDELIDADE  PARA  ANÁLISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO.
% ALUNO       Sérgio José Priori Jovino Marques Filho
% ORIENTADOR  Prof. Ézio da Rocha Araújo
% -------------------------------------------------------------------------
% DESCRIÇÃO
% Rotina que gerencia o dimensionamento das armaduras negativas da viga.
% -------------------------------------------------------------------------
% MODIFICAÇÕES:         
%--------------------------------------------------------------------------
% VARIÁVEIS DE ENTRADA: VIGAin, VIGA, NUMVIGAS, VIGAresult
% VARIÁVEIS DE SAÍDA:   VIGAresult 
%--------------------------------------------------------------------------
% CRIADA EM 21-fevereiro-2016
% -------------------------------------------------------------------------

%FAB - Remoção de variável global sem uso.
%global m

%disp('    ->Dimensionamento da armadura negativa')
% Vetor nulo para abrigar o maior comprimento das barra do arranjo negativo.
% Esse vetor tem duas colunas pois a viga pode tar até dois trechos de com 
% MF negativo. Essa variável será utilizada na rotina beam6.
COMPneg=zeros(1,2);     

for trecho=1:VIGAin.qnttrechosneg % PERCORRE TRECHOS COM MF<0
    disp(['    Trecho ',num2str(trecho),' de ',num2str(VIGAin.qnttrechosneg)])
    M=VIGAin.NEG(trecho,:);
    M=sort(M);

    % REMOVE OS ZEROS DO VETOR M
    M=beamRemoveZeros(M);

    % CÁLCULO DA QNT DE SEÇÕES NO TRECHO DE MOMENTO FLETOR NEGATIVO
    s=size(M);
    VIGAin.numsecoestrechoneg(trecho)=s(2);
    
    % CRIAÇÃO DE UMA SÉRIE DE VETORES NULOS A SEREM PREENCHIDOS EM SEGUIDA
    % Vetor contendo as áreas de aço calculadas, superior e inferior
    AsCalculadoSup=zeros(1,VIGAin.numsecoestrechoneg(trecho));
    AsCalculadoInf=zeros(1,VIGAin.numsecoestrechoneg(trecho));
    % Vetor contendo os comprimentos de decalgem do DMF
    al=zeros(VIGAin.qntbitolaslong,1);
    % Vetor contendo os arranjos de armadura, superior e inferior
    ARRANJOLONGsup=zeros(VIGAin.numsecoestrechoneg(trecho),2);
    ARRANJOLONGinf=zeros(VIGAin.numsecoestrechoneg(trecho),2);
    % Matriz nula para conter os valores de dinf
    VIGAin.dinf=VIGAin.dinfinicial*ones(VIGAin.qntbitolaslong,VIGAin.numsecoestrechoneg(trecho));
    
    % Inicialização do valor do tag
    tag=1;
    % PERCORRE AS BITOLAS COMERCIAIS CADASTRADAS EM VIGASin.TABELA
    for bitola=1:VIGAin.qntbitolaslong
        if tag==1
            disp(['    Bitola ',num2str(VIGA.TABELALONG(bitola))])
            tag=0;
            if tag==0
                %FAB - Remoção de variável sem uso.
                %diambarra=VIGA.TABELALONG(bitola)/1000;
                posbitolatrac=bitola;
                posbitolacomp=bitola;
                tag=0; % Tag para definir se a seção será dimensionada
                if tag==0
                    for sec=1:VIGAin.numsecoestrechoneg(trecho) % PERCORRE AS SEÇÕES CONTIDAS NO TRECHO EM QUESTÃO
                        if tag==0
                            disp(['      Seção ',num2str(sec),' de ',num2str(VIGAin.numsecoestrechoneg(trecho))])
                            d1=VIGAin.dinf(bitola,sec);
                            d2=0;
                            momento=M(sec);           
                            % O "while" foi inserido de forma que a altura útil estimada,
                            % VIGAin.dinf seja igual a altura útil real "VIGAin.h-YcgTrac".
                            % Portanto após a primeira iteração será calculada altura útil
                            % real, essa será utilizada para uma nova iteração até que a
                            % igualdade ocorra.
                            while d1~=d2
                                % Dimensionamento da seção à flexão - beam0.m
                                [Astrac, Ascomp]=beam0(momento, VIGAin, sec, bitola);
                                % Escolha do arranjo da armadura - beam1.m
                                [ARRANJOtrac, ARRANJOcomp]=beam1(Astrac, Ascomp, VIGA, posbitolatrac, posbitolacomp);
                                % Distribuição das barras em camadas e cálculo do
                                % CG das barras de aço - beam2.m
                                [YcgTrac, difTrac]=beam2(ARRANJOtrac, VIGAin);
                                % Atualização da altura útil da viga                   
                                d1=VIGAin.dinf(bitola,sec);
                                d2=VIGAin.h-YcgTrac;
                                VIGAin.dinf(bitola, sec)=d2;
                            end
                            % Verificação de a difrença entre o CG da barras e a
                            % extremidade da barra mais externa é infeior a 10% da
                            % altura da seção
                            if difTrac<0.1*VIGAin.h
                                % Posicionamento da armadura na seção da viga 
                                AsCalculadoSup(sec)=Astrac;
                                ARRANJOLONGsup(sec, 1)=ARRANJOtrac(1);
                                ARRANJOLONGsup(sec, 2)=ARRANJOtrac(2);
                                AsCalculadoInf(sec)=Ascomp;
                                ARRANJOLONGinf(sec, 1)=ARRANJOcomp(1);
                                ARRANJOLONGinf(sec, 2)=ARRANJOcomp(2);
                                tag=0;
                                disp('      OK - Passa')
                            else
                                tag=1;
                                disp('      NÃO PASSA!!!')
                            end                    
                        end
                    end
                end
            if tag==0
                % Cálculo da decalagem do DMF da viga - beam3.m
                disp('    Cálculo da decalagem do DMF - região com MF negativo')
                [al]=beam3(VIGAin, bitola);

                % Cálculo do comprimento de ancoragem, vante e ré - beam5.m
                disp('    Cálculo dos comprimentos de ancoragem das barras negativas')
                [lbnecVante, lbnecRe]=beam5(VIGAin, AsCalculadoSup ,ARRANJOLONGsup);
            end
            end
        end
    end % <-- Aqui a rotina termina de "varrer" todas as bitolas comerciais

    % Cálculo do comprimento e peso final das barras do arranjo negativo e armadura de montagem -
    % beam6.m
    disp('    Cálculo do peso de aço referente às armaduras negatvas')
    [VIGAresult, COMPneg]=beam6(VIGAin, ARRANJOLONGsup, trecho, lbnecVante, lbnecRe, al, NUMVIGAS, VIGAresult, COMPneg);

end

% Cálculo da armadura de montagem - será considerado para armadura de
% montagem duas barras de 5.0.
Lmontagem=VIGAin.COMPRIMENTO(NUMVIGAS)-2*(sum(COMPneg(trecho))-lbnecRe-8*ARRANJOLONGsup(1,2)/1000);
% A multiplicação por cem serve para transormar a unidade de kN (unidade
% utilizada no arquivos de input) para kgf, unidade mais fácil de assimilar
% como output.
VIGAresult.PESOmontagem(NUMVIGAS)=Lmontagem*2*(pi*0.005^2/4)*VIGAin.roaco*100;
