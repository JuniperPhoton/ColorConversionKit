import Testing
@testable import PhotonColorConversionKit

@Test func testCalculateLinearRGBToCIEXYZMatrix() async throws {
    let d65WhitePoint: [Float] = [0.9505, 1.0, 1.0891]
    
    let matrix = calculateLinearRGBToCIEXYZMatrix(
        xr: 0.64, yr: 0.33,
        xg: 0.30, yg: 0.60,
        xb: 0.15, yb: 0.06,
        Xw: d65WhitePoint[0], Yw: d65WhitePoint[1], Zw: d65WhitePoint[2]
    )
    
    #expect(matrix.count == 9)
    #expect(abs(matrix[0] - 0.4124) < 0.001)
    #expect(abs(matrix[1] - 0.3576) < 0.001)
    #expect(abs(matrix[2] - 0.1805) < 0.001)
    #expect(abs(matrix[3] - 0.2126) < 0.001)
    #expect(abs(matrix[4] - 0.7152) < 0.001)
    #expect(abs(matrix[5] - 0.0722) < 0.001)
    #expect(abs(matrix[6] - 0.0193) < 0.001)
    #expect(abs(matrix[7] - 0.1192) < 0.001)
    #expect(abs(matrix[8] - 0.9505) < 0.001)
}

@Test func testRGBCIEConversion() async throws {
    let d65WhitePoint: [Float] = [0.9505, 1.0, 1.0891]
    
    let matrix = calculateLinearRGBToCIEXYZMatrix(
        xr: 0.64, yr: 0.33,
        xg: 0.30, yg: 0.60,
        xb: 0.15, yb: 0.06,
        Xw: d65WhitePoint[0], Yw: d65WhitePoint[1], Zw: d65WhitePoint[2]
    )
    
    let sRGBColor: [Float] = [0.5, 0.5, 0.5]
    let xyz = convertRGBToXYZ(rgb: sRGBColor, matrix3x3: matrix)
    let xyy = convertXYZToXYY(xyz: [xyz.X, xyz.Y, xyz.Z])
    let convertedBackXYZ = convertXYYToXYZ(xyy: xyy)
    let convertedBackRGB = try convertXYZToRGB(
        xyz: [convertedBackXYZ.X, convertedBackXYZ.Y, convertedBackXYZ.Z],
        matrix3x3: matrix
    )
    
    #expect(abs(sRGBColor[0] - convertedBackRGB[0]) < 0.001)
    #expect(abs(sRGBColor[1] - convertedBackRGB[1]) < 0.001)
    #expect(abs(sRGBColor[2] - convertedBackRGB[2]) < 0.001)
    
    #expect(abs(xyz.X - convertedBackXYZ.X) < 0.001)
    #expect(abs(xyz.Y - convertedBackXYZ.Y) < 0.001)
    #expect(abs(xyz.Z - convertedBackXYZ.Z) < 0.001)
    
    #expect(abs(xyy.x - xyy.x) < 0.001)
    #expect(abs(xyy.y - xyy.y) < 0.001)
    #expect(abs(xyy.Y - xyy.Y) < 0.001)
}

@Test func testGammaCorrection() async throws {
    let sRGBColor: [Float] = [0.5, 0.5, 0.5]
    let gammaCorrected = linearizeRGB(rgb: sRGBColor)
    let convertedBack = gammaEncode(rgb: gammaCorrected)
    
    #expect(abs(sRGBColor[0] - convertedBack[0]) < 0.001)
    #expect(abs(sRGBColor[1] - convertedBack[1]) < 0.001)
    #expect(abs(sRGBColor[2] - convertedBack[2]) < 0.001)
}

@Test func testMatrix() async throws {
    let matrix: [Float] = [
        0.4124, 0.3576, 0.1805,
        0.2126, 0.7152, 0.0722,
        0.0193, 0.1192, 0.9505
    ]
    
    let inverse = try inverse(matrix3x3: matrix)
    let multiplied = multiply(left: matrix, right: inverse)
    
    print("multiplied \(multiplied)")
    
    #expect(multiplied.count == 9)
    #expect(abs(multiplied[0] - 1) < 0.001)
    #expect(abs(multiplied[1] - 0) < 0.001)
    #expect(abs(multiplied[2] - 0) < 0.001)
    #expect(abs(multiplied[3] - 0) < 0.001)
    #expect(abs(multiplied[4] - 1) < 0.001)
    #expect(abs(multiplied[5] - 0) < 0.001)
    #expect(abs(multiplied[6] - 0) < 0.001)
    #expect(abs(multiplied[7] - 0) < 0.001)
    #expect(abs(multiplied[8] - 1) < 0.001)
}
