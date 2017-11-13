function [PILARout]=column4(PILARin, PILARout)
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
% Rotina para dc�lculo dos esfor�os resitentes da se��o de concreto armado
% -------------------------------------------------------------------------
% MODIFICA��ES:         
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: --
% VARI�VEIS DE SA�DA:   PILARin: "structure" contendo as vari�veis necess�-
% rias ao algoritmo de detalhamento do pilar - column.m 
%--------------------------------------------------------------------------
% CRIADA EM 21-fevereiro-2016
% -------------------------------------------------------------------------

epsonyd=PILARin.fyd/PILARin.Es;

% Ponto 1 - Compress�o axial uniforme
% Esfor�o resistente do concreto
Rc=PILARin.sigmacd*(PILARin.b*PILARin.h-sum(PILARin.As));
% Esfor�o resistente do a�o
Rs=PILARin.As*PILARin.fyd;
Pn(1)=Rc+sum(Rs);
Mn(1)=0;
plot (Mn(1),Pn(1),'o')
hold on

Zmin=-.01/epsonyd;      % <-- -0.01 � a deforma��o m�xima do a�o, 10 por mil
Zmax=-1;                % <-- -1 � qndo a deforma��o no a�o � igual ao limite de escoamento
Z=linspace(Zmin, Zmax, 10);
s=size(Z);
d=PILARin.h/2-PILARout.ys;
Pn=zeros(1,s(2));   % <-- Cria��o do vetor nulo que ir� armazenar os valores de Pn
Mn=zeros(1,s(2));   % <-- Cria��o do vetor nulo que ir� armazenar os valores de Mn
for j=1:s(2)
    c=0.0035/(0.0035+abs(Z(j))*epsonyd)*d(1);     % <-- 0.0035 � o m�ximo encurtamento do concreto permitido
    
    for i=1:PILARin.ncam
        % Determina��o das tens�es atuantes em cada caamda de barra
        epsonS(i)=(c-d(i))/c*0.0035;
        if abs(epsonS(i))>=abs(epsonyd)
            fs(i)=PILARin.fyd;
        else
            fs(i)=epsonS(i)*PILARin.Es;
        end
        % Determina��o da resultante atuante em cada camada de barra
        if 0.8*c<d(i)
            Rs=fs.*PILARin.As;
        else
            Rs=(fs-PILARin.sigmacd).*PILARin.As;
        end
        
    end
    % Determina��o da resultante de compress�o atuante no concreto
    Rc=0.8*c*PILARin.sigmacd*PILARin.b;
    % Determina��o da carga axial e momento fletor resistente da se��o para
    % a dada distribui��o de deforma��o - determinada pelo valor de Z.
    Pn(j)=Rc+sum(Rs);
    Mc=Rc*(PILARin.h/2-0.4*c);  % <-- Momento resistente do concreto
    Ms=sum(Rs.*PILARout.ys);     % <-- Momento resistente do a�o
    Mn(j)=Mc+Ms; 
    plot (Mn(j),Pn(j),'o')
    
end
plot (Pn,Mn)