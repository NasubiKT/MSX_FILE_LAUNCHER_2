10 '####################
20 '# TITLE
30 '#  MSX FILE LAUNCHER 2
40 '# Version 0.1.20240330-1
50 '# LICENSE
60 '#  These codes are licensed under CC0.
70 '#  http://creativecommons.org/publicdomain/zero/1.0/deed.ja
80 '#  Nasubi-K.T is marked with CC0 1.0
90 '####################
100 '### Fundamental Setup
110 SCREEN 1,0,0
120 COLOR 15,4,7
130 WIDTH 31
140 KEY OFF
150 DEFINT A-Z
160 CLS

300 '################################
310 '# Constant Definitions
320 '################################
330 '# You can change the file
340 '#  extensions displayed in the
350 '#  file list by changing the
360 '#  string in the EX$ variable.
370 '# For example, to display files
380 '#  with the extension "BIN" in the
390 '#  file list, change "BAS"to"BIN".
400 EX$="BAS":'Extention Filter
410 '################################
420 VS$="v0.1.20240330-1":'Version
430 AD=&H1800:'Pattern Name Table Addr
440 CC=&H3E:'Cursor Char Code(>)
450 CS=&H20:'Space Char Code( )
460 KE=&H1B:'ESC Char Code
470 XM=13
480 YM=20

500 '################################
510 '# Variable Definitions
520 '################################
530 I=0
540 XP=0
550 YP=0
560 XW=0
570 YW=0
580 AW=0
590 AN=0
600 XS=0
610 YS=0
620 MC=0
630 S=0
640 TA=0
650 TB=0
660 FL$=""
670 I$=""
680 WK$=""

800 '################################
810 '# Initialize
820 '################################
830 FL$="*."+EX$
840 LOCATE 0,0
850 FILES FL$
860 LOCATE 0,22
870 PRINT "RUN:[SPC]/TRG1 QUIT:[ESC]/TRG2";
880 AN=AD+YP*32+XP
890 VPOKE AN,CC

1000 '################################
1010 '# Main Routine
1020 '################################
1100 '### Input STICK Check
1110 S=STICK(0)+STICK(1)
1120 IF S=0 THEN 1500:'Without stick input
1130 'With stick input
1140 VPOKE AD+YP*32+XP,CS
1150 XS=(S=7)-(S=3)
1160 YS=(S=1)-(S=5)
1170 IF (XS=-1)*(XP>0)+(XS=1)*(XP<XM) THEN XW=XP+XS*13 ELSE XW=XP
1180 IF (YS=-1)*(YP>0)+(YS=1)*(YP<YM) THEN YW=YP+YS ELSE YW=YP
1190 AW=AD+YW*32+XW+1
1200 MC=VPEEK(AW)
1210 IF MC=CS THEN 1240
1220 XP=XW
1230 YP=YW
1240 'Waiting for stick release
1250 S=STICK(0)+STICK(1)
1260 IF S<>0 THEN 1240
1270 'Stick input released
1280 AN=AD+(YP)*32+XP
1290 VPOKE AN,CC

1500 '### Input Button-A Check
1510 SA=STRIG(0)+STRIG(1)+STRIG(2)
1520 IF SA=0 THEN 2000:'Without Button-A input
1530 '### Get selected filename
1540 AN=AD+YP*32+XP
1550 MC=VPEEK(AN+1)
1560 IF MC=CS THEN 2000
1570 FL$=""
1580 FOR I=1 TO 12
1590  FL$=FL$+CHR$(VPEEK(AN+I))
1600 NEXT I
1610 '### Executable check
1620 WK$=RIGHT$(FL$,3)
1630 IF WK$=EX$ THEN 1650
1640 GOTO 2000
1650 '### Execute the file
1660 VPOKE AN,CS
1670 WK$="RUN "+FL$
1680 LOCATE 0,22:PRINT WK$+SPACE$(17);
1690 RUN FL$
1700 END

2000 '### Input Button-B Check
2010 SB=STRIG(3)+STRIG(4)
2020 IF SB=0 THEN 2500:'Without Button-B input
2030 GOTO 3000

2500 '### Input ESC Check
2510 I$=INKEY$
2520 IF I$="" THEN 2900:'Without Any-key input
2530 IF ASC(I$)=KE THEN 3000:'With ESC-key input

2900 GOTO 1000

3000 '################################
3010 '# Finalize
3020 '################################
3110 SCREEN 1,0,0
3120 LOCATE0,0
3130 NEW
