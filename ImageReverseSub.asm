; 实验要求:
; 一、掌握图像数据的导入方法，载入并显示灰度和彩色图像
; 二、用C语言分别对灰度图像和彩色图像进行直方图统计和负片处理，观察结果。
; 三、再将C语言处理算法移植到DSP汇编语言例程ImageReverseSub.asm中，分别进行处理并观察结果。
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

