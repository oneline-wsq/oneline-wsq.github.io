; ʵ��Ҫ��:
; һ������ͼ�����ݵĵ��뷽�������벢��ʾ�ҶȺͲ�ɫͼ��
; ������C���Էֱ�ԻҶ�ͼ��Ͳ�ɫͼ�����ֱ��ͼͳ�ƺ͸�Ƭ�����۲�����
; �����ٽ�C���Դ����㷨��ֲ��DSP�����������ImageReverseSub.asm�У��ֱ���д����۲�����
;
         .mmregs
         .def  _ImageReverseSub
         .def  _HistogramSub
         .bss  TEMP,1
         .text
_ImageReverseSub:
         MOV	T0,BRC1    		;IMAGE WIDTH
         MOV	T1,BRC0    		;IMAGE HEIGHT
         MOV #255 , AC1
 	 RPTB	LOOP
         RPTB	LOOP
         sub *AR0 , AC1 , AC2
LOOP:   mov AC2 , *AR0+
         RET 
 	            

_HistogramSub:
         MOV	T0,BRC1    		;IMAGE WIDTH 
         MOV	T1,BRC0    		;IMAGE HEIGHT          
 	 RPTB	LOOP1
         RPTB	LOOP1
		AND #255 ,*AR0
		MOV AR1,AR2
		ADD *AR0+,AR1
		add #1,*AR1
LOOP1:  MOV AR2,AR1
         RET

