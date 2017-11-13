function [VIGAresult, VIGAin]=beamPosMC(VIGAin, VIGA, VIGAresult, NUMVIGAS)
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
% Rotina para o cálculo das armaduras negativas da viga
% -------------------------------------------------------------------------
% MODIFICAÇÕES:         
%--------------------------------------------------------------------------
% VARIÁVEIS DE ENTRADA: --
% VARIÁVEIS DE SAÍDA:   PILARin: "structure" contendo as variáveis necessá-
% rias ao algoritmo de detalhamento do pilar - column.m 
%--------------------------------------------------------------------------
% CRIADA EM 21-fevereiro-2016
% -------------------------------------------------------------------------

%disp('    -> Dimensionamento da armadura positiva')
% Para efeito de comodidade, foi considerado que pode haver apenas um
% trecho de viga com MF positivo. E que nesse trecho o MF será calculado em
% 5 seções distintas.

VIGAin.numsecoestrechopos=5;

% CRIAÇÃO DE UMA SÉRIE DE VETORES NULOS A SEREM PREENCHIDOS EM SEGUIDA
% Vetor contendo as áreas de aço calculadas, superior e inferior
AsCalculadoSup=zeros(1,VIGAin.numsecoestrechopos);
AsCalculadoInf=zeros(1,VIGAin.numsecoestrechopos);
% Vetor contendo os arranjos de armadura, superior e inferior
ARRANJOLONGsup=zeros(VIGAin.numsecoestrechopos,2);
ARRANJOLONGinf=zeros(VIGAin.numsecoestrechopos,2);
% Matriz nula para conter os valores de dinf
VIGAin.dinf=VIGAin.dinfinicial*ones(VIGAin.qntbitolaslong,VIGAin.numsecoestrechopos);

% Ajuste de uma parábola aos valores discretos do MF positivo pelo método
% dos mínimos quadrados- beam8.m
[MCOORD]=beam8(VIGAin);

% Inicialização do valor do tag
tag=1;

% PERCORRE AS BITOLAS COMERCIAIS CADASTRADAS EM VIGASin.TABELA
 for bitola=1:VIGAin.qntbitolaslong    
     if tag==1
         %disp(['    Bitola ',num2str(VIGA.TABELALONG(bitola))])
         posbitolatrac=bitola;
         posbitolacomp=bitola;
         tag=0;
         if tag==0
             for sec=1:VIGAin.numsecoestrechopos % PERCORRE AS SEÇÕES CONTIDAS NO TRECHO EM QUESTÃO
                 if tag==0
                     %disp(['      Seção ',num2str(sec),' de ',num2str(VIGAin.numsecoestrechopos)])
                     d1=VIGAin.dinf(bitola,sec);
                     d2=0;
                     momento=MCOORD(sec,1);
                    % O "while" foi inserido de forma que a altura útil estimada,
                    % VIGAin.dinf seja igual a altura útil real "VIGAin.h-YcgTrac".
                    % Portanto após a primeira iteração será calculada altura útil
                    % real, essa será utilizada para uma nova iteração até que a
                    % igualdade ocorra.
                    while d1~=d2
                        % Dimensionamento da seção à flexão
                        [Astrac, Ascomp]=beam0(momento, VIGAin, sec, bitola);
                        % Escolha do arranjo da armadura
                        [ARRANJOtrac, ARRANJOcomp]=beam1(Astrac, Ascomp, VIGA, posbitolatrac, posbitolacomp);
                        % Distribuição das barras em camadas e cálculo do CG das barras de aço
                        [YcgTrac, difTrac]=beam2(ARRANJOtrac, VIGAin);
                        % Atualização da altura útil da viga                   
                        d1=VIGAin.dinf(bitola,sec);
                        d2=VIGAin.h-YcgTrac;
                        VIGAin.dinf(bitola, sec)=d2;
                    end
                    % % Verificação de a difrença entre o CG da barras e a
                    % extremidade da barra mais externa é infeior a 10% da
                    % altura da seção
                    if difTrac<0.1*VIGAin.h
                        % Posicionamento da armadura na seção da viga 
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
                        %disp('      NÃO PASSA!!!')
                    end
                 end
             end
         end % <-- Aqui a rotina termina de "varrer" todas as seções de determinado trecho
         if tag==0
             % Definição do arranjo das armadures de compressão
             if sum(AsCalculadoSup)>0
                 [VIGAresult]=beam3A(AsCalculadoSup, VIGA, VIGAin,ARRANJOLONGsup);
             else
                 VIGAresult.Lcomp=0;
                 VIGAresult.ARRANJOLONGsup=zeros(1,2);
             end
             % Cálculo da decalagem do DMF da viga
             %disp('    Cálculo da decalagem do DMF - região com MF positivo')
             [al]=beam3(VIGAin, bitola);
             % Cálculo do comprimento de ancoragem, vante e ré da armadura
             %disp('    Cálculo dos comprimentos de ancoragem das barras positivas')
             [lbnecVante, lbnecRe, Abarra]=beam9(VIGAin, AsCalculadoInf, ARRANJOLONGinf, bitola); 
         end
     end
 end % <-- Aqui a rotina termina de "varrer" as bitolas comerciais

 % Cálculo do comprimento e peso final das barras positivas e de compressão - beam10.m
 %disp('    Cálculo do peso de aço referente às armaduras positvas')
[VIGAresult, VIGAin]=beam10(VIGAin, ARRANJOLONGinf, lbnecVante, lbnecRe, al, Abarra, MCOORD, AsCalculadoInf, NUMVIGAS, VIGAresult);
