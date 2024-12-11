#ifndef PhotonColorConversion
#define PhotonColorConversion

#ifdef __METAL_VERSION__
#include <metal_stdlib>
#include <CoreImage/CoreImage.h>
using namespace metal;

namespace photoncolorconversion {
    /*
     Convert RGB to XYZ using the matrix.
     */
    METAL_FUNC float3 convertRGBToXYZ(float3 rgb, float3x3 m1) {
        float3 xyz = m1 * rgb;
        return xyz;
    }

    /*
     Convert XYZ back to RGB using the matrix.
     */
    METAL_FUNC float3 convertXYZToRGB(float3 xyz, float3x3 m2I) {
        float3 rgb = m2I * xyz;
        return rgb;
    }

    METAL_FUNC float linearize(float v) {
        if (v <= 0.04045) {
            return v / 12.92;
        } else {
            return pow((v + 0.055) / 1.055, 2.4);
        }
    }
    
    METAL_FUNC float3 linearize(float3 rgb) {
        return float3(linearize(rgb.r), linearize(rgb.g), linearize(rgb.b));
    }
    
    METAL_FUNC float gammaEncode(float v) {
        if (v <= 0.0031308) {
            return 12.92 * v;
        } else {
            return 1.055 * pow(v, 1.0 / 2.4) - 0.055;
        }
    }
    
    METAL_FUNC float3 gammaEncode(float3 linear) {
        return float3(gammaEncode(linear.r), gammaEncode(linear.g), gammaEncode(linear.b));
    }
}
#endif /* __METAL_VERSION__ */

int myFoo() {
    return 2;
}

#endif /* PhotonColorConversion */
