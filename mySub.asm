;��ϱ��ʵ�����ݣ�
;1��ע��۲����ͱ�������Ӧ Tx �Ĵ����е�ֵ��
;2��ע��۲�����ָ������Ӧ XARx �Ĵ����е�ֵ��
;3����д�Ӽ��˳��ӳ���a��b����Ϊ�Ӽ��˳�Դ��������
;4���Ӽ��˳��Ľ�������buffer1�����У�
;      buffer1[0]=�ӷ����
;      buffer1[1]=�������
;      buffer1[2]=�˷����
;      buffer1[3]=�������
;      buffer1[4]=��������
;5��mySub�ӳ��򷵻س˷������
;6����mySub�иı�ȫ�ֱ���k�����ݣ���C�й۲�仯
;7����C�������д�ӡ��Ӧ�����


         .mmregs
         .def  _mySub
         .bss  x,1
         .bss  y,1    
         .bss  _k,1
         .global  _k                      ;kǰ��_������
         
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
         
         
        
;��������[b,a]֮�������ĺ�
addition:
		MOV  #92,brc0
		MOV T1,T2
		MOV T1,T3
		rptblocal LOOP
		ADD #1,T2
LOOP:	ADD T2,T3
		MOV T3,*AR0+
      ret

;���� a-b�Ľ��
subtraction:
		SUB *AR5,*AR6,AC0
		MOV mmap(@AC0H),T2
		MOV T2,*AR0+
		MOV AR0,AR1
      ret

;���� a*b�Ľ��
multiplication:
		MOV T1,mmap(@AC1H)
		MPY T0,AC1,AC0
		MOV AC0,*AR0+
      ret          
         
;���� a/b�Ľ��
division:
        MOV *AR5,AC0
        RPT #15
        subc *ar6,ac0
        MOV AC0,*AR0+
        MOV HI(AC0),*AR0+

      ret
