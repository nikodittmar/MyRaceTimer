//
//  StageResult.swift
//  Race Timer
//
//  Created by niko dittmar on 2/16/23.
//

import UniformTypeIdentifiers
import SwiftUI
import Foundation

extension UTType {
    static var stageresult: UTType { UTType(exportedAs: "com.nikodittmar.JMPEnduroTiming.stageresult") }
}

struct StageResult: Codable, Identifiable {
    var id = UUID()
    var name: String
    var start: Bool
    var recordings: [Recording]
}

struct Recording: Codable, Identifiable {
    var id = UUID()
    var plate: String
    var timestamp: Double
}

extension StageResult: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .stageresult)
    }
}
