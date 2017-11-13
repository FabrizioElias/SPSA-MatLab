function [VIGAresult]=beamNeg(VIGAin, VIGA, NUMVIGAS, VIGAresult)
% -------------------------------------------------------------------------
% UNIVERSIDADE FEDERAL DE PERNAMBUCO   - CENTRO DE TECNOLOGIA E GEOCI�NCIAS
% PROGRAMA DE P�S-GRADUA��O EM ENGENHARIA CIVIL        - �REA DE ESTRUTURAS
%
% TESE DE DOUTORADO
% MODELOS  DE SELE��O DE  M�DIA FIDELIDADE  PARA  AN�LISE DE  INCERTEZAS EM
% ESTRUTURAS DE CONCRETO ARMADO.
% ALUNO       S�rgio Jos� Priori Jovino Marques Filho
% ORIENTADOR  Prof. �zio da Rocha Ara�jo
% -------------------------------------------------------------------------
% DESCRI��O
% Rotina que gerencia o dimensionamento das armaduras negativas da viga.
% -------------------------------------------------------------------------
% MODIFICA��ES:         
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: VIGAin, VIGA, NUMVIGAS, VIGAresult
% VARI�VEIS DE SA�DA:   VIGAresult 
%--------------------------------------------------------------------------
% CRIADA EM 21-fevereiro-2016
% -------------------------------------------------------------------------

%FAB - Remo��o de vari�vel global sem uso.
%global m

%disp('    ->Dimensionamento da armadura negativa')
% Vetor nulo para abrigar o maior comprimento das barra do arranjo negativo.
% Esse vetor tem duas colunas pois a viga pode tar at� dois trechos de com 
% MF negativo. Essa vari�vel ser� utilizada na rotina beam6.
COMPneg=zeros(1,2);     

for trecho=1:VIGAin.qnttrechosneg % PERCORRE TRECHOS COM MF<0
    disp(['    Trecho ',num2str(trecho),' de ',num2str(VIGAin.qnttrechosneg)])
    M=VIGAin.NEG(trecho,:);
    M=sort(M);

    % REMOVE OS ZEROS DO VETOR M
    M=beamRemoveZeros(M);

    % C�LCULO DA QNT DE SE��ES NO TRECHO DE MOMENTO FLETOR NEGATIVO
    s=size(M);
    VIGAin.numsecoestrechoneg(trecho)=s(2);
    
    % CRIA��O DE UMA S�RIE DE VETORES NULOS A SEREM PREENCHIDOS EM SEGUIDA
    % Vetor contendo as �reas de a�o calculadas, superior e inferior
    AsCalculadoSup=zeros(1,VIGAin.numsecoestrechoneg(trecho));
    AsCalculadoInf=zeros(1,VIGAin.numsecoestrechoneg(trecho));
    % Vetor contendo os comprimentos de decalgem do DMF
    al=zeros(VIGAin.qntbitolaslong,1);
    % Vetor contendo os arranjos de armadura, superior e inferior
    ARRANJOLONGsup=zeros(VIGAin.numsecoestrechoneg(trecho),2);
    ARRANJOLONGinf=zeros(VIGAin.numsecoestrechoneg(trecho),2);
    % Matriz nula para conter os valores de dinf
    VIGAin.dinf=VIGAin.dinfinicial*ones(VIGAin.qntbitolaslong,VIGAin.numsecoestrechoneg(trecho));
    
    % Inicializa��o do valor do tag
    tag=1;
    % PERCORRE AS BITOLAS COMERCIAIS CADASTRADAS EM VIGASin.TABELA
    for bitola=1:VIGAin.qntbitolaslong
        if tag==1
            disp(['    Bitola ',num2str(VIGA.TABELALONG(bitola))])
            tag=0;
            if tag==0
                %FAB - Remo��o de vari�vel sem uso.
                %diambarra=VIGA.TABELALONG(bitola)/1000;
                posbitolatrac=bitola;
                posbitolacomp=bitola;
                tag=0; % Tag para definir se a se��o ser� dimensionada
                if tag==0
                    for sec=1:VIGAin.numsecoestrechoneg(trecho) % PERCORRE AS SE��ES CONTIDAS NO TRECHO EM QUEST�O
                        if tag==0
                            disp(['      Se��o ',num2str(sec),' de ',num2str(VIGAin.numsecoestrechoneg(trecho))])
                            d1=VIGAin.dinf(bitola,sec);
                            d2=0;
                            momento=M(sec);           
                            % O "while" foi inserido de forma que a altura �til estimada,
                            % VIGAin.dinf seja igual a altura �til real "VIGAin.h-YcgTrac".
                            % Portanto ap�s a primeira itera��o ser� calculada altura �til
                            % real, essa ser� utilizada para uma nova itera��o at� que a
                            % igualdade ocorra.
                            while d1~=d2
                                % Dimensionamento da se��o � flex�o - beam0.m
                                [Astrac, Ascomp]=beam0(momento, VIGAin, sec, bitola);
                                % Escolha do arranjo da armadura - beam1.m
                                [ARRANJOtrac, ARRANJOcomp]=beam1(Astrac, Ascomp, VIGA, posbitolatrac, posbitolacomp);
                                % Distribui��o das barras em camadas e c�lculo do
                                % CG das barras de a�o - beam2.m
                                [YcgTrac, difTrac]=beam2(ARRANJOtrac, VIGAin);
                                % Atualiza��o da altura �til da viga                   
                                d1=VIGAin.dinf(bitola,sec);
                                d2=VIGAin.h-YcgTrac;
                                VIGAin.dinf(bitola, sec)=d2;
                            end
                            % Verifica��o de a difren�a entre o CG da barras e a
                            % extremidade da barra mais externa � infeior a 10% da
                            % altura da se��o
                            if difTrac<0.1*VIGAin.h
                                % Posicionamento da armadura na se��o da viga 
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
                                disp('      N�O PASSA!!!')
                            end                    
                        end
                    end
                end
            if tag==0
                % C�lculo da decalagem do DMF da viga - beam3.m
                disp('    C�lculo da decalagem do DMF - regi�o com MF negativo')
                [al]=beam3(VIGAin, bitola);

                % C�lculo do comprimento de ancoragem, vante e r� - beam5.m
                disp('    C�lculo dos comprimentos de ancoragem das barras negativas')
                [lbnecVante, lbnecRe]=beam5(VIGAin, AsCalculadoSup ,ARRANJOLONGsup);
            end
            end
        end
    end % <-- Aqui a rotina termina de "varrer" todas as bitolas comerciais

    % C�lculo do comprimento e peso final das barras do arranjo negativo e armadura de montagem -
    % beam6.m
    disp('    C�lculo do peso de a�o referente �s armaduras negatvas')
    [VIGAresult, COMPneg]=beam6(VIGAin, ARRANJOLONGsup, trecho, lbnecVante, lbnecRe, al, NUMVIGAS, VIGAresult, COMPneg);

end

% C�lculo da armadura de montagem - ser� considerado para armadura de
% montagem duas barras de 5.0.
Lmontagem=VIGAin.COMPRIMENTO(NUMVIGAS)-2*(sum(COMPneg(trecho))-lbnecRe-8*ARRANJOLONGsup(1,2)/1000);
% A multiplica��o por cem serve para transormar a unidade de kN (unidade
% utilizada no arquivos de input) para kgf, unidade mais f�cil de assimilar
% como output.
VIGAresult.PESOmontagem(NUMVIGAS)=Lmontagem*2*(pi*0.005^2/4)*VIGAin.roaco*100;
