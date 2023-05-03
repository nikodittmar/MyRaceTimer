//
//  ResolveIssuesViewModel.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 4/30/23.
//

import Foundation

@MainActor class ResolveIssuesViewModel: ObservableObject {
    
    var recordingSetPairs: [RecordingSetPair]
    @Published var recordingSetErrorCounts: [UUID: Int]
    @Published var selectedRecordingSetPair: RecordingSetPair? = nil
    
    init(recordingSetPairs: [RecordingSetPair]) {
        self.recordingSetPairs = recordingSetPairs
        
        var errorCounts: [UUID: Int] = [:]
        
        for recordingSetPair in recordingSetPairs {
            errorCounts[recordingSetPair.id] = recordingSetPair.errors().count
        }
        
        self.recordingSetErrorCounts = errorCounts
    }
     
    func errorCount(recordingSetPair: RecordingSetPair) -> Int {
        if let count = recordingSetErrorCounts[recordingSetPair.id] {
            return count
        } else {
            return 0
        }
    }
}
