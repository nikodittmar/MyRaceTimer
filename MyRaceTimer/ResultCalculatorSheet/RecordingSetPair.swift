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
    
    public func recordingsWithNoMatches() -> [Recording] {
        var recordingsWithoutMatches: [Recording] = []
        let recordings: [Recording] = start.wrappedRecordings + finish.wrappedRecordings
        let plateList: [String] = recordings.plates()
        
        for recording in recordings {
            if recording.wrappedPlate.occurrencesIn(plateList) < 2 {
                recordingsWithoutMatches.append(recording)
            }
        }
        
        return recordingsWithoutMatches
    }
    
    public func recordingsWithMultipleMatches() -> [Recording] {
        var recordingsWithMultipleMatches: [Recording] = []
        let recordings: [Recording] = start.wrappedRecordings + finish.wrappedRecordings
        let plateList: [String] = recordings.plates()
        
        for recording in recordings {
            if recording.wrappedPlate.occurrencesIn(plateList) > 2 {
                recordingsWithMultipleMatches.append(recording)
            }
        }
        
        return recordingsWithMultipleMatches
    }
    
    public func recordingsWithNoPlates() -> [Recording] {
        var recordingsWithoutPlates: [Recording] = []
        let recordings: [Recording] = start.wrappedRecordings + finish.wrappedRecordings
        for recording in recordings {
            if recording.wrappedPlate == "" {
                recordingsWithoutPlates.append(recording)
            }
        }
        
        return recordingsWithoutPlates
    }
    
    public func recordingsWithMissingTimestamps() -> [Recording] {
        var recordingsWithoutTimestamps: [Recording] = []
        let recordings: [Recording] = start.wrappedRecordings + finish.wrappedRecordings

        for recording in recordings {
            if recording.missingTimestamp {
                recordingsWithoutTimestamps.append(recording)
            }
        }
    
        return recordingsWithoutTimestamps
    }
    
    public func recordingsWithNegativeTime() -> [Recording] {
        var recordingsWithNegativeTime: [Recording] = []

        for startRecording in start.wrappedRecordings {
            for finishRecording in finish.wrappedRecordings {
                if startRecording.plate == finishRecording.plate {
                    if (startRecording.timestamp - finishRecording.timestamp) < 0 {
                        recordingsWithNegativeTime.append(startRecording)
                        recordingsWithNegativeTime.append(finishRecording)
                    }
                }
            }
        }
        return recordingsWithNegativeTime
    }
}

public struct RecordingPair {
    public var startTime: Double
    public var endTime: Double
    public var plate: String
}
