////
////  TimingResultPair.swift
////  MyRaceTimer
////
////  Created by niko dittmar on 2/19/23.
////
//
//import Foundation
//
//struct TimingResultPair: Identifiable {
//    var id = UUID()
//    var start: TimingResult
//    var finish: TimingResult
//    
//    func unequalRecordingCounts() -> Bool {
//        return start.recordingCount != finish.recordingCount
//    }
//    
//    func recordingsWithNoMatch() -> [Result] {
//        var unmatchedRecordings: [Result] = []
//        for recording in start.resultArray {
//            if recording.unwrappedPlate.occurrencesIn(finish.plateArray) < 1 {
//                if !recording.unwrappedPlate.isEmpty {
//                    unmatchedRecordings.append(recording)
//                }
//            }
//        }
//        for recording in finish.resultArray {
//            if recording.unwrappedPlate.occurrencesIn(start.plateArray) < 1 {
//                if !recording.unwrappedPlate.isEmpty {
//                    unmatchedRecordings.append(recording)
//                }
//            }
//        }
//        
//        return unmatchedRecordings
//    }
//    
//    func recordingsWithTooManyMatches() -> [Result] {
//        var overmatchedRecordings: [Result] = []
//        let uniquePlateList: [String] = Array(Set(start.plateArray + finish.plateArray))
//        for plate in uniquePlateList {
//            let startMatches: Int = plate.occurrencesIn(start.plateArray)
//            let finishMatches: Int = plate.occurrencesIn(finish.plateArray)
//            if startMatches > 1 {
//                for result in start.resultArray {
//                    if result.unwrappedPlate == plate {
//                        overmatchedRecordings.append(result)
//                    }
//                }
//            }
//            if finishMatches > 1 {
//                for result in finish.resultArray {
//                    if result.unwrappedPlate == plate {
//                        overmatchedRecordings.append(result)
//                    }
//                }
//            }
//        }
//        
//        return overmatchedRecordings
//    }
//    
//    func recordingsWithNoPlate() -> [Result] {
//        var recordingsWithNoPlate: [Result] = []
//        for result in finish.resultArray {
//            if result.unwrappedPlate.isEmpty {
//                recordingsWithNoPlate.append(result)
//            }
//        }
//        for result in start.resultArray {
//            if result.unwrappedPlate.isEmpty {
//                recordingsWithNoPlate.append(result)
//            }
//        }
//        
//        return recordingsWithNoPlate
//    }
//    
//    func recordingIsStart(_ recording: Result) -> Bool {
//        return start.resultArray.contains(recording)
//    }
//}
