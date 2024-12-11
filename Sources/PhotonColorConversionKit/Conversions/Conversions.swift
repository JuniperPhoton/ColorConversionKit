import Foundation
import simd

/// Calculate the matrix for the linear RGB to CIE XYZ transformation.
///
/// Example code to calcualte the matrix for sRGB:
///
/// ```swift
/// let d65WhitePoint = [0.9505, 1.0, 1.0891]
///
/// matrix = calculateLinearRGBToCIEXYZMatrix(
///   xr: 0.64, yr: 0.33,
///   xg: 0.30, yg: 0.60,
///   xb: 0.1558, yb: 0.06,
///   Xw: d65WhitePoint[0], Yw: d65WhitePoint[1], Zw: d65WhitePoint[2]
/// )
/// ```
///
/// The result matrix can be used to:
///
/// 1. Use ``convertRGBToXYZ(rgb:matrix3x3:)`` to convert linear RGB to CIE XYZ.
/// 2. The inverse of the matrix can be used to convert CIE XYZ to linear RGB using ``convertXYZToRGB(xyz:matrix3x3:)``.
///
/// - parameter xr: x coords for the red primary.
/// - parameter yr: y coords for the red primary.
/// - parameter xg: x coords for the green primary.
/// - parameter yg: y coords for the green primary.
/// - parameter xb: x coords for the blue primary.
/// - parameter yb: y coords for the blue primary.
/// - parameter Xw: X for the white point.
/// - parameter Yw: Y for the white point.
/// - parameter Zw: Z for the white point.
/// - returns: The 3x3 matrix for the transformation.
///
/// See [Eqn_RGB_XYZ_Matrix](http://www.brucelindbloom.com/index.html?Eqn_RGB_XYZ_Matrix.html) for more information about the algorithm.
///
/// For more information, visit the [sRGB](https://en.wikipedia.org/wiki/SRGB) and [CIE Color Space](https://en.wikipedia.org/wiki/CIE_1931_color_space#) wiki.
public func calculateLinearRGBToCIEXYZMatrix(
    xr: Float, yr: Float,
    xg: Float, yg: Float,
    xb: Float, yb: Float,
    Xw: Float, Yw: Float, Zw: Float
) -> [Float] {
    let Xr: Float = xr / yr
    let Yr: Float = 1.0
    let Zr: Float = (1 - xr - yr) / yr
    
    let Xg: Float = xg / yg
    let Yg: Float = 1.0
    let Zg: Float = (1 - xg - yg) / yg
    
    let Xb: Float = xb / yb
    let Yb: Float = 1.0
    let Zb: Float = (1 - xb - yb) / yb
    
    let matrix = createRowMajor(matrix3x3: [Xr, Xg, Xb, Yr, Yg, Yb, Zr, Zg, Zb])
    let Srgb = matrix_multiply(matrix.inverse, simd_float3(Xw, Yw, Zw))
    
    let Sr = Srgb.x
    let Sg = Srgb.y
    let Sb = Srgb.z
    
    return [
        Sr * Xr, Sg * Xg, Sb * Xb,
        Sr * Yr, Sg * Yg, Sb * Yb,
        Sr * Zr, Sg * Zg, Sb * Zb
    ]
}

/// Linearize the sRGB value to the linear RGB value.
public func linearizeRGB(rgb: [Float]) -> [Float] {
    return rgb.map { $0 <= 0.04045 ? $0 / 12.92 : pow(($0 + 0.055) / 1.055, 2.4) }
}

/// Gamma encode the linear RGB value to the sRGB value.
public func gammaEncode(rgb: [Float]) -> [Float] {
    return rgb.map { $0 <= 0.0031308 ? $0 * 12.92 : 1.055 * pow($0, 1.0 / 2.4) - 0.055 }
}

/// Convert linear RGB to CIE XYZ based on the matrix.
///
/// - parameter rgb: Linear RGB value.
/// - parameter matrix: The matrix for the transformation.
/// This can be calculated by ``calculateLinearRGBToCIEXYZMatrix(xr:yr:zr:xg:yg:zg:xb:yb:zb:Xw:Yw:Zw:)``.
public func convertRGBToXYZ(rgb: [Float], matrix3x3: [Float]) -> (X: Float, Y: Float, Z: Float) {
    let matrix = createRowMajor(matrix3x3: matrix3x3)
    let xyz = matrix * SIMD3<Float>(Float(rgb[0]), Float(rgb[1]), Float(rgb[2]))
    return (Float(xyz.x), Float(xyz.y), Float(xyz.z))
}

/// Convert CIE XYZ to linear RGB based on the matrix.
///
/// - parameter xyz: XYZ value.
/// - parameter matrix: The matrix for the transformation.
/// This can be calculated by ``calculateLinearRGBToCIEXYZMatrix(xr:yr:zr:xg:yg:zg:xb:yb:zb:Xw:Yw:Zw:)``. The matrix will
/// be inversed internally.
public func convertXYZToRGB(xyz: [Float], matrix3x3: [Float]) throws -> [Float] {
    let m = createRowMajor(matrix3x3: matrix3x3)
    
    let determinant = m.determinant
    if determinant == 0 {
        throw MatrixOperationError(message: "Matrix is not invertible.")
    }
    
    let inv = try inverse(matrix3x3: matrix3x3)
    let rgb = createRowMajor(matrix3x3: inv) * SIMD3<Float>(Float(xyz[0]), Float(xyz[1]), Float(xyz[2]))
    
    return [Float(rgb.x), Float(rgb.y), Float(rgb.z)]
}

/// Convert CIE XYZ to xyY.
public func convertXYZToXYY(xyz: [Float]) -> (x: Float, y: Float, Y: Float) {
    let sum = xyz[0] + xyz[1] + xyz[2]
    let x = xyz[0] / sum
    let y = xyz[1] / sum
    
    return (x, y, xyz[1])
}

/// Convert xyY to CIE XYZ.
public func convertXYYToXYZ(xyy: (x: Float, y: Float, Y: Float)) -> (X: Float, Y: Float, Z: Float) {
    let x = xyy.x
    let y = xyy.y
    let Y = xyy.Y
    return (x * Y / y, Y, (1 - x - y) * Y / y)
}
