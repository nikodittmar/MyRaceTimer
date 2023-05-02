//
//  ResolveIssuesViewModel.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 4/30/23.
//

import Foundation

struct ProblematicRecordingSet {
    var name: String
    var recordingsWithIssues: [Recording]
    var recordingsWithNegativeTime: [Recording]
    var recordingsMissingTimestamps: [Recording]
    var recordingsMissingPlates: [Recording]
    var recordingsWithNoMatches: [Recording]
    var recordingsWithMultipleMatches: [Recording]
    
    init(recordingSetPair: RecordingSetPair) {
        let recordingsWithNegativeTime: [Recording] = recordingSetPair.recordingsWithNegativeTime()
        let recordingsMissingTimestamps: [Recording] = recordingSetPair.recordingsWithMissingTimestamps()
        let recordingsMissingPlates: [Recording] = recordingSetPair.recordingsWithNoPlates()
        let recordingsWithNoMatches: [Recording] = recordingSetPair.recordingsWithNoMatches()
        let recordingsWithMultipleMatches: [Recording] = recordingSetPair.recordingsWithMultipleMatches()
        
        var recordingsWithIssues = recordingsWithNegativeTime + recordingsMissingTimestamps + recordingsMissingPlates + recordingsWithNoMatches + recordingsWithMultipleMatches
        
        self.recordingsWithIssues = recordingsWithIssues.withoutDuplicates()
        self.name = recordingSetPair.name
        self.recordingsWithNegativeTime = recordingsWithNegativeTime
        self.recordingsMissingTimestamps = recordingsMissingTimestamps
        self.recordingsMissingPlates = recordingsMissingPlates
        self.recordingsWithNoMatches = recordingsWithNoMatches
        self.recordingsWithMultipleMatches = recordingsWithMultipleMatches
    }
}


@MainActor class ResolveIssuesViewModel: ObservableObject {
    var recordingPairs: [RecordingPair]
    var problematicRecordingSets: [ProblematicRecordingSet] = []
    
    init(recordingPairs: [RecordingPair]) {
        self.recordingPairs = recordingPairs
        
        
    }
}
