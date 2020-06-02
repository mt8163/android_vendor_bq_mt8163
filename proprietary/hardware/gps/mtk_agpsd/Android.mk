LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE_CLASS = EXECUTABLES

LOCAL_MODULE = mtk_agpsd

LOCAL_SHARED_LIBRARIES = \
    libcrypto \
    libssl \
    libicuuc \
    libnetd_client \
    libandroid_net \
    libc++ \

LOCAL_MULTILIB = 32
LOCAL_SRC_FILES_32 = mtk_agpsd

LOCAL_INIT_RC := mtk_agpsd.rc
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_PATH = $(TARGET_OUT_VENDOR_EXECUTABLES)
include $(BUILD_PREBUILT)
