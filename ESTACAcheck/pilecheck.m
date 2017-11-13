function [ESTACA]=pilecheck(ELEMENTOS, DADOS, PAR, ESTRUTURAL, COMBPile)
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
% Rotina para verificar o dimensionamento da estaca à flexo-compressão
% normal. Foi considerado perfis tipo "H" com o eixo de menor inérica
% orientado na direção transversal ao fixo da ponte.
% -------------------------------------------------------------------------
% MODIFICAÇÕES:         
%--------------------------------------------------------------------------
% VARIÁVEIS DE ENTRADA: --
% VARIÁVEIS DE SAÍDA:   PILARin: "structure" contendo as variáveis necessá-
% rias ao algoritmo de detalhamento do pilar - column.m 
%--------------------------------------------------------------------------
% CRIADA EM 01-agosto-2017
% -------------------------------------------------------------------------

% ENTRADA DE DADOS
% ESFORÇOS SOLICITANTES - virão da análise estocástica
% [ESTACA]=pileIntEff(DADOS, MOMENTO, NORMAL, ESTRUTURAL);

% Cálculo do esforço normal resistente
[ESTACA]=pileNr(ESTRUTURAL, ELEMENTOS, PAR, DADOS);

% Cálculo do momento fletor resitente
[ESTACA]=pileMr(ESTACA, PAR, DADOS);

ESTACA.tagELU=zeros(12,DADOS.NMC);
ESTACA.FS=zeros(12,DADOS.NMC);
for i=1:12
    COMB=COMBPile(:,:,i);
    for j=1:DADOS.NMC
        ESTACA.Nd=COMB(j,1);
        ESTACA.Md=COMB(j,2);  
        ESTACA.FS(i,j)=1-(abs(ESTACA.Nd)/ESTACA.Nr(j)+abs(ESTACA.Md)/ESTACA.Mr(j));
        if ESTACA.FS(i,j)<0 % Condição de ruptura
            ESTACA.tagELU=1;
        end
    end 
end








% Verificação
% for i=1:DADOS.NMC
%     for j=1:2
%         % Primeiro loop checa a situação onde a ponte sofre alongamento
%         if j==1
%             Ms=COMB.ESTACA.M.along(i);
%             Ns=COMB.ESTACA.N.along(i);
%             if Ms/ESTACA.Mr+Ns/ESTACA.Nr<=1
%                 ESTACA.tagELU(j,i)=1;
%             end
%         end
%         % Segundo loop checa a situação onde a ponte sofre encurtamento
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


