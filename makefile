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
#Ҫ�����C�ļ�
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
-ILib/CMSIS \
-IILib/inc \
-IOS/include \
-IOS/port/RVDS \


#buid·��
BUILD_DIR = Build
#���ӽű�
LDSCRIPT = 

MCU = $(CPU) -mthumb
#���
ASFLAGS = $(MCU) $(AS_DEFS) $(OPT) -Wall -fdata-sections -ffunction-sections
#C����
CFLAGS = $(MCU) $(C_DEFS) $(C_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections

#�Ƿ�DEBUGģʽ����
#ifeq($(DEBUG),1)
#CFLAGS += -g -gdwarf-2
#endif

#����.d�����ļ�
CFLAGS += -MMD -MP -MF"$(@:%.o=%.d)"

#��׼��
LIBS = -lc -lm -lnosys
#ָ����
LIBDIR = 

#����
#-specs=nano.specs �����C�� ��
#-T$(LDSCRIPT)�����Ŀ�ִ���ļ����ӽű���
#$(LIBDIR) ��׼���ļ� �� $(LIBS) ָ�����ļ� ��
#-Wl,-Map=$(BUILD_DIR)/$(TARGET).map,--cref ����map�ļ� ��
#-Wl,--gc-sections ����ʹ�õķֶη�ʽ����Ҫ���C�ļ�/�������obj��ʱ��ͬ��ѡ�ͷֶη�ʽ���ô������ӵ�ʱ��Դ�ļ��е�δʹ�ñ�����δ���ú��������ᱻ���ӵ�elf�ļ��У����տ�ִ���ļ�elf��ܾ���
LDFLAGS = $(MCU) -spacs=nano,specs -T$(LDSCRIPT) $(LIBDIR) $(LIBS) -Wl,-Map=$(BUILD_DIR)/$(TARGET).map,--cref -Wl,--gc-sections

all:$(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).hex $(BUILD_DIR)/$(TARGET).bin

#C��Ϊ.o�ļ�
OBJECT = $(addprefix $(BUILD_DIR)/,$(notdir $(C_SOURCE:.c=.o)))
#C�ļ�����·��
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