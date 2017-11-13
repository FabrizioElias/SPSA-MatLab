function [PAR, ELEMENTOS]=desvpadzero(PAR, PORTICO, ELEMENTOS)

% AS VARIÁVEIS ALEATÓRIAS TERÃO O VALOR DO SEU DESVIO PADRÃO ATRIBUÍDO O
% VALOR ZERO, DE FORMA A TORNAR TAIS VARIÁVEIS DETERMINÍSTICAS.

% Parâmetros econômicos - Desv. pad. dos parâmetros econômicos tomados igual a zero
PAR.ECO.ACO. parest2=0;   
PAR.ECO.CONC. parest2=0;  
PAR.ECO.FORMA. parest2=0; 
% Parâmetros físicos - Desv. pad. das prop. físicas tomado igual a zero
PAR.ACO.RESTRAC.parest2=0;
PAR.ACO.PESOESP.parest2=0;
PAR.ACO.Es.parest2=0;
PAR.CONC.RESCOMP.parest2=0;
PAR.CONC.PESOESP.parest2=0;
PAR.CONC.Eci.parest2=0;
PAR.CONC.Ecs.parest2=0;
PAR.CONC.POISSON.parest2=0;
PAR.CONC.PHI.parest2=0;
% Carregamentos atuantes- Desv. pad. das cargas tomado igual a zero
PORTICO.cargadistyParEst2=zeros(1,PORTICO.qntelemcargadist);
PORTICO.cargadistxParEst2=zeros(1,PORTICO.qntelemcargadist);
% Propriedades geométricas da seção
ELEMENTOS.dp(:)=0;

end

