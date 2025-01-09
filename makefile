TARGET = STM32F1Prj

#指定编译器
CC = arm-none-eabi-gcc
#汇编
AS = arm-none-eabi-gcc -x assember-with-cpp
#格式转换elf
CP = arm-none-eabi-objcopy
#计算存储分配
SZ = arm-none-eabi-size

#文件格式转换
HEX = $(CP) -O ihex
BIN = $(CP) -O binary -S

#CPU
CPU = -mcpu=cortex-m3
#编译选项：是否debug模式，如果DEBUG=1,则可以后续使用调试软件gdb等工具进行在线调试
#如果DEBUG=0,则不能支持在线调试，
#且DEBUG=1,生成的文件比DEBUG=0大，因为里面包含了调试信息。
DEBUG = 1

# optimization
#编译选项：优化等级
#-O0：无任何优化，
#-O1：1级优化,
#-O2: 2级优化,
#-Os: 2.5级优化,
#-O3: 最高级优化。
OPT = -O0

#汇编宏
AS_DEFS = 
#C宏
C_DEFS = 

#头文件搜索路径
C_INCLUDES = \
-IDriver/inc \
-ILib/inc \
-ICMSIS/