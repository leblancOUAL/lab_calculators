C PROGRAM TO CALCULATE NMR FREQUENCY VS. PARTICLE ENERGY TABLES         ETA00010
C                                                                       ETA00020
C THE ORIGINS OF THIS CODE ARE UNKNOWN; IT WAS FOUND AT THE BACK        ETA00030
C OF THE PREVIOUSLY USED TABLES.  THE PREVIOUSLY USED TABLES WERE       ETA00040
C WORN OUT, AND HAD TO BE REPLACED.  THE NUMBERS ARE IDENTICAL.         ETA00050
C                                                                       ETA00060
C THE OUTPUT FORMAT WAS ALTERED SLIGHTLY TO ALLOW FOR USE ON THE        ETA00070
C 6-LPI PRINTER; THE ORIGINAL VERSION WAS DESIGNED FOR AN 8-LPI         ETA00080
C OUTPUT.  THE HEADER AND TRAILER LINES WERE THE ONLY THINGS CHANGED.   ETA00090
C                                                                       ETA00100
C NOVEMBER 1987; D.E. CARTER AND J.E. O'DONNELL                         ETA00110
C                                                                       ETA00120
      REAL*8 M,MZERO,K,NU(10),E,EC,Z                                    ETA00130
      INTEGER ZIN                                                       ETA00140
      DIMENSION NAME(20)                                                ETA00150
      DATA MZERO/1.8765592D03/                                          ETA00160
   1  FORMAT(1H1,'ENERGY (MEV) VS. NMR FREQUENCY (MHZ) FOR',1X,         ETA00170
     >20A1,2X,'MASS = ',F9.6,2X,'CHARGE STATE = +',I1,2X,'K = ',1PE10.3 ETA00180
     >//8X,'E',9X,'.000',8X,'.001',8X,'.002',8X,'.003',8X,              ETA00190
     > '.004',8X,'.005',8X,'.006',8X,'.007',8X,'.008',8X,'.009'/)       ETA00200
   2  FORMAT(5X,F6.2,10(4X,F8.4))                                       ETA00210
   3  FORMAT(1X)                                                        ETA00220
   4  FORMAT(20A1,F10.4,4X,I1,5X,F10.4,5X,F5.0,5X,F5.0)                 ETA00230
   5  FORMAT(1H ,48X,20A1,2X,'CHARGE STATE = +',I1,5X,                  ETA00240
     >  'E = ',F7.3,' TO ',F7.3,' MEV ')                                ETA00250
   6  FORMAT(/)                                                         ETA00260
1001  READ (1,4) NAME,M,ZIN,K,EIN,EOUT                                  ETA00270
      IF (M.EQ.0.00) STOP                                               ETA00280
      IF (ZIN.EQ.0) ZIN = 1                                             ETA00290
      Z = ZIN                                                           ETA00300
      E = EIN                                                           ETA00310
      L = 2.0D0*(EOUT-EIN)                                              ETA00320
      DO 1005 IIII=1,L                                                  ETA00330
         WRITE (3,6)                                                    ETA00340
         WRITE (3,1) NAME,M,ZIN,K                                       ETA00350
         DO 1004 III=1,5                                                ETA00360
            DO 1003 II=1,10                                             ETA00370
               DO 1002 I=1,10                                           ETA00380
               EC = E+0.001D0*DFLOAT(I-1)                               ETA00390
1002           NU(I) = DSQRT(EC*M/K*(1.0D0+EC/(M*MZERO)))/Z             ETA00400
               WRITE (3,2) E,NU                                         ETA00410
1003        E = E + 0.01D0                                              ETA00420
1004     WRITE (3,3)                                                    ETA00430
         ET = E - 0.5D0                                                 ETA00440
1005  WRITE (3,5) NAME,ZIN,ET,EC                                        ETA00450
      GOTO 1001                                                         ETA00460
      END                                                               ETA00470
