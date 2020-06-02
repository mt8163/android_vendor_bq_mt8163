LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_PROVIDES_KEYMASTER_HAL),false)
include $(CLEAR_VARS)

LOCAL_MODULE := libtz_uree
LOCAL_MODULE_TAGS := optional

LOCAL_SRC_FILES := \
     uree.c \
     uree_mem.c \
     dump_sec_mem.c \
     uree_dbg.c

LOCAL_C_INCLUDES += \
    $(LOCAL_PATH)/include

LOCAL_CFLAGS += -Wall -Wno-unused-parameter -Werror
LOCAL_SHARED_LIBRARIES += liblog

include $(BUILD_SHARED_LIBRARY)
endif
