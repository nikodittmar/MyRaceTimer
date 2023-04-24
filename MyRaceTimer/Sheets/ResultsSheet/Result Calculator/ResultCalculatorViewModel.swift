//
//  SelectRecordingsViewModel.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 2/18/23.
//

import Foundation
import SwiftUI

@MainActor class ResultCalculatorViewModel: ObservableObject {
    
    @Published var resultPairs: [ResultPair] = []
    @Published var selectedResults: [Result] = []
    
    @Published var selectedResultForPairing: Result?
    
    func toggleResultSelection(result: Result) {
        if selectedResults.contains(result) {
            selectedResults = selectedResults.filter {
                $0 != result
            }
        } else {
            selectedResults.append(result)
        }
    }
    
    func resultLabel(result: Result) -> String {
        let resultType: String = result.wrappedType.rawValue.capitalized
        let recordingCount: Int = result.wrappedRecordings.count
        var resultLabel: String = ""
        
        if recordingCount == 1 {
            resultLabel = "\(recordingCount) Recording, Stage " + resultType
        } else {
            resultLabel =  "\(recordingCount) Recordings, Stage " + resultType
        }
        
        return resultLabel
    }
    
    func deleteResultPair(resultPair: ResultPair) {
        resultPairs = resultPairs.filter {
            $0.id != resultPair.id
        }
        selectedResults.append(resultPair.start)
        selectedResults.append(resultPair.finish)
    }
    
    func selectResultForPairing(result: Result) {
        if let selectedResult = selectedResultForPairing {
            if selectedResult.wrappedType != result.wrappedType {
                if selectedResult.wrappedType == ResultType.Start {
                    let resultPair = ResultPair(start: selectedResult, finish: result)
                    resultPairs.append(resultPair)
                    selectedResults = selectedResults.filter {
                        $0.wrappedId != selectedResult.wrappedId &&  $0.wrappedId != result.wrappedId
                    }
                    selectedResultForPairing = nil
                } else {
                    let resultPair = ResultPair(start: result, finish: selectedResult)
                    resultPairs.append(resultPair)
                    selectedResults = selectedResults.filter {
                        $0.wrappedId != selectedResult.wrappedId &&  $0.wrappedId != result.wrappedId
                    }
                    selectedResultForPairing = nil
                }
            }
        } else {
            selectedResultForPairing = result
        }
    }
    
    func resultIsAvailibleForPairing(result: Result) -> Bool {
        if let selectedResult = selectedResultForPairing {
            if selectedResult.wrappedType == result.wrappedType {
                return false
            } else {
                return true
            }
        } else {
            return true
        }
    }
}
