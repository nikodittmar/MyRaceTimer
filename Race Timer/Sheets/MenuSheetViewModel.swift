//
//  MenuSheetViewModel.swift
//  Race Timer
//
//  Created by niko dittmar on 2/15/23.
//

import Foundation

extension ContentViewViewModel {
    func duplicatePlateNumbersIn(_ resultsSet: TimingResult) -> Bool {
        return coreDM.duplicatePlateNumbersIn(resultsSet)
    }
    func missingPlateNumbersIn(_ resultsSet: TimingResult) -> Bool {
        return coreDM.missingPlateNumbersIn(resultsSet)
    }
    func warningCountIn(_ resultSet: TimingResult) -> Int {
        var warnings: Int = 0
        if duplicatePlateNumbersIn(resultSet) {
            warnings += 1
        }
        if missingPlateNumbersIn(resultSet) {
            warnings += 1
        }
        return warnings
    }
    func resultsTypeLabel(resultsSet: TimingResult) -> String {
        switch resultsSet.recordingsType {
        case.start:
            return "Start"
        case.finish:
            return "Finish"
        }
    }
    
    func deleteAllRecordingsFrom(_ resultsSet: TimingResult) {
        coreDM.deleteAllRecordingsFrom(resultsSet)
        syncResults()
    }
    
    func clearResult() {
        deleteAllRecordingsFrom(timingResultSet)
        stageName = ""
        recordingsType = .start
        syncResults()
    }
    
    func updateTimingResultDetails() {
        coreDM.setTimingResultName(timingResultSet, name: stageName)
        coreDM.setTimingResultType(timingResultSet, timingMode: recordingsType)
    }
    
    func allTimingResults() -> [TimingResult] {
        let results: [TimingResult] = coreDM.getAllTimingResults()
        var nonActiveResults: [TimingResult] = []
        for result in results {
            if result.loaded == false {
                nonActiveResults.append(result)
            }
        }
        return nonActiveResults
    }
    
    func switchTimingResultTo(_ timingResult: TimingResult) {
        let oldTimingResult: TimingResult = timingResultSet
        coreDM.activateTimingResult(timingResult)
        timingResultSet = timingResult
        stageName = timingResult.unwrappedName
        recordingsType = timingResult.recordingsType
        syncResults()
        
        if oldTimingResult.resultArray.isEmpty || oldTimingResult.unwrappedName.isEmpty {
            coreDM.deleteTimingResult(oldTimingResult)
        }
    }
    
    func newRecordingSet() {
        if !timingResultSet.resultArray.isEmpty || !timingResultSet.unwrappedName.isEmpty {
            coreDM.createTimingResult(mode: recordingsType)
            let activeTimingResult: TimingResult? = coreDM.getActiveTimingResult()
            if activeTimingResult != nil {
                timingResultSet = activeTimingResult!
                stageName = activeTimingResult!.unwrappedName
            }
            syncResults()
        }
    }
    
}
