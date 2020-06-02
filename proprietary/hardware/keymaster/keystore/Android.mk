LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_PROVIDES_KEYMASTER_HAL),false) 
include $(CLEAR_VARS)

LOCAL_MODULE := keystore.$(TARGET_BOARD_PLATFORM)
LOCAL_CFLAGS += -fvisibility=hidden -DLOG_TAG=\"KM_UREE\"
LOCAL_MODULE_RELATIVE_PATH := hw
LOCAL_PROPRIETARY_MODULE := true

LOCAL_SRC_FILES := \
       android_keymaster.cpp  \
       android_keymaster_messages.cpp \
	   android_keymaster_utils.cpp \
	   authorization_set.cpp \
	   keymaster_mtee_api.cpp \
	   serializable.cpp \
	   keymaster_hal.cpp

LOCAL_C_INCLUDES += \
    hardware/libhardware/include \
	$(LOCAL_PATH)/include/mtee \
	$(LOCAL_PATH)/include \
	$(LOCAL_PATH)/include/keymaster

LOCAL_SHARED_LIBRARIES += libcrypto liblog libutils libtz_uree

include $(BUILD_SHARED_LIBRARY)
endif
