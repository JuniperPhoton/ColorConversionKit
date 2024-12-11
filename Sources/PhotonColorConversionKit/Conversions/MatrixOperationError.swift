//
//  MatrixOperationError.swift
//  PhotonColorConversionKit
//
//  Created by JuniperPhoton on 2024/12/11.
//
struct MatrixOperationError: Error, CustomStringConvertible {
    var description: String {
        "MatrixOperationError: \(message)"
    }
    
    public let message: String
    
    init(message: String) {
        self.message = message
    }
}
