function leitura_rwo
% LEITURA_RWO: devolve output file forças e momentos calculados no feap.
% --------------------------------------------------------------------------
% [Dias,tempo,Oleo_Produzido,Agua_Produzida,Agua_Injetada]=leitura_rwo(arq)
%
% arq                -  arquivo de entrada                             (in)
% Dias               -  escala de tempo                               (out)
% Oleo_Produzido_Ac  -  producao de oleo                              (out)
% Agua_Produzida_Ac  -  producao de agua                              (out)
% Agua_Injetada_Ac   -  injecao de agua                               (out)
% --------------------------------------------------------------------------
% -------------------------------------------------------------------------
% OTIMIZACAO ESTOCASTICA DINAMICA DO CUSTO DE EDIFICACOES
% -------------------------------------------------------------------------
% Universidade Federal de Pernambuco
% Programa de Pos-Graduaçao Engenharia Civil / Estruturas
% UFPE / UFSE
% Centro de Tecnologia e Geociencias / DECIV
% Nilma Andrade (Adaptacao das rotinas de Diego Oliveira)
% --------------------------------------------------------------------------
% Criado:          04-Ago-2011      Nilma Andrade
%
% Adaptado de:     30-Jan-2006      Diego Oliveira
% 
% Moficaçoes:    
%
% --------------------------------------------------------------------------

global Oleo_Produzido_Ac;
global Agua_Produzida_Ac;
global Agua_Injetada_Ac;
global Dias;

% file = input('Entre com Arquivo de Dados: ');
% [fid, msg] = fopen(file, 'r');
% if (fid == -1)
%   error(msg);
% end

file = 'simulacao.rwo';
%FAB - Remoção de variável não utilizada.
%[fid, msg] = fopen(file, 'r');
[fid, ~] = fopen(file, 'r');

for k=1:9
    %lixo=fgets(fid);
    %FAB - Só lê, sem alocar em nada.
    fgets(fid);
end
k=1;
while ~feof(fid)
    [A,count]=fscanf(fid,'%f',4);
    if count==0
        break
    end
    %FAB - Poderia prealocar, mas com que número?
    d(k)=A(1);
    op_ac(k)=A(2);
    ap_ac(k)=A(3);
    ai_ac(k)=A(4);    
    k=k+1;
end
Dias=d;
Oleo_Produzido_Ac=op_ac;
Agua_Produzida_Ac=ap_ac;
Agua_Injetada_Ac=ai_ac;

fclose(fid);