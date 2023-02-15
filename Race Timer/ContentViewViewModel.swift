//
//  ContentViewViewModel.swift
//  Race Timer
//
//  Created by niko dittmar on 2/15/23.
//

import SwiftUI
import Foundation

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
    
    //Functions for Number Pad
    
    func appendDigit(_ digit: Int) {
        if selectedResult != nil {
            coreDM.appendPlateDigit(result: selectedResult!, digit: digit)
            syncResults()
        } else if upcomingPlateEntrySelected == true {
            if upcomingPlate.count < 5 {
                upcomingPlate.append(String(digit))
            }
        }
    }
    func backspace() {
        if selectedResult != nil {
            coreDM.removePlateDigit(result: selectedResult!)
            syncResults()
        } else if upcomingPlateEntrySelected == true {
            if upcomingPlate.count > 0 {
                upcomingPlate.removeLast()
            }
        }
    }
    func presentDeleteWarning() {
        if selectedResult != nil {
            presentingDeleteWarning = true
        }
    }
    func deleteResult() {
        if selectedResult != nil {
            coreDM.delete(selectedResult!)
            selectedResult = nil
            syncResults()
        }
    }
    
    //Functions for Results List
    
    func resultListItemNumber(_ result: Result) -> String {
        return String(results.firstIndex(where: {$0.id == result.id}) ?? 0)
    }
    
    func resultsListItemLabel(_ result: Result) -> String {
        var label = result.unwrappedPlate
        if label == "" {
            label = "-       -"
        }
        return label
    }
    
    func hasDuplicatePlate(_ result: Result) -> Bool {
        if result.unwrappedPlate.occurrencesIn(plateList) > 1 {
            return true
        } else if upcomingPlate != "" && result.unwrappedPlate == upcomingPlate  {
            return true
        } else {
            return false
        }
    }
    
    func toggleSelectedResult(_ result: Result) {
        if selectedResult == result {
            selectedResult = nil
        } else {
            upcomingPlateEntrySelected = false
            selectedResult = result
        }
    }
    
    func resultIsSelected(_ result: Result) -> Bool {
        return selectedResult?.id == result.unwrappedId
    }
    
    func deleteAll() {
        coreDM.deleteAll()
        syncResults()
        selectedResult = nil
    }
    
    func selectUpcomingPlateEntry() {
        if upcomingPlateEntrySelected == true {
            upcomingPlateEntrySelected = false
        } else {
            selectedResult = nil
            upcomingPlateEntrySelected = true
        }
    }
    
    func upcomingPlateIsDuplicate() -> Bool {
        if upcomingPlate.occurrencesIn(plateList) >= 1 {
            return true
        } else {
            return false
        }
    }
    
    func upcomingPlateLabel() -> String {
        var label: String = upcomingPlate
        if label == "" {
            label = "-               -"
        }
        return label
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
