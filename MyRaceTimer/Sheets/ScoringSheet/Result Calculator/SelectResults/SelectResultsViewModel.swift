////
////  SelectRecordingSetsViewModel.swift
////  MyRaceTimer
////
////  Created by niko dittmar on 4/23/23.
////
//
//import Foundation
//import SwiftUI
//
//@MainActor class SelectRecordingSetsViewModel: ObservableObject {
//    @Published var navigatingToPairRecordingSets: Bool = false
//    @Published var presentingUnequalSelectionWarning: Bool = false
//    
//    func next(selectedRecordingSets: [RecordingSet]) {
//        var startCount = 0
//        var finishCount = 0
//        
//        for RecordingSet in selectedRecordingSets {
//            if RecordingSet.wrappedType == RecordingsType.Start {
//                startCount += 1
//            } else {
//                finishCount += 1
//            }
//        }
//        
//        if startCount == finishCount {
//            navigatingToPairRecordingSets = true
//        } else {
//            presentingUnequalSelectionWarning = true
//        }
//    }
//}
