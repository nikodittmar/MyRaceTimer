//
//  ContentViewViewModel.swift
//  Race Timer
//
//  Created by niko dittmar on 2/15/23.
//

import SwiftUI
import Foundation

public enum TimingMode {
    case start
    case finish
}

@MainActor class ContentViewViewModel: ObservableObject {
    let timer = Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .common).autoconnect()
    var secondsSinceLastRecording: Double = 0.0
    
    @Published var timeElapsedString: String = ""
    
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
    @Published var presentingImportSheet: Bool = false
    @Published var presentingImportErrorWarning: Bool = false
    @Published var presentingResultSheet: Bool = false
    
    @Published var presentingClearWarning: Bool = false
    @Published var presentingDeleteAllWarning: Bool = false
    
    @Published var upcomingPlateEntrySelected: Bool = false
    @Published var upcomingPlate: String = ""
    
    @Published var stageName: String = ""
    @Published var recordingsType: TimingMode = .start
    @Published var importedStageResult: StageResult?
        
    init() {
        let activeTimingResult: TimingResult? = coreDM.getActiveTimingResult()
        if activeTimingResult != nil {
            self.timingResultSet = activeTimingResult!
            self.results = coreDM.getResultsFrom(activeTimingResult!)
            self.plateList = coreDM.getAllPlatesFrom(activeTimingResult!)
            self.stageName = activeTimingResult?.unwrappedName ?? ""
            if activeTimingResult?.start == true {
                self.recordingsType = .start
            } else {
                self.recordingsType = .finish
            }
        } else {
            coreDM.createTimingResult(mode: .start)
            let newActiveTimingResult: TimingResult? = coreDM.getActiveTimingResult()
            self.timingResultSet = newActiveTimingResult!
            self.results = []
            self.plateList = []
        }
    }
    
    func syncResults() {
        if coreDM.getActiveTimingResult() != nil {
            timingResultSet = coreDM.getActiveTimingResult()!
        }
        stageName = timingResultSet.unwrappedName
        if timingResultSet.start {
            recordingsType = .start
        } else {
            recordingsType = .finish
        }
        results = coreDM.getResultsFrom(timingResultSet)
        plateList = coreDM.getAllPlatesFrom(timingResultSet)
    }
    
    func recordTime() {
        coreDM.saveResultTo(timingResultSet, plate: upcomingPlate)
        syncResults()
        upcomingPlateEntrySelected = false
        upcomingPlate = ""
        selectedResult = results[0]
        secondsSinceLastRecording = 0.0
        timeElapsedString = "0s"
    }
    
    func updateTime() {
        secondsSinceLastRecording += 1.0
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated

        let formattedString = formatter.string(from: TimeInterval(secondsSinceLastRecording)) ?? ""
        timeElapsedString = formattedString
    }
}
