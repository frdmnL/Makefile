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
#要编译的C文件
C_SOURCE = \
main.c \
Driver/src/bsp_led.c \
Lib/CMSIS/core_cm3.c \
Lib/CMSIS/system_stm32f10x.c \
FWlib/src/misc.c \
FWlib/src/stm32f10x_gpio.c \
OS/port/MemMang/heap3.c \
OS/port/MemMang/heap4.c \
OS/port/RVDS/port.c \
OS/src/task.c \


ASM_SOURCE = startup_stm32f10x_ld.s
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
-ILib/CMSIS \
-IILib/inc \
-IOS/include \
-IOS/port/RVDS \


#buid路径
BUILD_DIR = Build
#链接脚本
LDSCRIPT = 

MCU = $(CPU) -mthumb
#汇编
ASFLAGS = $(MCU) $(AS_DEFS) $(OPT) -Wall -fdata-sections -ffunction-sections
#C编译
CFLAGS = $(MCU) $(C_DEFS) $(C_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections

#是否DEBUG模式编译
#ifeq($(DEBUG),1)
#CFLAGS += -g -gdwarf-2
#endif

#生成.d依赖文件
CFLAGS += -MMD -MP -MF"$(@:%.o=%.d)"

#标准库
LIBS = -lc -lm -lnosys
#指定库
LIBDIR = 

#链接
#-specs=nano.specs 精简版C库 ，
#-T$(LDSCRIPT)依赖的可执行文件链接脚本，
#$(LIBDIR) 标准库文件 ， $(LIBS) 指定库文件 ，
#-Wl,-Map=$(BUILD_DIR)/$(TARGET).map,--cref 生成map文件 ，
#-Wl,--gc-sections 链接使用的分段方式，需要配合C文件/汇编生成obj的时候同样选型分段方式，好处是链接的时候源文件中的未使用变量和未调用函数将不会被链接到elf文件中，最终可执行文件elf会很精简。
LDFLAGS = $(MCU) -spacs=nano,specs -T$(LDSCRIPT) $(LIBDIR) $(LIBS) -Wl,-Map=$(BUILD_DIR)/$(TARGET).map,--cref -Wl,--gc-sections

all:$(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).hex $(BUILD_DIR)/$(TARGET).bin

#C变为.o文件
OBJECT = $(addprefix $(BUILD_DIR)/,$(notdir $(C_SOURCE:.c=.o)))
#C文件搜索路径
vpath %.c $(sort $(dir $(C_SOURCE)))

OBJECT += $(addprefix $(BUILD_DIR)/,$(notdir $(ASM_SOURCE:.s=.o)))
vpath %.s $(sort $(dir $(ASM_SOURCE)))

#.c->.o
$(BUILD_DIR)/%.o: %.c Makefile | $(BUILD_DIR) 
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/$(notdir $(<:.c=.lst)) $< -o $@
#.s->.o
$(BUILD_DIR)/%.o: %.s Makefile | $(BUILD_DIR) 
	$(AS) -c $(ASFLAGS) $< -o $@
#.o->.elf
$(BUILD_DIR)/$(TARGET).elf: $(OBJECT) Makefile
	$(CC) $(OBJECT) $(LDFLAGS) -o $@
	$(SZ) $@

#.hex
$(BUILD_DIR)/%.hex: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(HEX) $< $@

#.bin
$(BUILD_DIR)/%.bin: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(BIN) $< $@

$(BUILD_DIR):
	mkdir $@

clean:
	-rm -fR $(BUILD_DIR)

-include $(wildcard $(BUILD_DIR)/*.d)