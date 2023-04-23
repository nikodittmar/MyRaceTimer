//
//  CSV.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 2/18/23.
//

import UniformTypeIdentifiers
import SwiftUI
import Foundation

public struct CSV {
    let csvString: String
    
    func data() -> Data {
        return Data(csvString.utf8)
    }
}

extension CSV: Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .commaSeparatedText) { csvString in
            csvString.data()
        }
    }
}
