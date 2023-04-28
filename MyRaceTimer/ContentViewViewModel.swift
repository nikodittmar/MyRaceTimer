//
//  ContentViewViewModel.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 2/15/23.
//

import SwiftUI
import Foundation

@MainActor class ContentViewViewModel: ObservableObject {
    let dataController: DataController
        
    @Published var recordings: [Recording] = []
    @Published var selectedRecording: Recording? = nil
    
    @Published var presentingRecordingSetsSheet: Bool = false
    
    @Published var presentingSuccessfulImportAlert: Bool = false
    @Published var presentingImportErrorAlert: Bool = false

            
    let timer = Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .common).autoconnect()
    var secondsSinceLastRecording: Double = 0.0
    
    @Published var timeElapsedString: String = "0s"
    @Published var timerIsActive: Bool = false
    
    init(forTesting: Bool = false) {
        if forTesting {
            dataController = DataController(forTesting: true)
        } else {
            dataController = DataController.shared
        }
        
        updateRecordings()
    }
    
    func updateTime() {
        secondsSinceLastRecording += 1.0
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        let formattedString = formatter.string(from: TimeInterval(secondsSinceLastRecording)) ?? ""
        timeElapsedString = formattedString
    }
    
    func resetTimer() {
        secondsSinceLastRecording = 0.0
        timeElapsedString = "0s"
        timerIsActive = true
    }
    
    func deactivateTimer() {
        timerIsActive = false
    }
    
    func updateRecordings() {
        recordings = dataController.getRecordings()
    }
    
    func handleRecordTime() {
        let recordingsWithoutTimestamps = dataController.getRecordings().recordingsWithoutTimestamps()
        
        if recordingsWithoutTimestamps.isEmpty {
            selectedRecording = dataController.createRecording()
        } else {
            let currentTime = Date()
            for recording in recordingsWithoutTimestamps {
                dataController.updateRecordingTimestamp(recording, timestamp: currentTime)
            }
        }
        
        resetTimer()
        updateRecordings()
    }
    
    func handleSelectRecording(recording: Recording) {
        if selectedRecording == recording {
            selectedRecording = nil
        } else {
            selectedRecording = recording
        }
    }
    
    func handleAppendPlateDigit(digit: Int) {
        if let selectedRecording = self.selectedRecording {
            dataController.appendRecordingPlateDigit(selectedRecording, digit: digit)
            updateRecordings()
        }
    }
    
    func handleRemoveLastPlateDigit() {
        if let selectedRecording = self.selectedRecording {
            dataController.deleteLastRecordingPlateDigit(selectedRecording)
            updateRecordings()
        }
    }
    
    func handleDeleteRecording() {
        if let selectedRecording = self.selectedRecording {
            dataController.deleteRecording(selectedRecording)
            updateRecordings()
        }
    }
    
    func handleAddUpcomingPlate() {
        selectedRecording = dataController.createRecording(withTimestamp: false)
        updateRecordings()
    }
    
    func displayingUpcomingPlateButton() -> Bool {
        return dataController.selectedRecordingSet?.wrappedType == RecordingsType.Start
    }
    
    func recordingCountLabel() -> String {
        let count = recordings.count
        
        return count == 1 ? "\(count) Recording" : "\(count) Recordings"
    }
        
    func importResult(url: URL) {
        presentingRecordingSetsSheet = false
        
        do {
            try dataController.importRecordingSet(url: url)
            updateRecordings()
            deactivateTimer()
            presentingSuccessfulImportAlert = true
        } catch {
            presentingImportErrorAlert = true
        }
    }
}
