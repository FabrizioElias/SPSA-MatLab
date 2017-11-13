FEAP Dissertação Portico
61 60 3 3 6 2

INCLude p1OTcoord.txt

INCLude p1OTelem.txt

INCLude p1OTbound.txt

!VIGAS NA DIRECAO x
!VIGA 1
MATErial,1
FRAMe
ELAStic ISOTropic 21000000 0.2
CROSs SECTion &geometriaA

BODY forces 0 0 &cargaA

REFErence VECTor 0 0 1

!PILARES
!PILAR 1
MATErial,2
FRAMe
ELAStic ISOTropic 21000000 0.2
CROSs SECTion &geometriaB

BODY forces 0 0 &cargaB

REFErence VECTor 0 1 0

!PILAR 2
MATErial,3
FRAMe
ELAStic ISOTropic 21000000 0.2
CROSs SECTion &geometriaC

BODY forces &cargaD 0 &cargaC

REFErence VECTor 0 1 0

END

BATCh
TANGent,,1
DISPlacement,ALL
!REACtion,ALL
STREss,ALL
END

!INTErative

STOP
