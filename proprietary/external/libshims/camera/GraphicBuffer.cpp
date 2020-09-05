#include <gui/BufferQueue.h>
#include <gui/SurfaceComposerClient.h>
#include <gui/ISurfaceComposer.h>
#include <utils/Errors.h>
#include <utils/String8.h>
#include <utils/StrongPointer.h>

#include <private/gui/ComposerService.h>

#include <string>

using android::sp;
using android::status_t;
using android::IBinder;

// GraphicBuffer(uint32_t inWidth, uint32_t inHeight, PixelFormat inFormat,
//               uint32_t inUsage, std::string requestorName = "<Unknown>");
extern "C" void _ZN7android13GraphicBufferC1EjjijNSt3__112basic_stringIcNS1_11char_traitsIcEENS1_9allocatorIcEEEE(
    uint32_t inWidth, uint32_t inHeight, android::PixelFormat inFormat,
    uint32_t inUsage, std::string requestorName = "<Unknown>");

extern "C" void _ZN7android13GraphicBufferC1Ejjij(
    uint32_t inWidth, uint32_t inHeight, android::PixelFormat inFormat,
    uint32_t inUsage) {
  _ZN7android13GraphicBufferC1EjjijNSt3__112basic_stringIcNS1_11char_traitsIcEENS1_9allocatorIcEEEE(
      inWidth, inHeight, inFormat, inUsage);
}
