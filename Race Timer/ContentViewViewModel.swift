//
//  ContentViewViewModel.swift
//  Race Timer
//
//  Created by niko dittmar on 2/15/23.
//

import SwiftUI
import Foundation

enum TimingMode {
    case start
    case finish
}

@MainActor class ContentViewViewModel: ObservableObject {
    let coreDM: DataController = DataController()
    
    @Published var timingResultSet: TimingResult
    
    @Published var results: [Result]
    @Published var plateList: [String]
    
    @Published var selectedResult: Result?
    
    @Published var presentingDeleteWarning: Bool = false
    @Published var presentingMissingPlateWarning: Bool = false
    @Published var presentingDuplicatePlateWarning: Bool = false
    @Published var presentingDuplicateAndMissingPlateWarning: Bool = false

    @Published var presentingMenuSheet: Bool = false
    @Published var presentingExportSheet: Bool = false
    
    @Published var presentingResetWarning: Bool = false
    @Published var timingMode: TimingMode = .start
    
    @Published var upcomingPlateEntrySelected: Bool = false
    @Published var upcomingPlate: String = ""
    
    @Published var stageName: String = ""
    @Published var recordingsType: TimingMode = .start
    
    
    init() {
        
        let activeTimingResult: TimingResult? = coreDM.getActiveTimingResult()
        if activeTimingResult != nil {
            print("Active Results Set Found.")
            self.timingResultSet = activeTimingResult!
            self.results = coreDM.getResultsFrom(activeTimingResult!)
            self.plateList = coreDM.getAllPlatesFrom(activeTimingResult!)
        } else {
            print("No Active Results Set Found, Creating New Result Set!")
            coreDM.createTimingResult(mode: .start)
            let newActiveTimingResult: TimingResult? = coreDM.getActiveTimingResult()
            self.timingResultSet = newActiveTimingResult!
            self.results = []
            self.plateList = []
        }
    }
    
    func syncResults() {
        results = coreDM.getResultsFrom(timingResultSet)
        plateList = coreDM.getAllPlatesFrom(timingResultSet)
    }
    
    func recordTime() {
        coreDM.saveResultTo(timingResultSet, plate: upcomingPlate)
        syncResults()
        upcomingPlateEntrySelected = false
        upcomingPlate = ""
        selectedResult = results[0]
    }

    func deleteAll() {
        coreDM.deleteAll()
        syncResults()
        selectedResult = nil
    }
    
    func resetNextPlateEntryField() {
        upcomingPlate = ""
        recordingsType = timingMode
    }
    
    func updateTimingResultDetails() {
        coreDM.setTimingResultName(timingResultSet, name: stageName)
        coreDM.setTimingResultType(timingResultSet, timingMode: recordingsType)
    }
    
    func allTimingResults() -> [TimingResult] {
        return coreDM.getAllTimingResults()
    }
    
    func switchTimingResultTo(_ timingResult: TimingResult) {
        coreDM.activateTimingResult(timingResult)
        timingResultSet = timingResult
        syncResults()
    }
    
    func newRecordingSet() {
        coreDM.createTimingResult(mode: timingMode)
        recordingsType = timingMode
        syncResults()
    }
}
