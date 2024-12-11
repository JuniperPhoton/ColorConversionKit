//
//  ColorSpace+WhitePoints.swift
//  PhotonColorConversionKit
//
//  Created by JuniperPhoton on 2024/12/11.
//
import CoreGraphics

public extension CGColorSpace {
    /// The D65 white point in CIE XYZ Color Space.
    static var d65WhitePoint: [Float] {
        [0.9505, 1.0, 1.0891]
    }
    
    /// The D50 white point in CIE XYZ Color Space.
    static var d50WhitePoint: [Float] {
        [0.9642, 1.0, 0.8249]
    }
}
