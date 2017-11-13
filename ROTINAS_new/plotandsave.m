function plotandsave(COST)

global m

% PLOTA RESULTOS
disp('VIGAS')
disp(['    Peso de aço (kg) = ',num2str(COST.SPA_V(m)),' - Custo do aço R$',num2str(COST.CVA(m))])
disp(['    Volume de concreto (m3) = ',num2str(COST.SVC_V(m)),' - Custo do concreto R$',num2str(COST.CVC(m))])
disp(['    Área de forma (m2) = ',num2str(COST.SForma_V(m)),' - Custo da forma R$',num2str(COST.CVF(m))])

disp('PILARES')
disp(['    Peso de aço (kg) = ',num2str(COST.SPA_P(m)),' - Custo do aço R$',num2str(COST.CPA(m))])
disp(['    Volume de concreto (m3) = ',num2str(COST.SVC_P(m)),' - Custo do concreto R$',num2str(COST.CPC(m))])
disp(['    Área de forma (m2) = ',num2str(COST.SForma_P(m)),' - Custo da forma R$',num2str(COST.CPF(m))])

disp(['CUSTO TOTAL DA ESTRUTURA R$',num2str(COST.total(m))])
disp('---------------------------------------------------------------------')

% FALTA PROGRAMAR O SALVAMENTO DOS ESFORÇOS INTERNOS, SEÇÃO DOS ELMENTOS E
% PROPRIEDADES DOS MATERIAIS
end

