//
//  WhitePoint.swift
//  PhotonColorConversionKit
//
//  Created by JuniperPhoton on 2024/12/18.
//
import Foundation

/// Represents a white point in the CIE XYZ Color Space.
public struct WhitePoint: Equatable, Hashable {
    public let x: Float
    public let y: Float
    public let z: Float
    
    /// Get the XYY representations of this white point.
    public var xyY: (x: Float, y: Float, Y: Float) {
        convertXYZToXYY(xyz: [x, y, z])
    }
}
