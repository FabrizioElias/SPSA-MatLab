function [PILARout]=column4(PILARin, PILARout)
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
% Rotina para dcálculo dos esforços resitentes da seção de concreto armado
% -------------------------------------------------------------------------
% MODIFICAÇÕES:         
%--------------------------------------------------------------------------
% VARIÁVEIS DE ENTRADA: --
% VARIÁVEIS DE SAÍDA:   PILARin: "structure" contendo as variáveis necessá-
% rias ao algoritmo de detalhamento do pilar - column.m 
%--------------------------------------------------------------------------
% CRIADA EM 21-fevereiro-2016
% -------------------------------------------------------------------------

epsonyd=PILARin.fyd/PILARin.Es;

% Ponto 1 - Compressão axial uniforme
% Esforço resistente do concreto
Rc=PILARin.sigmacd*(PILARin.b*PILARin.h-sum(PILARin.As));
% Esforço resistente do aço
Rs=PILARin.As*PILARin.fyd;
Pn(1)=Rc+sum(Rs);
Mn(1)=0;
plot (Mn(1),Pn(1),'o')
hold on

Zmin=-.01/epsonyd;      % <-- -0.01 é a deformação máxima do aço, 10 por mil
Zmax=-1;                % <-- -1 é qndo a deformação no aço é igual ao limite de escoamento
Z=linspace(Zmin, Zmax, 10);
s=size(Z);
d=PILARin.h/2-PILARout.ys;
Pn=zeros(1,s(2));   % <-- Criação do vetor nulo que irá armazenar os valores de Pn
Mn=zeros(1,s(2));   % <-- Criação do vetor nulo que irá armazenar os valores de Mn
for j=1:s(2)
    c=0.0035/(0.0035+abs(Z(j))*epsonyd)*d(1);     % <-- 0.0035 é o máximo encurtamento do concreto permitido
    
    for i=1:PILARin.ncam
        % Determinação das tensões atuantes em cada caamda de barra
        epsonS(i)=(c-d(i))/c*0.0035;
        if abs(epsonS(i))>=abs(epsonyd)
            fs(i)=PILARin.fyd;
        else
            fs(i)=epsonS(i)*PILARin.Es;
        end
        % Determinação da resultante atuante em cada camada de barra
        if 0.8*c<d(i)
            Rs=fs.*PILARin.As;
        else
            Rs=(fs-PILARin.sigmacd).*PILARin.As;
        end
        
    end
    % Determinação da resultante de compressão atuante no concreto
    Rc=0.8*c*PILARin.sigmacd*PILARin.b;
    % Determinação da carga axial e momento fletor resistente da seção para
    % a dada distribuição de deformação - determinada pelo valor de Z.
    Pn(j)=Rc+sum(Rs);
    Mc=Rc*(PILARin.h/2-0.4*c);  % <-- Momento resistente do concreto
    Ms=sum(Rs.*PILARout.ys);     % <-- Momento resistente do aço
    Mn(j)=Mc+Ms; 
    plot (Mn(j),Pn(j),'o')
    
end
plot (Pn,Mn)