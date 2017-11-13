function [VIGAresult, VIGAin]=beamPosMC(VIGAin, VIGA, VIGAresult, NUMVIGAS)
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
% Rotina para o c�lculo das armaduras negativas da viga
% -------------------------------------------------------------------------
% MODIFICA��ES:         
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: --
% VARI�VEIS DE SA�DA:   PILARin: "structure" contendo as vari�veis necess�-
% rias ao algoritmo de detalhamento do pilar - column.m 
%--------------------------------------------------------------------------
% CRIADA EM 21-fevereiro-2016
% -------------------------------------------------------------------------

%disp('    -> Dimensionamento da armadura positiva')
% Para efeito de comodidade, foi considerado que pode haver apenas um
% trecho de viga com MF positivo. E que nesse trecho o MF ser� calculado em
% 5 se��es distintas.

VIGAin.numsecoestrechopos=5;

% CRIA��O DE UMA S�RIE DE VETORES NULOS A SEREM PREENCHIDOS EM SEGUIDA
% Vetor contendo as �reas de a�o calculadas, superior e inferior
AsCalculadoSup=zeros(1,VIGAin.numsecoestrechopos);
AsCalculadoInf=zeros(1,VIGAin.numsecoestrechopos);
% Vetor contendo os arranjos de armadura, superior e inferior
ARRANJOLONGsup=zeros(VIGAin.numsecoestrechopos,2);
ARRANJOLONGinf=zeros(VIGAin.numsecoestrechopos,2);
% Matriz nula para conter os valores de dinf
VIGAin.dinf=VIGAin.dinfinicial*ones(VIGAin.qntbitolaslong,VIGAin.numsecoestrechopos);

% Ajuste de uma par�bola aos valores discretos do MF positivo pelo m�todo
% dos m�nimos quadrados- beam8.m
[MCOORD]=beam8(VIGAin);

% Inicializa��o do valor do tag
tag=1;

% PERCORRE AS BITOLAS COMERCIAIS CADASTRADAS EM VIGASin.TABELA
 for bitola=1:VIGAin.qntbitolaslong    
     if tag==1
         %disp(['    Bitola ',num2str(VIGA.TABELALONG(bitola))])
         posbitolatrac=bitola;
         posbitolacomp=bitola;
         tag=0;
         if tag==0
             for sec=1:VIGAin.numsecoestrechopos % PERCORRE AS SE��ES CONTIDAS NO TRECHO EM QUEST�O
                 if tag==0
                     %disp(['      Se��o ',num2str(sec),' de ',num2str(VIGAin.numsecoestrechopos)])
                     d1=VIGAin.dinf(bitola,sec);
                     d2=0;
                     momento=MCOORD(sec,1);
                    % O "while" foi inserido de forma que a altura �til estimada,
                    % VIGAin.dinf seja igual a altura �til real "VIGAin.h-YcgTrac".
                    % Portanto ap�s a primeira itera��o ser� calculada altura �til
                    % real, essa ser� utilizada para uma nova itera��o at� que a
                    % igualdade ocorra.
                    while d1~=d2
                        % Dimensionamento da se��o � flex�o
                        [Astrac, Ascomp]=beam0(momento, VIGAin, sec, bitola);
                        % Escolha do arranjo da armadura
                        [ARRANJOtrac, ARRANJOcomp]=beam1(Astrac, Ascomp, VIGA, posbitolatrac, posbitolacomp);
                        % Distribui��o das barras em camadas e c�lculo do CG das barras de a�o
                        [YcgTrac, difTrac]=beam2(ARRANJOtrac, VIGAin);
                        % Atualiza��o da altura �til da viga                   
                        d1=VIGAin.dinf(bitola,sec);
                        d2=VIGAin.h-YcgTrac;
                        VIGAin.dinf(bitola, sec)=d2;
                    end
                    % % Verifica��o de a difren�a entre o CG da barras e a
                    % extremidade da barra mais externa � infeior a 10% da
                    % altura da se��o
                    if difTrac<0.1*VIGAin.h
                        % Posicionamento da armadura na se��o da viga 
                        AsCalculadoSup(sec)=Ascomp;
%                         ARRANJOLONGsup(sec, 1)=ARRANJOcomp(1);
%                         ARRANJOLONGsup(sec, 2)=ARRANJOcomp(2);
                        AsCalculadoInf(sec)=Astrac;
                        ARRANJOLONGinf(sec, 1)=ARRANJOtrac(1);
                        ARRANJOLONGinf(sec, 2)=ARRANJOtrac(2);
                        tag=0;
                        %disp('      OK - Passa')
                    else
                        tag=1;
                        %disp('      N�O PASSA!!!')
                    end
                 end
             end
         end % <-- Aqui a rotina termina de "varrer" todas as se��es de determinado trecho
         if tag==0
             % Defini��o do arranjo das armadures de compress�o
             if sum(AsCalculadoSup)>0
                 [VIGAresult]=beam3A(AsCalculadoSup, VIGA, VIGAin,ARRANJOLONGsup);
             else
                 VIGAresult.Lcomp=0;
                 VIGAresult.ARRANJOLONGsup=zeros(1,2);
             end
             % C�lculo da decalagem do DMF da viga
             %disp('    C�lculo da decalagem do DMF - regi�o com MF positivo')
             [al]=beam3(VIGAin, bitola);
             % C�lculo do comprimento de ancoragem, vante e r� da armadura
             %disp('    C�lculo dos comprimentos de ancoragem das barras positivas')
             [lbnecVante, lbnecRe, Abarra]=beam9(VIGAin, AsCalculadoInf, ARRANJOLONGinf, bitola); 
         end
     end
 end % <-- Aqui a rotina termina de "varrer" as bitolas comerciais

 % C�lculo do comprimento e peso final das barras positivas e de compress�o - beam10.m
 %disp('    C�lculo do peso de a�o referente �s armaduras positvas')
[VIGAresult, VIGAin]=beam10(VIGAin, ARRANJOLONGinf, lbnecVante, lbnecRe, al, Abarra, MCOORD, AsCalculadoInf, NUMVIGAS, VIGAresult);
