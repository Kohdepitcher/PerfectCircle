//
//  PNG.swift
//  PerfectCircle
//
//  Created by Kohde Pitcher on 11/2/2024.
//

import Foundation
import SwiftUI

/// A struct that holds png image data.
struct PNG {
    private let data: Data

    init(_ data: Data) {
        self.data = data
    }
}

// Transferable conformance, providing a DataRepresentation for ImageData.
@available(iOS 16.0, *)
extension PNG: Transferable {

    static var transferRepresentation: some TransferRepresentation {
        
        DataRepresentation<PNG>(contentType: .png) { imageData in
            imageData.data
        } importing: { data in
            PNG(data)
        }
    }
}
