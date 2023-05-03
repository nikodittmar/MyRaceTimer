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
    
    public func issueCount() -> Int {
        var count: Int = 0
        let allRecordings = start.wrappedRecordings + finish.wrappedRecordings
        for recording in allRecordings {
            count += issuesFor(recording: recording).count
        }
        
        return count
    }
    
    public func issuesFor(recording: Recording) -> [RecordingIssue] {
        var issues: [RecordingIssue] = []
        
        if recording.missingTimestamp {
            issues.append(RecordingIssue.missingTimestamp)
        }
        
        if recording.wrappedPlate == "" {
            issues.append(RecordingIssue.missingPlate)
        } else {
            if start.wrappedRecordings.contains(recording) {
                if start.wrappedRecordings.plates().duplicates().contains(recording.wrappedPlate) {
                    issues.append(RecordingIssue.duplicatePlate)
                }
                let finishRecordingPlates: [String] = finish.wrappedRecordings.plates()
                if recording.wrappedPlate.occurrencesIn(finishRecordingPlates) < 1 {
                    issues.append(RecordingIssue.noMatches)
                } else if recording.wrappedPlate.occurrencesIn(finishRecordingPlates) > 1 {
                    issues.append(RecordingIssue.multipleMatches)
                } else {
                    for finishRecording in finish.wrappedRecordings {
                        if finishRecording.wrappedPlate == recording.wrappedPlate {
                            if (finishRecording.timestamp - recording.timestamp) < 0 {
                                issues.append(RecordingIssue.negativeTime)
                            }
                        }
                    }
                }
            } else if finish.wrappedRecordings.contains(recording) {
                if finish.wrappedRecordings.plates().duplicates().contains(recording.wrappedPlate) {
                    issues.append(RecordingIssue.duplicatePlate)
                }
                let startRecordingPlates: [String] = start.wrappedRecordings.plates()
                if recording.wrappedPlate.occurrencesIn(startRecordingPlates) < 1 {
                    issues.append(RecordingIssue.noMatches)
                } else if recording.wrappedPlate.occurrencesIn(startRecordingPlates) > 1 {
                    issues.append(RecordingIssue.multipleMatches)
                } else {
                    for startRecording in start.wrappedRecordings {
                        if startRecording.wrappedPlate == recording.wrappedPlate {
                            if (recording.timestamp - startRecording.timestamp) < 0 {
                                issues.append(RecordingIssue.negativeTime)
                            }
                        }
                    }
                }
            }
        }
        return issues
    }
}

public struct RecordingPair {
    public var startTime: Double
    public var endTime: Double
    public var plate: String
}

public enum RecordingIssue: String {
    case duplicatePlate = "Duplicate Plate"
    case missingPlate = "Missing Plate"
    case missingTimestamp = "Missing Timestamp"
    case noMatches = "No Matches"
    case multipleMatches = "Multiple Matches"
    case negativeTime = "Negative Time"
}
