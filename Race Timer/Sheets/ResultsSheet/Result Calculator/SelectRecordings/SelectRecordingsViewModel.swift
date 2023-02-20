//
//  SelectRecordingsViewModel.swift
//  Race Timer
//
//  Created by niko dittmar on 2/18/23.
//

import Foundation
import SwiftUI

extension ResultsSheetViewModel {
    func allTimingResults() -> [TimingResult] {
        return coreDM.getAllTimingResults().filter { !$0.unwrappedName.isEmpty || !$0.resultArray.isEmpty}
    }
    
    func toggleTimingResultSelection(timingResult: TimingResult) {
        if selectedTimingResults.contains(timingResult) {
            selectedTimingResults = selectedTimingResults.filter { $0 != timingResult }
        } else {
            selectedTimingResults.append(timingResult)
        }
    }
    
    func timingResultIsSelected(timingResult: TimingResult) -> Bool {
        return selectedTimingResults.contains(timingResult)
    }
    
    func unequalStageStartAndFinishResults() -> Bool {
        var stageStartResults: Int = 0
        var stageFinishResults: Int = 0
        for result in selectedTimingResults {
            if result.start {
                stageStartResults += 1
            } else {
                stageFinishResults += 1
            }
        }
        return stageStartResults == stageFinishResults
    }
    
    func selectRecordingsNextButton() {
        if !unequalStageStartAndFinishResults() {
            displayingIncorrectSelectionWarning = true
        } else {
            timingResultPairs = []
            startTimingResult = nil
            finishTimingResult = nil
            navigateToPairRecordings = true
        }
    }
}
