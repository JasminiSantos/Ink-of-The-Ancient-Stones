//
//  Data.swift
//  Ink of The Ancient Stones
//
//  Created by Jasmini Rebecca Gomes dos Santos on 29/06/24.
//

import SwiftUI
import UniformTypeIdentifiers

extension Data: Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .data) { data in
            return data
        }
    }
}

