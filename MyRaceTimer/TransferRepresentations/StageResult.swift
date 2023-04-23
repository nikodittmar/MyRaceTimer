//
//  StageResult.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 2/16/23.
//

import UniformTypeIdentifiers
import SwiftUI
import Foundation

//extension UTType {
//    static var result: UTType { UTType(exportedAs: "com.nikodittmar.MyRaceTimer.result") }
//}

//struct StageResult: Codable, Identifiable {
//    var id = UUID()
//    var name: String
//    var start: Bool
//    var recordings: [Recording]
//
//    func plateList() -> [String] {
//        var plateList: [String] = []
//        for recording in recordings {
//            if recording.plate != "" {
//                plateList.append(recording.plate)
//            }
//        }
//        return plateList
//    }
//
//    func duplicatePlateNumbers() -> Bool {
//        return self.plateList().hasDuplicates()
//    }
//
//    func missingPlateNumbers() -> Bool {
//        return self.plateList().count < recordings.count
//    }
//
//    func isDuplicate(_ plate: String) -> Bool {
//        if plate.occurrencesIn(self.plateList()) > 1 {
//            return true
//        } else {
//            return false
//        }
//    }
//}
//
//struct Recordingn: Codable, Identifiable {
//    var id = UUID()
//    var plate: String
//    var timestamp: Double
//}

//extension Result: Transferable, Codable {
//    public static var transferRepresentation: some TransferRepresentation {
//        CodableRepresentation(contentType: .result)
//    }
//}
