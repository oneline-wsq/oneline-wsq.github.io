;混合编程实验内容：
;1、注意观察整型变量在相应 Tx 寄存器中的值。
;2、注意观察数组指针在相应 XARx 寄存器中的值。
;3、编写加减乘除子程序，a、b变量为加减乘除源操作数。
;4、加减乘除的结果存放在buffer1数组中，
;      buffer1[0]=加法结果
;      buffer1[1]=减法结果
;      buffer1[2]=乘法结果
;      buffer1[3]=除法结果
;      buffer1[4]=除法余数
;5、mySub子程序返回乘法结果。
;6、在mySub中改变全局变量k的内容，在C中观察变化
;7、在C主程序中打印相应结果。


         .mmregs
         .def  _mySub
         .bss  x,1
         .bss  y,1    
         .bss  _k,1
         .global  _k                      ;k前的_不可少
         
         .text
_mySub:  amov #x,xar5                     ;x variable address
         mov  t0,*ar5
         amov #y,xar6
         mov  t1,*ar6
                    
         mov  #1234,*(_k)      
          
         
         call addition
         call subtraction
         call multiplication
         call division
         MOV *AR1,T0                     ;return result of multiplication
         ret         
         
         
        
;计算区间[b,a]之间整数的和
addition:
		MOV  #92,brc0
		MOV T1,T2
		MOV T1,T3
		rptblocal LOOP
		ADD #1,T2
LOOP:	ADD T2,T3
		MOV T3,*AR0+
      ret

;计算 a-b的结果
subtraction:
		SUB *AR5,*AR6,AC0
		MOV mmap(@AC0H),T2
		MOV T2,*AR0+
		MOV AR0,AR1
      ret

;计算 a*b的结果
multiplication:
		MOV T1,mmap(@AC1H)
		MPY T0,AC1,AC0
		MOV AC0,*AR0+
      ret          
         
;计算 a/b的结果
division:
        MOV *AR5,AC0
        RPT #15
        subc *ar6,ac0
        MOV AC0,*AR0+
        MOV HI(AC0),*AR0+

      ret
