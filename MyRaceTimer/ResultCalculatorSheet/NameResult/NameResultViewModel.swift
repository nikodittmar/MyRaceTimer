//
//  ResultNameViewModel.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 5/3/23.
//

import Foundation

@MainActor class NameResultViewModel: ObservableObject {
    let dataController: DataController = DataController.shared
    
    @Published var resultName: String = ""
    @Published var recordingSetPairs: [RecordingSetPair]
    @Published var navigatingToResolveIssues: Bool = false
    
    
    init(recordingSetPairs: [RecordingSetPair]) {
        self.recordingSetPairs = recordingSetPairs
    }
    
    func pairName(recordingSetPair: RecordingSetPair) -> String {
        let startName: String = recordingSetPair.start.wrappedName == "" ? "Untitled Recording Set" : recordingSetPair.start.wrappedName
        let finishName: String = recordingSetPair.finish.wrappedName == "" ? "Untitled Recording Set" : recordingSetPair.finish.wrappedName
        
        
        return "\(startName) + \(finishName)"
    }
    
    func createResult() -> Result? {
        for recordingSetPair in recordingSetPairs {
            if recordingSetPair.issueCount() > 0 {
                navigatingToResolveIssues = true
                return nil
            }
        }
        
        return dataController.createResult(recordingSetPairs: recordingSetPairs, name: resultName)
    }
}
