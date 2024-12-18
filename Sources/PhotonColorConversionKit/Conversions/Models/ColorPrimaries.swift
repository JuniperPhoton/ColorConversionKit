//
//  ColorPrimaries.swift
//  PhotonColorConversionKit
//
//  Created by JuniperPhoton on 2024/12/18.
//
import Foundation

public struct PrimaryCoord: Equatable, Hashable {
    /// The sRGB red primary.
    public static let sRGBRed = PrimaryCoord(x: 0.64, y: 0.33)
    
    /// The sRGB green primary.
    public static let sRGBGreen = PrimaryCoord(x: 0.30, y: 0.60)
    
    /// The sRGB blue primary.
    public static let sRGBBlue = PrimaryCoord(x: 0.15, y: 0.06)
    
    public let x: Float
    public let y: Float
    
    public init(x: Float, y: Float) {
        self.x = x
        self.y = y
    }
}

public struct ColorPrimaries: Equatable, Hashable {
    /// The sRGB color space primaries.
    public static let sRGB = ColorPrimaries(
        red: .sRGBRed,
        green: .sRGBGreen,
        blue: .sRGBBlue
    )
    
    public let red: PrimaryCoord
    public let green: PrimaryCoord
    public let blue: PrimaryCoord
    
    public init(red: PrimaryCoord, green: PrimaryCoord, blue: PrimaryCoord) {
        self.red = red
        self.green = green
        self.blue = blue
    }
}
