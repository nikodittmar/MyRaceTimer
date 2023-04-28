////
////  SelectRecordingsViewModel.swift
////  MyRaceTimer
////
////  Created by niko dittmar on 2/18/23.
////
//
//import Foundation
//import SwiftUI
//
//@MainActor class RecordingSetCalculatorViewModel: ObservableObject {
//    
//    @Published var RecordingSetPairs: [RecordingSetPair] = []
//    @Published var selectedRecordingSets: [RecordingSet] = []
//    
//    @Published var selectedRecordingSetForPairing: RecordingSet?
//    
//    func toggleRecordingSetSelection(RecordingSet: RecordingSet) {
//        if selectedRecordingSets.contains(RecordingSet) {
//            selectedRecordingSets = selectedRecordingSets.filter {
//                $0 != RecordingSet
//            }
//        } else {
//            selectedRecordingSets.append(RecordingSet)
//        }
//    }
//    
//    func RecordingSetLabel(RecordingSet: RecordingSet) -> String {
//        let RecordingsType: String = RecordingSet.wrappedType.rawValue.capitalized
//        let recordingCount: Int = RecordingSet.wrappedRecordings.count
//        var RecordingSetLabel: String = ""
//        
//        if recordingCount == 1 {
//            RecordingSetLabel = "\(recordingCount) Recording, Stage " + RecordingsType
//        } else {
//            RecordingSetLabel =  "\(recordingCount) Recordings, Stage " + RecordingsType
//        }
//        
//        return RecordingSetLabel
//    }
//    
//    func deleteRecordingSetPair(RecordingSetPair: RecordingSetPair) {
//        RecordingSetPairs = RecordingSetPairs.filter {
//            $0.id != RecordingSetPair.id
//        }
//        selectedRecordingSets.append(RecordingSetPair.start)
//        selectedRecordingSets.append(RecordingSetPair.finish)
//    }
//    
//    func selectRecordingSetForPairing(RecordingSet: RecordingSet) {
//        if let selectedRecordingSet = selectedRecordingSetForPairing {
//            if selectedRecordingSet == RecordingSet {
//                selectedRecordingSetForPairing = nil
//            } else {
//                if selectedRecordingSet.wrappedType != RecordingSet.wrappedType {
//                    if selectedRecordingSet.wrappedType == RecordingsType.Start {
//                        let RecordingSetPair = RecordingSetPair(start: selectedRecordingSet, finish: RecordingSet)
//                        RecordingSetPairs.append(RecordingSetPair)
//                        selectedRecordingSets = selectedRecordingSets.filter {
//                            $0.wrappedId != selectedRecordingSet.wrappedId &&  $0.wrappedId != RecordingSet.wrappedId
//                        }
//                        selectedRecordingSetForPairing = nil
//                    } else {
//                        let RecordingSetPair = RecordingSetPair(start: RecordingSet, finish: selectedRecordingSet)
//                        RecordingSetPairs.append(RecordingSetPair)
//                        selectedRecordingSets = selectedRecordingSets.filter {
//                            $0.wrappedId != selectedRecordingSet.wrappedId &&  $0.wrappedId != RecordingSet.wrappedId
//                        }
//                        selectedRecordingSetForPairing = nil
//                    }
//                }
//            }
//        } else {
//            selectedRecordingSetForPairing = RecordingSet
//        }
//    }
//    
//    func RecordingSetIsAvailibleForPairing(RecordingSet: RecordingSet) -> Bool {
//        if let selectedRecordingSet = selectedRecordingSetForPairing {
//            if selectedRecordingSet.wrappedId == RecordingSet.wrappedId {
//                return true
//            } else {
//                if selectedRecordingSet.wrappedType == RecordingSet.wrappedType {
//                    return false
//                } else {
//                    return true
//                }
//            }
//        } else {
//            return true
//        }
//    }
//}
