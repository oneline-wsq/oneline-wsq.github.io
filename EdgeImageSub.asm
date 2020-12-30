;EdgeImageSub(ImageWidth,ImageHeight,buffer_org,buffer_grey,Threshhold);
;��ڲ�����T0=ImageWidth,T1=ImageHeight
;          AR0=buffer_org,AR1=buffer_grey,AR2=Threshhold
;��C���Ա�д��Roberts�㷨��ֲ��5509���_EdgeImageSub��

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

 	     sub #3,t0,t3      ;t0����
		 mov t3,brc1
		 sub #3,t1,t3      ;t1����
		 mov t3,brc0

		 add t0,ar0         ;ar0����һ��
		 add #1,ar0         ;ar0����һ��

		 add t0,ar1
		 add #1,ar1

         RPTB	LOOPX       ;��ѭ������BRC0�����־���
         RPTB	LOOPY       ;��ѭ������BRC1�����־���
                            ;��ѭ���У���ѭ����
		 mov *ar0,ac0
		 mpyk #2,ac0,ac0    ;ar0���䣬(x,y)*2,����ac0��

		 sub #1,t0
		 mov *ar0(t0),ac1   ;ar0���䣬(x-1,y+1),����ac1��
		 add ac1,ac0        ;�ͷ�ac0�ac1�����ظ�����

		 mov *(ar0-t0),ac2
		 add t0,ar0         ;ar0���䣬(x+1,y-1)����ac2��
         add #1,t0

		 add ac2,ac0        ;��һ��ʽ��ǰ����������������ac0��
		 sftl ac0,#-2       ;��һ��ʽ�ӵĵ�һ����/4

		 mov *ar0(#-1),ac1   ;��(x-1,y)����ac1��
		 mov *(ar0-t0),ac2   ;��(x,y-1)����ac2�ar0=ar0-t0
		 mov *ar0(#-1),ac3   ;��(x-1,y-1)����ac3�ar0����
		 add t0,ar0
		 add ac2,ac1
		 add ac3,ac1         ;��һ��ʽ�Ӻ��������ac1��
;�����ǳ���
		 amov #0x1063,xar3
         mov #3,*ar3         ;��3�Ƶ�1063h��ȥ
         rpt #15             ;ac1��3
         subc *ar3,ac1
         and #65535,ac1      ;ȡ��

         sub ac0,ac1
         mov ac1,ac2
         abs ac2             ;x���ݶȷ���ac2��

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
         sftl ac0,#-2        ;�ڶ���ʽ�ӵ�ǰ�벿��

         mov *(ar0-t0),ac1   ;(x,y-1)
         mov *+ar0,ac3       ;(x+1,y-1)
         add ac3,ac1
         mov *(ar0+t0),ac3   ;(x+1,y)
         sub #1,ar0
         add ac3,ac1         ;�ڶ���ʽ�ӵĵڶ������ac1��
         mov #3,*ar3         ;��3�Ƶ�1063h��ȥ
         rpt #15             ;ac1��3
         subc *ar3,ac1
         and #65535,ac1      ;ȡ��

         sub ac0,ac1
         mov ac1,ac3
         abs ac3             ;y���ݶȷ���ac3��

         add ac2,ac3
         mov ac3,ac0         ;���ݶȷ���ac0��

         mov ar2,ac1
         sub ac1,ac0         ;ac0=ac0-ac1

         bcc branch1,ac0>=#0  ;��������ʱ��ת��branch1
         bcc branch2,ac0<#0
branch1: MOV #255,*AR1+
         B LOOPY
branch2: MOV #0,*AR1+
LOOPY:   add #1,ar0
         add #2,ar0
LOOPX:   add #2,ar1
         RET
 	            

