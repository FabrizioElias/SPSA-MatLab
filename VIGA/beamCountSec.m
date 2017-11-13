function VIGAin=beamCountSec(VIGAin)
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
% Rotina para determinar a quantidade de trechos com mudan�a no sinal do
% momento fletor bem como a quantidade de se��es em cada trecho.
% -------------------------------------------------------------------------
% MODIFICA��ES:         
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: VIGAout
% VARI�VEIS DE SA�DA:   VIGAout: VIGAout.qnttrechosneg,
% VIGAout.qnttrechospos, VIGAout.NEG, VIGAout.POS
%--------------------------------------------------------------------------
% CRIADA EM 07-novembro-2015
% -------------------------------------------------------------------------
M=VIGAin.MF;
MM=M;   
MM(VIGAin.qntsecoes+1)=M(VIGAin.qntsecoes);
        % O vetor MM � uma vari�vel auxiliar, similar ao vetor M cuja �nica
        % diferen�a � a existencia de um elemento adicional no final do
        % vetor igual ao valor contido na ultima c�lula de M. Isso foi
        % feito para que adivis�o do valor contido em uma c�lula pelo valor
        % de sua sucessora fosse possivel e n�o ocorresse o erro"out of bond".

k=0; % Quantidade de vezes que o DMF muda de sinal
for i=1:VIGAin.qntsecoes
    if MM(i)/MM(i+1)<0
        k=k+1;
    end    
end

% A vari�vel qnttrechos � a quantidade de trechos da viga onde o MF
% permanece com o mesmo sinal. Por exemplo, uma viga bi-engastada com carga
% uniformemente distribuida, temos que a o DMF ir� mudar de sinal duas
% vezes (inicia-se negativo, passa a ser positivo e volta a ser negativo).
% Assim temos que "qnttrechos=3", qnttrechosneg=2 e qnttrechospos=1.
qnttrechos=k+1;

if M(1)<0
    VIGAin.qnttrechospos=qnttrechos-k;
    VIGAin.qnttrechosneg=qnttrechos-VIGAin.qnttrechospos;
end

if M(1)>0
    VIGAin.qnttrechosneg=qnttrechos-k;
    VIGAin.qnttrechospos=qnttrechos-VIGAin.qnttrechosneg;
end

% if M(1)<0
%     VIGAin.qnttrechosneg=floor(k/2)+1;
% else
%     VIGAin.qnttrechosneg=k/2;
% end
% VIGAin.qnttrechospos=qnttrechos-VIGAin.qnttrechosneg;

% Nesse loop ser�o criados dois vetores, cuja quantidade de elementos �
% igual a VIGAin.numsecoes. O vetor "neg" contem os valores de MF
% negativos e as demais posi��es � preenchida com o zero. De forma an�loga,
% o vetor "pos" contem os valores de MF positivos sendo as demais posi��es
% preenchidas com zero. Assim se o vetor M=[-1 -2 5 7 5 -3 -4], teremos:
% neg=[-1 -2 0 0 0 -3 -4] e pos=[0 0 5 7 5 0 0]
for i=1:VIGAin.qntsecoes
    if M(i)<0
        neg(i)=M(i);
        pos(i)=0;
    else
        neg(i)=0;
        pos(i)=M(i);
    end
end

% Cria��o de matrizes contendo apenas os valores positivos do DMF, VIGAin.POS e
% negativos VIGAin.NEG.
j=1;
k=1;
tag=0;
for i=1:VIGAin.qntsecoes
    if neg(i)<0
        VIGAin.NEG(k,j)=neg(i);
        j=j+1;
        tag=1;
    else
        if tag==1
            k=k+1;
            j=1;
            tag=0;
        end        
    end
end

j=1;
k=1;
tag=0;
for i=1:VIGAin.qntsecoes
    if pos(i)>0
        VIGAin.POS(k,j)=pos(i);
        j=j+1;
        tag=1;
    else
        if tag==1
            k=k+1;
            j=1;
            tag=0;
        end        
    end
end
    
    
