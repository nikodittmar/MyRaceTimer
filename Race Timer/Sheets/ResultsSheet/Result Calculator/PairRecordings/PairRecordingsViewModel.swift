//
//  PairRecordingsViewModel.swift
//  Race Timer
//
//  Created by niko dittmar on 2/19/23.
//

import Foundation

extension ResultsSheetViewModel {
    func selectPair(timingResult: TimingResult) {
        if startTimingResult == nil && finishTimingResult == nil {
            if timingResult.start == true {
                startTimingResult = timingResult
            } else {
                finishTimingResult = timingResult
            }
        } else if timingResult.start == true && startTimingResult == nil {
            timingResultPairs.append(TimingResultPair(start: timingResult, finish: finishTimingResult!))
            selectedTimingResults = selectedTimingResults.filter { $0 != timingResult }
            selectedTimingResults = selectedTimingResults.filter { $0 != finishTimingResult! }
            finishTimingResult = nil
            
        } else if timingResult.start == false && finishTimingResult == nil {
            timingResultPairs.append(TimingResultPair(start: startTimingResult!, finish: timingResult))
            selectedTimingResults = selectedTimingResults.filter { $0 != timingResult }
            selectedTimingResults = selectedTimingResults.filter { $0 != startTimingResult! }
            startTimingResult = nil
        } else {
            finishTimingResult = nil
            startTimingResult = nil
        }
    }
    
    func deleteResultPair(resultPair: TimingResultPair) {
        timingResultPairs = timingResultPairs.filter { $0.id != resultPair.id }
        selectedTimingResults.append(resultPair.start)
        selectedTimingResults.append(resultPair.finish)
    }
    
    func timingResultIsAvailible(timingResult: TimingResult) -> Bool {
        if timingResult.start == true && startTimingResult != nil && timingResult != startTimingResult {
            return false
        } else if timingResult.start == false && finishTimingResult != nil && timingResult != finishTimingResult {
            return false
        } else {
            return true
        }
    }
    
    func timingResultIsSelectedForPair(timingResult: TimingResult) -> Bool {
        if timingResult == startTimingResult || timingResult == finishTimingResult {
            return true
        } else {
            return false
        }
    }
}
