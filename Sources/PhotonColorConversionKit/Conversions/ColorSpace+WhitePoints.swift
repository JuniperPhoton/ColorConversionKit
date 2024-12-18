//
//  ColorSpace+WhitePoints.swift
//  PhotonColorConversionKit
//
//  Created by JuniperPhoton on 2024/12/11.
//
import CoreGraphics

public extension CGColorSpace {
    /// The D65 white point in CIE XYZ Color Space.
    static var d65WhitePoint: WhitePoint {
        WhitePoint(x: 0.9505, y: 1.0, z: 1.0891)
    }
    
    /// The D50 white point in CIE XYZ Color Space.
    static var d50WhitePoint: WhitePoint {
        WhitePoint(x: 0.9642, y: 1.0, z: 0.8249)
    }
}
