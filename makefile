TARGET = STM32F1Prj

#ָ��������
CC = arm-none-eabi-gcc
#���
AS = arm-none-eabi-gcc -x assember-with-cpp
#��ʽת��elf
CP = arm-none-eabi-objcopy
#����洢����
SZ = arm-none-eabi-size

#�ļ���ʽת��
HEX = $(CP) -O ihex
BIN = $(CP) -O binary -S

#CPU
CPU = -mcpu=cortex-m3
#����ѡ��Ƿ�debugģʽ�����DEBUG=1,����Ժ���ʹ�õ������gdb�ȹ��߽������ߵ���
#���DEBUG=0,����֧�����ߵ��ԣ�
#��DEBUG=1,���ɵ��ļ���DEBUG=0����Ϊ��������˵�����Ϣ��
DEBUG = 1

# optimization
#����ѡ��Ż��ȼ�
#-O0�����κ��Ż���
#-O1��1���Ż�,
#-O2: 2���Ż�,
#-Os: 2.5���Ż�,
#-O3: ��߼��Ż���
OPT = -O0

#����
AS_DEFS = 
#C��
C_DEFS = 

#ͷ�ļ�����·��
C_INCLUDES = \
-IDriver/inc \
-ILib/inc \
-ICMSIS/