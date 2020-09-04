#
# Copyright (C) 2019 The Lineageos Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

LOCAL_PATH_VENDOR := vendor/bq/mt8163

# Debugging tool
PRODUCT_PACKAGES += \
    debug_tool

# HDMI
PRODUCT_PACKAGES += \
    Overscan

# HDMI Packages
PRODUCT_PACKAGES += \
    hdmi \
    hdmimanager \
    libhdmiservice \
    libhdmi

# WFD
PRODUCT_PACKAGES += \
    audio.r_submix.mt8163

# Remove Unused/Useless packages
PRODUCT_PACKAGES += \
    RemovePackages

# MediaTekParts
PRODUCT_PACKAGES += \
    MediaTekParts

# Shim Symbols (common)
PRODUCT_PACKAGES += \
    libshim_bionic \
    libshim_atomic \
    libshim_audio \
    libshim_omx \
    libshim_camera \
    libshim_xlog \
    libshim_gps \
    libshim_program_binary_service \
    libshim_drm \
    libshim_media

# Init
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH_VENDOR)/proprietary/external/init/mediaserver.rc:system/etc/init/mediaserver.rc \
    $(LOCAL_PATH_VENDOR)/proprietary/external/init/audioserver.rc:system/etc/init/audioserver.rc

# Property Overrides
PRODUCT_PROPERTY_OVERRIDES += \
   ro.config.hw_quickpoweron=true \
   ro.build.shutdown_timeout=0

