function [PAR, ELEMENTOS]=desvpadzero(PAR, PORTICO, ELEMENTOS)

% AS VARI�VEIS ALEAT�RIAS TER�O O VALOR DO SEU DESVIO PADR�O ATRIBU�DO O
% VALOR ZERO, DE FORMA A TORNAR TAIS VARI�VEIS DETERMIN�STICAS.

% Par�metros econ�micos - Desv. pad. dos par�metros econ�micos tomados igual a zero
PAR.ECO.ACO. parest2=0;   
PAR.ECO.CONC. parest2=0;  
PAR.ECO.FORMA. parest2=0; 
% Par�metros f�sicos - Desv. pad. das prop. f�sicas tomado igual a zero
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
% Propriedades geom�tricas da se��o
ELEMENTOS.dp(:)=0;

end

