# ``PhotonColorConversionKit``

Provides some functions and extensions for converting RGB value to CIE Color Space.

More basic information can be found in the [sRGB](https://en.wikipedia.org/wiki/SRGB) and [CIE Color Space](https://en.wikipedia.org/wiki/CIE_1931_color_space#) wiki.

Normally the conversion chain would be:

1. sRGB -> LinearRGB -> XYZ -> xyY
2. xyY -> XYZ -> LinearRGB -> sRGB

The xy in xyY is the corresponding chromaticity coordinates of the color.
The tristimulus values are the XYZ values.

![](srgb.jpg)

> The image above shows the sRGB color gamut in the CIE Color Space.
The red primary is at (0.64, 0.33), the green primary is at (0.30, 0.60), and the blue primary is at (0.15, 0.06).

You use the following methods to convert between these values:

1. ``linearizeRGB(rgb:)``
2. ``convertRGBToXYZ(rgb:matrix3x3:)``
3. ``convertXYZToXYY(xyz:)``

You use the following methods to convert back between these values:
1. ``convertXYYToXYZ(xyy:)``
2. ``convertXYZToRGB(xyz:matrix3x3:)``
3. ``gammaEncode(rgb:)``

If you are calibrating the color primaries, you can use ``calculateLinearRGBToCIEXYZMatrix(xr:yr:xg:yg:xb:yb:Xw:Yw:Zw:)`` to calculate the matrix.

> Warning: Be careful of the color management when using Core Image and Metal to render
and display images. For example, CIContext's default working space is linear sRGB,
so if you are working in the default color space, the RGBA value sampled are already linear.

> There are some corresponding Metal Methods in the `PhotonColorConversionKitC` target. For Swift, you use the `PhotonColorConversionKit` target.
