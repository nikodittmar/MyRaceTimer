//
//  ResolveIssueViewModel.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 5/2/23.
//

import Foundation

@MainActor class ResolveIssuesSheetViewModel: ObservableObject {
    let dataController: DataController = DataController.shared

    @Published var recordingSetPair: RecordingSetPair
    @Published var selectedRecording: Recording?
    
    init(recordingSetPair: RecordingSetPair) {
        self.recordingSetPair = recordingSetPair
    }
    
    func update() {
        self.recordingSetPair = recordingSetPair
    }
    
    func issuesFor(_ recording: Recording) -> [RecordingIssue] {
        return recordingSetPair.issuesFor(recording: recording)
    }
    
    func selectRecording(_ recording: Recording) {
        if let selectedRecording = self.selectedRecording {
            if selectedRecording.wrappedId == recording.wrappedId {
                self.selectedRecording = nil
            } else {
                self.selectedRecording = recording
            }
        } else {
            self.selectedRecording = recording
        }
    }
    
    func handleAppendPlateDigit(digit: Int) {
        if let selectedRecording = self.selectedRecording {
            dataController.appendRecordingPlateDigit(selectedRecording, digit: digit)
            update()
        }
    }
    
    func handleRemoveLastPlateDigit() {
        if let selectedRecording = self.selectedRecording {
            dataController.deleteLastRecordingPlateDigit(selectedRecording)
            update()
        }
    }
    
    func handleDeleteRecording() {
        if let selectedRecording = self.selectedRecording {
            dataController.deleteRecording(selectedRecording)
            update()
        }
    }
}
