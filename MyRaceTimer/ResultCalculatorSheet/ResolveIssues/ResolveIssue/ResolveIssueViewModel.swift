//
//  ResolveIssueViewModel.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 5/2/23.
//

import Foundation

@MainActor class ResolveIssueViewModel: ObservableObject {
    let dataController: DataController = DataController.shared

    @Published var recordingSetPair: RecordingSetPair
    @Published var selectedRecording: Recording?
    @Published var errors: [UUID: RecordingErrors]
    
    init(recordingSetPair: RecordingSetPair) {
        self.recordingSetPair = recordingSetPair
        self.errors = recordingSetPair.errors()
    }
    
    func update() {
        self.errors = recordingSetPair.errors()
    }
    
    func errorCount(_ recording: Recording) -> Int {
        if let recordingErrors = errors[recording.wrappedId] {
            var count = 0
            if recordingErrors.missingPlate {
                count += 1
            }
            if recordingErrors.missingTimestamp {
                count += 1
            }
            if recordingErrors.multipleMatches {
                count += 1
            }
            if recordingErrors.noMatches {
                count += 1
            }
            if recordingErrors.negativeTime {
                count += 1
            }
            return count
        } else {
            return 0
        }
    }
    
    func getErrors(_ recording: Recording) -> RecordingErrors {
        if let recordingErrors = errors[recording.wrappedId] {
            return recordingErrors
        } else {
            return RecordingErrors(missingPlate: false, missingTimestamp: false, noMatches: false, multipleMatches: false, negativeTime: false)
        }
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
