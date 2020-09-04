/*
 * Copyright (C) 2020 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#define LOG_TAG "SurfaceControl_shim"

#include <inttypes.h>
#include <stdint.h>
#include <sys/types.h>
#include <sys/stat.h>

#include <android/native_window.h>

#include <utils/CallStack.h>
#include <utils/Errors.h>
#include <utils/Log.h>
#include <utils/threads.h>

#include <binder/IPCThreadState.h>

#include <ui/DisplayInfo.h>
#include <ui/GraphicBuffer.h>
#include <ui/Rect.h>

#include <gui/SurfaceComposerClient.h>

#include "media/SurfaceControl_shim.h"

using namespace android;
using android::sp;
using android::status_t;
using android::IBinder;
using android::IGraphicBufferConsumer;
using android::IGraphicBufferProducer;
using android::PixelFormat;
using android::Rect;
using android::SurfaceComposerClient;
//using android::SurfaceControl;

android::SurfaceComposerClient::Transaction *t;

/* Android N exports */
extern "C" {
    extern void _ZN7android14SurfaceControl8setLayerEi(int32_t) {}
    extern void _ZN7android14SurfaceControl7destroyEv(void);
    extern void *_ZN7android21SurfaceComposerClient23getPhysicalDisplayTokenEy(unsigned long long) { return 0 } /*FIXME*/

    void _ZN7android21SurfaceComposerClient13createSurfaceERKNS_7String8EjjijPNS_14SurfaceControlEjj(
	    android::String8 const & s,
	    uint32_t w,
	    uint32_t h,
	    android::PixelFormat fmt,
	    uint32_t flags,
	    void *parent,
	    uint32_t windowType,
	    uint32_t ownerUid) {/*FIXME*/}

    /* 
    * FUNCTION NAME: SurfaceComposerClient::CreateSurface::SurfaceControl.
    * USE: Creates a surface.
    * NOTES: It looks like this function was renamed in N. Stub out to the correct call.
    */

    void _ZN7android21SurfaceComposerClient13createSurfaceERKNS_7String8EjjijPNS_14SurfaceControlEii(
        const android::String8& name, // surface name.
        uint32_t w, // width in pixel
        uint32_t h, // height in pixel
        PixelFormat format, // pixel-format desired
        uint32_t flags, // usage flags
        SurfaceControl* /* parent */, // parent
        uint32_t /* windowtype */, // from WindowManager.java (STATUS_BAR, INPUT_METHOD, etc.)
        uint32_t /* ownerUID */) // UID of the task
    {
        /* sp<SurfaceControl> android::SurfaceComposerClient::createSurface(android::String8 const&, unsigned int, unsigned int, int, unsigned int) */
        _ZN7android21SurfaceComposerClient13createSurfaceERKNS_7String8EjjijPNS_14SurfaceControlEjj(name, w, h, format, flags, NULL, 0, 0);
    }

    /* 
    * FUNCTION NAME: SurfaceComposerClient::CreateSurface.
    * USE: Creates a surface.
    * NOTES: It looks like this function was renamed in N. Stub out to the correct call.
    */
    void _ZN7android21SurfaceComposerClient13createSurfaceERKNS_7String8Ejjij(android::String8 const& s, uint32_t w, uint32_t h,
        android::PixelFormat fmt, uint32_t flags) {
        /* sp<SurfaceControl> android::SurfaceComposerClient::createSurface(android::String8 const&, unsigned int, unsigned int, int, unsigned int) */
        _ZN7android21SurfaceComposerClient13createSurfaceERKNS_7String8EjjijPNS_14SurfaceControlEjj(s, w, h, fmt, flags, NULL, 0, 0);
    }

    /* 
     * FUNCTION NAME: SurfaceControl::setLayer.
     * USE: Sets a layer to the Surface.
     * NOTES: It looks like this function was renamed in N. Stub out to the correct call.
     */
    void _ZN7android14SurfaceControl8setLayerEj(uint32_t layer) {
        _ZN7android14SurfaceControl8setLayerEi(static_cast<uint32_t>(layer));
    }

    void _ZN7android21SurfaceComposerClient21openGlobalTransactionEv() {
        t = new(android::SurfaceComposerClient::Transaction);
    }

    void _ZN7android21SurfaceComposerClient20setDisplayProjectionERKNS_2spINS_7IBinderEEEjRKNS_4RectES8_(
        const sp<IBinder>& token, uint32_t orientation, const Rect& layerStackRect, const Rect& displayRect) {
      android::SurfaceComposerClient::Transaction t;
      t.setDisplayProjection(token, orientation, layerStackRect, displayRect);
      t.apply();
    }

    void _ZN7android21SurfaceComposerClient22closeGlobalTransactionEb() {
        t->apply();
        delete t;
        t = nullptr;
    }

    void _ZN7android14SurfaceControl5clearEv(void) {
        _ZN7android14SurfaceControl7destroyEv();
    }

    void *_ZN7android21SurfaceComposerClient17getBuiltInDisplayEi(int32_t id) {
        return _ZN7android21SurfaceComposerClient23getPhysicalDisplayTokenEy(static_cast<uint64_t>(id));
    }
}
