//
//  SelectRecordingSetsViewModel.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 4/23/23.
//

import Foundation
import SwiftUI

@MainActor class SelectRecordingSetsViewModel: ObservableObject {
    let dataController: DataController = DataController.shared
    
    @Published var recordingSets: [RecordingSet] = []
    @Published var selectedRecordingSets: [RecordingSet] = []

    @Published var navigatingToPairRecordingSets: Bool = false
    @Published var presentingUnequalSelectionWarning: Bool = false
    
    init() {
        recordingSets = dataController.getRecordingSets()
    }
    
    func selectRecordingSet(recordingSet: RecordingSet) {
        if selectedRecordingSets.contains(recordingSet) {
            selectedRecordingSets = selectedRecordingSets.filter { $0.wrappedId != recordingSet.wrappedId}
        } else {
            selectedRecordingSets.append(recordingSet)
        }
    }
    
    func next() {
        var startCount = 0
        var finishCount = 0
        
        for recordingSet in selectedRecordingSets {
            if recordingSet.wrappedType == RecordingsType.Start {
                startCount += 1
            } else {
                finishCount += 1
            }
        }
        
        if startCount == finishCount {
            navigatingToPairRecordingSets = true
        } else {
            presentingUnequalSelectionWarning = true
        }
    }
}
