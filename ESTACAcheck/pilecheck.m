function [ESTACA]=pilecheck(ELEMENTOS, DADOS, PAR, ESTRUTURAL, COMBPile)
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
% Rotina para verificar o dimensionamento da estaca � flexo-compress�o
% normal. Foi considerado perfis tipo "H" com o eixo de menor in�rica
% orientado na dire��o transversal ao fixo da ponte.
% -------------------------------------------------------------------------
% MODIFICA��ES:         
%--------------------------------------------------------------------------
% VARI�VEIS DE ENTRADA: --
% VARI�VEIS DE SA�DA:   PILARin: "structure" contendo as vari�veis necess�-
% rias ao algoritmo de detalhamento do pilar - column.m 
%--------------------------------------------------------------------------
% CRIADA EM 01-agosto-2017
% -------------------------------------------------------------------------

% ENTRADA DE DADOS
% ESFOR�OS SOLICITANTES - vir�o da an�lise estoc�stica
% [ESTACA]=pileIntEff(DADOS, MOMENTO, NORMAL, ESTRUTURAL);

% C�lculo do esfor�o normal resistente
[ESTACA]=pileNr(ESTRUTURAL, ELEMENTOS, PAR, DADOS);

% C�lculo do momento fletor resitente
[ESTACA]=pileMr(ESTACA, PAR, DADOS);

ESTACA.tagELU=zeros(12,DADOS.NMC);
ESTACA.FS=zeros(12,DADOS.NMC);
for i=1:12
    COMB=COMBPile(:,:,i);
    for j=1:DADOS.NMC
        ESTACA.Nd=COMB(j,1);
        ESTACA.Md=COMB(j,2);  
        ESTACA.FS(i,j)=1-(abs(ESTACA.Nd)/ESTACA.Nr(j)+abs(ESTACA.Md)/ESTACA.Mr(j));
        if ESTACA.FS(i,j)<0 % Condi��o de ruptura
            ESTACA.tagELU=1;
        end
    end 
end








% Verifica��o
% for i=1:DADOS.NMC
%     for j=1:2
%         % Primeiro loop checa a situa��o onde a ponte sofre alongamento
%         if j==1
%             Ms=COMB.ESTACA.M.along(i);
%             Ns=COMB.ESTACA.N.along(i);
%             if Ms/ESTACA.Mr+Ns/ESTACA.Nr<=1
%                 ESTACA.tagELU(j,i)=1;
%             end
%         end
%         % Segundo loop checa a situa��o onde a ponte sofre encurtamento
%         if j==2
%             Ms=COMB.ESTACA.M.enc(i);
%             Ns=COMB.ESTACA.N.enc(i);
%             if Ms/ESTACA.Mr+Ns/ESTACA.Nr<=1
%                 ESTACA.tagELU(j,i)=1;
%             end
%         end
%         
%     end 
% end


