//
//  ResolveIssuesViewModel.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 4/30/23.
//

import Foundation

@MainActor class IssuesNavigatorViewModel: ObservableObject {
    let dataController: DataController = DataController.shared

    
    var recordingSetPairs: [RecordingSetPair]
    var resultName: String

    @Published var selectedRecordingSetPair: RecordingSetPair? = nil
    @Published var presentingFixAllErrorsModal: Bool = false

    
    init(recordingSetPairs: [RecordingSetPair], resultName: String) {
        self.recordingSetPairs = recordingSetPairs
        self.resultName = resultName

    }
     
    func issueCountFor(recordingSetPair: RecordingSetPair) -> Int {
        return recordingSetPair.issueCount()
    }
    
    func createResult() -> Result? {
        for recordingSetPair in recordingSetPairs {
            if recordingSetPair.issueCount() > 0 {
                return nil
            }
        }
        
        return dataController.createResult(recordingSetPairs: recordingSetPairs, name: resultName)
    }
}
