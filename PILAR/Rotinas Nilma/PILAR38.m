%IMPRESSÃO DOS RESULTADOS DO MODELO PILAR

Arquivo=fopen('ResultadosPILAR.DOC','w');

fprintf(Arquivo,'\nPILAR\n');

fprintf(Arquivo,'\nGEOMETRIA');
fprintf(Arquivo,'\nhx (cm)       =   ');
fprintf(Arquivo,'%5.2f  ',hx);
fprintf(Arquivo,'\nhy (cm)       =   ');
fprintf(Arquivo,'%5.2f  ',hy);
fprintf(Arquivo,'\nAc (cm2)      =   ');
fprintf(Arquivo,'%6.2f',Ac);
fprintf(Arquivo,'\nIx (cm4)      =   ');
fprintf(Arquivo,'%5.2f  ',Ix);
fprintf(Arquivo,'\nIy (cm4)      =   ');
fprintf(Arquivo,'%5.2f  ',Iy);
fprintf(Arquivo,'\nlex (cm)      =   ');
fprintf(Arquivo,'%5.2f  ',lex);
fprintf(Arquivo,'\nley (cm)      =   ');
fprintf(Arquivo,'%5.2f  ',ley);
fprintf(Arquivo,'\nlambdax       =   ');
fprintf(Arquivo,'%5.2f  ',lambdax);
fprintf(Arquivo,'\nlambday       =   ');
fprintf(Arquivo,'%5.2f  ',lambday);
fprintf(Arquivo,'\nPOSPILAR      =   ');
fprintf(Arquivo,'%5.2f  ',POSPILAR);

fprintf(Arquivo,'\n\nESFORÇOS');
fprintf(Arquivo,'\nMsx (KNcm)    =   ');
fprintf(Arquivo,'%5.2f  ',Msx);
fprintf(Arquivo,'\nMsy (KNcm)    =   ');
fprintf(Arquivo,'%5.2f  ',Msy);
fprintf(Arquivo,'\nNs (KN)       =   ');
fprintf(Arquivo,'%5.2f  ',Ns);
fprintf(Arquivo,'\nVsxd (KN)     =   ');
fprintf(Arquivo,'%5.2f  ',Vsxd);
fprintf(Arquivo,'\nVsyd (KN)     =   ');
fprintf(Arquivo,'%5.2f  ',Vsyd);

fprintf(Arquivo,'\n\nARMADURA');
fprintf(Arquivo,'\nAs (cm2)      =   ');
fprintf(Arquivo,'%6.2f',As);
fprintf(Arquivo,'\nNB            =   ');
fprintf(Arquivo,'%5.2f  ',NB);
fprintf(Arquivo,'\nfiLP (cm)     =   ');
fprintf(Arquivo,'%5.2f  ',fiLP);
fprintf(Arquivo,'\nAsdP (cm2)    =   ');
fprintf(Arquivo,'%6.2f',AsdP);
fprintf(Arquivo,'\nAsmax (cm2)   =   ');
fprintf(Arquivo,'%6.2f',Asmax);
fprintf(Arquivo,'\nAsmin (cm2)   =   ');
fprintf(Arquivo,'%6.2f',Asmin);
fprintf(Arquivo,'\nAswS (cm2/m)  =   ');
fprintf(Arquivo,'%5.2f',AswS);
fprintf(Arquivo,'\nAswSdP (cm2/m)=   ');
fprintf(Arquivo,'%5.2f  ',AswSdP);
fprintf(Arquivo,'\nAswSdP (cm2/m)=   ');
fprintf(Arquivo,'%5.2f  ',AswSdP);
fprintf(Arquivo,'\nnestribos     =   ');
fprintf(Arquivo,'%5.2f  ',nestribos);
fprintf(Arquivo,'\nfiTP (cm)     =   ');
fprintf(Arquivo,'%5.2f  ',fiTP);

fprintf(Arquivo,'\n\nRESULTADOS');
fprintf(Arquivo,'\nPesoacoP (kg) =   ');
fprintf(Arquivo,'%5.2f  ',PesoacoP);
fprintf(Arquivo,'\nVolconP (m3)  =   ');
fprintf(Arquivo,'%5.2f  ',VolconP);
fprintf(Arquivo,'\nFormaP (m2)   =   ');
fprintf(Arquivo,'%5.2f  ',FormaP);

fprintf(Arquivo,'\n\nEXCENTRICIDADES');
fprintf(Arquivo,'\nex (cm)       =   ');
fprintf(Arquivo,'%5.2f  ',ex);
fprintf(Arquivo,'\ney (cm)       =   ');
fprintf(Arquivo,'%5.2f  ',ey);

fprintf(Arquivo,'\n\nDEFORMAÇÃO');
fprintf(Arquivo,'\neyd(*10^-3) =   ');
fprintf(Arquivo,'%5.2f  ',eyd);

fprintf(Arquivo,'\n\nPROPRIEDADES DO MATERIAL');
fprintf(Arquivo,'\nfck (MPa)     =   ');
fprintf(Arquivo,'%5.2f  ',fck);
fprintf(Arquivo,'\nfbd (KN/cm2)  =   ');
fprintf(Arquivo,'%5.2f  ',fbd);
fprintf(Arquivo,'\nfcd (KN/cm2)  =   ');
fprintf(Arquivo,'%5.2f  ',fcd);
fprintf(Arquivo,'\nfctd (KN/cm2) =   ');
fprintf(Arquivo,'%5.2f  ',fctd);
fprintf(Arquivo,'\nfctm (KN/cm2) =   ');
fprintf(Arquivo,'%5.2f  ',fctm);
%fprintf(Arquivo,'\nfinf (KN/cm2) =   ');
% fprintf(Arquivo,'%5.2f  ',finf);
% fprintf(Arquivo,'\nfy (MPa)      =   ');
% fprintf(Arquivo,'%5.2f  ',fy);
fprintf(Arquivo,'\nfyd (KN/cm2)  =   ');
fprintf(Arquivo,'%5.2f  ',fyd);
fprintf(Arquivo,'\nfywd (KN/cm2) =   ');
fprintf(Arquivo,'%5.2f  ',fywd);
fprintf(Arquivo,'\nfywk (KN/cm2) =   ');
fprintf(Arquivo,'%5.2f  ',fywk);
fprintf(Arquivo,'\nEs (KN/cm2)   =   ');
fprintf(Arquivo,'%5.2f  ',Es);

% fprintf(Arquivo,'\n\nCOEFICIENTES DE PONDERAÇÃO');
% fprintf(Arquivo,'\ngamac         =   ');
% fprintf(Arquivo,'%5.2f  ',gamac);
% fprintf(Arquivo,'\ngamar         =   ');
% fprintf(Arquivo,'%5.2f  ',gamar);
% fprintf(Arquivo,'\ngamas         =   ');
% fprintf(Arquivo,'%5.2f  ',gamas);










