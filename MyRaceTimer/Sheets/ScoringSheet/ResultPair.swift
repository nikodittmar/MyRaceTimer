////
////  RecordingSetPair.swift
////  MyRaceTimer
////
////  Created by niko dittmar on 4/23/23.
////
//
//import Foundation
//import SwiftUI
//
//struct RecordingSetPair: Identifiable {
//    var id: UUID = UUID()
//    var start: RecordingSet
//    var finish: RecordingSet
//    
//    func recordingsWithoutTimestamps() -> [Recording] {
//        var recordingsWithoutTimestamps: [Recording] = []
//        let recordings: [Recording] = start.wrappedRecordings + finish.wrappedRecordings
//        
//        for recording in recordings {
//            if recording.missingTimestamp {
//                recordingsWithoutTimestamps.append(recording)
//            }
//        }
//        
//        return recordingsWithoutTimestamps
//    }
//    
//    func recordingsWithoutPlates() -> [Recording] {
//        var recordingsWithoutPlates: [Recording] = []
//        let recordings: [Recording] = start.wrappedRecordings + finish.wrappedRecordings
//        
//        for recording in recordings {
//            if recording.wrappedPlate == "" {
//                recordingsWithoutPlates.append(recording)
//            }
//        }
//        
//        return recordingsWithoutPlates
//    }
//    
//    func recordingsWithoutMatches() -> [Recording] {
//        var recordingsWithoutMatches: [Recording] = []
//        let recordings: [Recording] = start.wrappedRecordings + finish.wrappedRecordings
//        let plateList: [String] = recordings.plates()
//        
//        for recording in recordings {
//            if recording.wrappedPlate.occurrencesIn(plateList) < 2 {
//                recordingsWithoutMatches.append(recording)
//            }
//        }
//        
//        return recordingsWithoutMatches
//    }
//    
//    func recordingsWithMultipleMatches() -> [Recording] {
//        var recordingsWithMultipleMatches: [Recording] = []
//        let recordings: [Recording] = start.wrappedRecordings + finish.wrappedRecordings
//        let plateList: [String] = recordings.plates()
//        
//        for recording in recordings {
//            if recording.wrappedPlate.occurrencesIn(plateList) > 2 {
//                recordingsWithMultipleMatches.append(recording)
//            }
//        }
//        
//        return recordingsWithMultipleMatches
//    }
//}
//
//
//struct Time {
//    var start: Date
//    var finish: Date
//    var overall: TimeInterval {
//        start.timeIntervalSince(finish)
//    }
//}
//
//struct Score: Identifiable {
//    var id: UUID = UUID()
//    var times: [Time]
//    var overall: Double {
//        var overall: Double = 0.0
//        
//        for time in times {
//            overall += Double(time.overall)
//        }
//        
//        return overall
//    }
//}
