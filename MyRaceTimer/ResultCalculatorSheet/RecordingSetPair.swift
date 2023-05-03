//
//  RecordingSetPair.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 4/23/23.
//

import Foundation
import SwiftUI

public struct RecordingSetPair: Identifiable {
    public var id: UUID = UUID()
    public var start: RecordingSet
    public var finish: RecordingSet
    public var name: String
    
    public func recordingPairs() -> [RecordingPair] {
        var recordingPairs: [RecordingPair] = []
        
        for startRecording in start.wrappedRecordings {
            for endRecording in finish.wrappedRecordings {
                if startRecording.wrappedPlate == endRecording.wrappedPlate {
                    let pair = RecordingPair(startTime: startRecording.timestamp, endTime: endRecording.timestamp, plate: startRecording.wrappedPlate)
                    recordingPairs.append(pair)
                }
            }
        }
        
        return recordingPairs
    }
    
    public func errors() -> [UUID: RecordingErrors] {
        var errors: [UUID: RecordingErrors] = [:]
        let allRecordingsPlates: [String] = (start.wrappedRecordings + finish.wrappedRecordings).plates()
        var platesWithNegativeTime: [String] = []
        
        for recording in start.wrappedRecordings {
            let occurances: Int = recording.wrappedPlate.occurrencesIn(allRecordingsPlates)
            
            let missingPlate = recording.wrappedPlate == ""
            let missingTimestamp = recording.missingTimestamp
            var multipleMatches = false
            var noMatches = false
            var negativeTime = false
            
            if occurances > 2 {
                multipleMatches = true
            } else if occurances < 2 {
                noMatches = true
            } else {
                for endRecording in finish.wrappedRecordings {
                    if endRecording.wrappedPlate == recording.wrappedPlate {
                        if (endRecording.timestamp - recording.timestamp) < 0 {
                            negativeTime = true
                            platesWithNegativeTime.append(recording.wrappedPlate)
                        }
                    }
                }
            }
            
            errors[recording.wrappedId] = RecordingErrors(missingPlate: missingPlate, missingTimestamp: missingTimestamp, noMatches: noMatches, multipleMatches: multipleMatches, negativeTime: negativeTime)
        }
        
        for recording in finish.wrappedRecordings {
            let occurances: Int = recording.wrappedPlate.occurrencesIn(allRecordingsPlates)
            
            let missingPlate = recording.wrappedPlate == ""
            let missingTimestamp = recording.missingTimestamp
            var multipleMatches = false
            var noMatches = false
            var negativeTime = false
            
            if occurances > 2 {
                multipleMatches = true
            } else if occurances < 2 {
                noMatches = true
            } else if platesWithNegativeTime.contains(recording.wrappedPlate) {
                negativeTime = true
            }
            errors[recording.wrappedId] = RecordingErrors(missingPlate: missingPlate, missingTimestamp: missingTimestamp, noMatches: noMatches, multipleMatches: multipleMatches, negativeTime: negativeTime)
        }
        
        return errors
    }

}

public struct RecordingPair {
    public var startTime: Double
    public var endTime: Double
    public var plate: String
}

public struct RecordingErrors {
    public var missingPlate: Bool
    public var missingTimestamp: Bool
    public var noMatches: Bool
    public var multipleMatches: Bool
    public var negativeTime: Bool
}
