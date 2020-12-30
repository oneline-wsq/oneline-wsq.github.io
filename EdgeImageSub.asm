;EdgeImageSub(ImageWidth,ImageHeight,buffer_org,buffer_grey,Threshhold);
;入口参数：T0=ImageWidth,T1=ImageHeight
;          AR0=buffer_org,AR1=buffer_grey,AR2=Threshhold
;将C语言编写的Roberts算法移植到5509汇编_EdgeImageSub中

         .mmregs
         .def  _EdgeImageSub
         .bss  TEMP,1
         .text
_EdgeImageSub:
;		 mov t0,brc0
;		 mov t1,brc1
;		 mov ar2,ac3
;		 rptb LOOP
;		 rptb LOOP
;		 	mov *ar0,ac0
;		 	add #1,t1
;		 	mov #2,ac0
;		 	sub ac0,*ar0(t1),ac1
;			abs ac1


;			mov *ar0(#1),ac0
;			sub ac0,*ar0(t1),ac2
;			abs ac2

;			add ac1,ac2
;			cmp ac2>=ac3,tc1
;			bcc Inter_loop,tc1
;			mov #0,*ar1+
;			B LOOP
;Inter_loop:	mov #255,*ar1+
;LOOP:		add #1,ar0
;         RET

 	     sub #3,t0,t3      ;t0是行
		 mov t3,brc1
		 sub #3,t1,t3      ;t1是列
		 mov t3,brc0

		 add t0,ar0         ;ar0下移一行
		 add #1,ar0         ;ar0右移一格

		 add t0,ar1
		 add #1,ar1

         RPTB	LOOPX       ;外循环，由BRC0的数字决定
         RPTB	LOOPY       ;内循环，由BRC1的数字决定
                            ;先循环行，后循环列
		 mov *ar0,ac0
		 mpyk #2,ac0,ac0    ;ar0不变，(x,y)*2,放在ac0中

		 sub #1,t0
		 mov *ar0(t0),ac1   ;ar0不变，(x-1,y+1),放在ac1里
		 add ac1,ac0        ;和放ac0里，ac1可以重复利用

		 mov *(ar0-t0),ac2
		 add t0,ar0         ;ar0不变，(x+1,y-1)放在ac2里
         add #1,t0

		 add ac2,ac0        ;第一个式子前三项结束，结果存在ac0里
		 sftl ac0,#-2       ;第一个式子的第一部分/4

		 mov *ar0(#-1),ac1   ;把(x-1,y)放在ac1里
		 mov *(ar0-t0),ac2   ;把(x,y-1)放在ac2里，ar0=ar0-t0
		 mov *ar0(#-1),ac3   ;把(x-1,y-1)放在ac3里，ar0不变
		 add t0,ar0
		 add ac2,ac1
		 add ac3,ac1         ;第一个式子后三项存在ac1里
;下面是除法
		 amov #0x1063,xar3
         mov #3,*ar3         ;把3移到1063h中去
         rpt #15             ;ac1除3
         subc *ar3,ac1
         and #65535,ac1      ;取商

         sub ac0,ac1
         mov ac1,ac2
         abs ac2             ;x的梯度放在ac2里

         mov *ar0,ac0
         sftl ac0,#1         ;2*(x,y)

         add #1,t0
         mov *(ar0-t0),ac1   ;(x-1.y-1)
         add t0,ar0
         mov *(ar0+t0),ac3   ;(x+1,y+1)
         sub t0,ar0
         sub #1,t0

         add ac1,ac0
         add ac3,ac0
         sftl ac0,#-2        ;第二个式子的前半部分

         mov *(ar0-t0),ac1   ;(x,y-1)
         mov *+ar0,ac3       ;(x+1,y-1)
         add ac3,ac1
         mov *(ar0+t0),ac3   ;(x+1,y)
         sub #1,ar0
         add ac3,ac1         ;第二个式子的第二项放在ac1里
         mov #3,*ar3         ;把3移到1063h中去
         rpt #15             ;ac1除3
         subc *ar3,ac1
         and #65535,ac1      ;取商

         sub ac0,ac1
         mov ac1,ac3
         abs ac3             ;y的梯度放在ac3里

         add ac2,ac3
         mov ac3,ac0         ;总梯度放在ac0里

         mov ar2,ac1
         sub ac1,ac0         ;ac0=ac0-ac1

         bcc branch1,ac0>=#0  ;满足条件时跳转至branch1
         bcc branch2,ac0<#0
branch1: MOV #255,*AR1+
         B LOOPY
branch2: MOV #0,*AR1+
LOOPY:   add #1,ar0
         add #2,ar0
LOOPX:   add #2,ar1
         RET
 	            

