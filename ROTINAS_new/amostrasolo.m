function [CARGASOLO]=amostrasolo(DADOS, arquivoinput, PORTICO)

[PORTICO]=Le_DadosGAMBsolo(DADOS, arquivoinput, PORTICO);

[CARGASOLO]=loadsGAMB(DADOS, PORTICO);

