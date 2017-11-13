function [Fpp, fepp, CARGA]=loadPP(PORTICO, ELEMENTOS, ROT, gdle, ngl, CARGA)
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
% Rotina para o cálculo do vetor de cargas devido ao peso próprio e
% sobrecarga atuante na estrutura
% -------------------------------------------------------------------------
% MODIFICAÇÕES:         Modificada em 16/05/2015
%--------------------------------------------------------------------------
% VARIÁVEIS DE ENTRADA: PORTICO, ELEMENTOS, DADOS
% VARIÁVEIS DE SAÍDA:   esf: esforços nodais obtidos à partir do método dos
%                       deslocamentos
%--------------------------------------------------------------------------
% CRIADA EM 14-Janeiro-2015
% -------------------------------------------------------------------------

% 1 - CÁLCULO DAS CARGAS ATUANTES
% 1.1 - Vetor contendo os carregamentos distribuídos - dir Y local
qy=ELEMENTOS.ppy';
CARGA.PPqy=qy;
% 1.2 - Vetor contendo os carregamentos distribuídos - dir X local
qx=ELEMENTOS.ppx';
CARGA.PPqx=qx;

% 2. ESFORÇOS DE ENGASTAMENTO PERFEITO
% 2.1 - A nível de elemento - Referencial local
feq = zeros(6,PORTICO.nelem);
for i=1:PORTICO.nelem
    f=[-qx(i)*PORTICO.comp(i)/2 -qy(i)*PORTICO.comp(i)/2 -qy(i)*PORTICO.comp(i)^2/12 -qx(i)*PORTICO.comp(i)/2 -qy(i)*PORTICO.comp(i)/2 qy(i)*PORTICO.comp(i)^2/12];
    feq(:,i)=f;
end
fepp=feq;   %<-- Devido apenas ao peso próprio da estrutura
% 2.2 - A nível de elemento - Referencial global
Fe=zeros(6,PORTICO.nelem);
for i=1:PORTICO.nelem
    Fe(:,i)=-ROT(:,:,i)*fepp(:,i);
end
% 2.2 - A nível de estrutura - Referencial global
Feq=zeros(1,ngl);
for i=1:PORTICO.nelem
    for j=1:6
        k=gdle(i,j);
        if k>0
            Feq(k)=Feq(k)+Fe(j,i);
        end
    end
end

Fpp=Feq;