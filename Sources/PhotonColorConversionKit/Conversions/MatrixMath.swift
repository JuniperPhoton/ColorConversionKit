//
//  MatrixMath.swift
//  PhotonColorConversionKit
//
//  Created by JuniperPhoton on 2024/12/11.
//
import simd
import Foundation

public extension [Float] {
    /// Treat it self as a 3x3 matrix and inverse the matrix.
    ///
    /// - throws: If the matrix is not invertible, it throws an error.
    func inverse() throws -> [Float] {
        guard self.count == 9 else {
            throw MatrixOperationError(message: "The matrix must have 9 elements.")
        }
        return try inverseUsingSIMD(matrix3x3: self)
    }
}

/// Create a matrix from the given array.
public func createRowMajor(matrix3x3: [Float]) -> matrix_float3x3 {
    matrix_float3x3(rows: [
        SIMD3<Float>(Float(matrix3x3[0]), Float(matrix3x3[1]), Float(matrix3x3[2])),
        SIMD3<Float>(Float(matrix3x3[3]), Float(matrix3x3[4]), Float(matrix3x3[5])),
        SIMD3<Float>(Float(matrix3x3[6]), Float(matrix3x3[7]), Float(matrix3x3[8]))
    ])
}

/// Inverse the matrix using SIMD.
///
/// - throws: If the matrix is not invertible, it throws an error.
public func inverseUsingSIMD(matrix3x3: [Float]) throws -> [Float] {
    let matrix = createRowMajor(matrix3x3: matrix3x3)
    if matrix.determinant == 0 {
        throw MatrixOperationError(message: "The matrix is not invertible.")
    }
    
    let inversed = matrix.inverse
    return [
        inversed.columns.0.x, inversed.columns.1.x, inversed.columns.2.x,
        inversed.columns.0.y, inversed.columns.1.y, inversed.columns.2.y,
        inversed.columns.0.z, inversed.columns.1.z, inversed.columns.2.z
    ]
}

/// Not intended to be used in production. There is a built-in function in simd for this.
func inverse(matrix3x3: [Float]) throws -> [Float] {
    var inv: [Float] = Array(repeating: 0, count: 9)
    let m: [[Float]] = [
        [matrix3x3[0], matrix3x3[1], matrix3x3[2]],
        [matrix3x3[3], matrix3x3[4], matrix3x3[5]],
        [matrix3x3[6], matrix3x3[7], matrix3x3[8]]
    ]
    
    let det = createRowMajor(matrix3x3: matrix3x3).determinant
    
    if (det == 0.0) {
        throw MatrixOperationError(message: "The matrix is not invertible.")
    }
    
    // Calculate the inverse using the adjugate method
    inv[0] = (m[1][1] * m[2][2] - m[1][2] * m[2][1]) / det;
    inv[1] = (m[0][2] * m[2][1] - m[0][1] * m[2][2]) / det;
    inv[2] = (m[0][1] * m[1][2] - m[0][2] * m[1][1]) / det;
    
    inv[3] = (m[1][2] * m[2][0] - m[1][0] * m[2][2]) / det;
    inv[4] = (m[0][0] * m[2][2] - m[0][2] * m[2][0]) / det;
    inv[5] = (m[0][2] * m[1][0] - m[0][0] * m[1][2]) / det;
    
    inv[6] = (m[1][0] * m[2][1] - m[1][1] * m[2][0]) / det;
    inv[7] = (m[0][1] * m[2][0] - m[0][0] * m[2][1]) / det;
    inv[8] = (m[0][0] * m[1][1] - m[0][1] * m[1][0]) / det;
    
    return inv;
}

/// Not intended to be used in production. There is a built-in function in simd for this.
func multiply(left: [Float], right: [Float]) -> [Float] {
    let l = createRowMajor(matrix3x3: left)
    let r = createRowMajor(matrix3x3: right)
    let result = l * r
    return [
        result.columns.0.x, result.columns.1.x, result.columns.2.x,
        result.columns.0.y, result.columns.1.y, result.columns.2.y,
        result.columns.0.z, result.columns.1.z, result.columns.2.z
    ]
}
