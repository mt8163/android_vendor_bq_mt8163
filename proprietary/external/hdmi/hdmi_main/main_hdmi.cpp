/*
**
** Copyright 2008, The Android Open Source Project
**
** Licensed under the Apache License, Version 2.0 (the "License");
** you may not use this file except in compliance with the License.
** You may obtain a copy of the License at
**
**     http://www.apache.org/licenses/LICENSE-2.0
**
** Unless required by applicable law or agreed to in writing, software
** distributed under the License is distributed on an "AS IS" BASIS,
** WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
** See the License for the specific language governing permissions and
** limitations under the License.
*/

// System headers required for setgroups, etc.
#include <sys/types.h>
#include <string.h>
#include <stdio.h>
#include <unistd.h>
#include <grp.h>
//#include <linux/rtpm_prio.h>
#include <sys/prctl.h>

#include <binder/IPCThreadState.h>
#include <binder/ProcessState.h>
#include <binder/IServiceManager.h>
#include <utils/Log.h>
#include <cutils/properties.h>

#ifdef MTK_HDMI_SUPPORT
#include "MtkHdmiService.h"
#endif

#define HDMI_CONTROL_PROP "persist.hdmi.enabled"

using namespace android;

int main(int argc, char **argv)
{
    char hdmi_ctl[1024];
    __system_property_get(HDMI_CONTROL_PROP, hdmi_ctl);

    ALOGI("[MtkHdmiService] hdmi_ctl=%s", hdmi_ctl);

    if (strcmp(hdmi_ctl, "0") == 0) {
        ALOGI("[MtkHdmiService] HDMI is disabled by property (%s), bailing out...", hdmi_ctl);
        return -1;
    }

    sp<ProcessState> proc(ProcessState::self());
    sp<IServiceManager> sm = defaultServiceManager();
    ALOGI("[MtkHdmiService]ServiceManager: %p", sm.get());

#ifdef MTK_HDMI_SUPPORT
    ALOGI("[MtkHdmiService] register");
    MtkHdmiService::initial();
#endif

    ProcessState::self()->startThreadPool();
    IPCThreadState::self()->joinThreadPool();
}
