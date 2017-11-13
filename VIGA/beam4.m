function [ARRANJOLONGsup]=beam4(VIGA, VIGAin, al, trecho, ARRANJOLONGsup, bitola)
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
% Rotina para verificar a quantidade de armadura míinima junto ao apoio
% -------------------------------------------------------------------------
% MODIFICAÇÕES:         
%--------------------------------------------------------------------------
% VARIÁVEIS DE ENTRADA: VIGAout
% VARIÁVEIS DE SAÍDA:   VIGAout: structure contendo os dados de saída da
% viga
%--------------------------------------------------------------------------
% CRIADA EM 29-janeiro-2016
% -------------------------------------------------------------------------

% Iremos utilizar o menor valor de de VIGAin.dinf de forma a garantir o
% maior valor de Rst.
dinf=max(VIGAin.dinf(bitola,:));

% Deterimna se o apoio da viga e o esquerdo ou direito. Se trecho=1, apoio
% esquerdo, se trecho=2, apoio esquerdo.
if trecho==1
    a=1;
else
    a=VIGAin.qntsecoes;
end

% Determinação do esforço normal atuante - só deve-se considerar esforços
% de tração
if VIGAin.N(a)>0
    N=VIGAin.N(a);
else
    N=0;
end

% Cálculo da força de tração que deverá ser resistida pela armadura de
% tração.
Rst=al(bitola)/dinf*abs(VIGAin.V(a))+N;

% Cálculo da armadura necessária para resitir à força de tração no apoio
Asrst=Rst/VIGAin.fyd;

% Determinação da quantidade de barras no apoio
Abarra=pi*(VIGA.TABELALONG(bitola)/1000)^2/4;
nbarras=ceil(Asrst/Abarra);
ArmMinApoio(bitola,1)=nbarras;
ArmMinApoio(bitola,2)=VIGA.TABELALONG(bitola);

% Cálculo da área de aço efetiva no apoio
Asefapoio=ARRANJOLONGsup(1,1,bitola)*Abarra;

% Verificação se a qnt de barras no apoio atende a qnt mínima. Caso não 
% atenda, haverá a substituição.
if Asefapoio<Asrst
    nbarras=ceil(Asrst/Abarra);
    ARRANJOLONGsup(1,1,bitola)=nbarras;
end