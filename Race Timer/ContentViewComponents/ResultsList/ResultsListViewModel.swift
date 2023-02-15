//
//  ResultsListViewModel.swift
//  Race Timer
//
//  Created by niko dittmar on 2/15/23.
//

import Foundation

extension ContentViewViewModel {
    func toggleSelectedResult(_ result: Result) {
        if selectedResult == result {
            selectedResult = nil
        } else {
            upcomingPlateEntrySelected = false
            selectedResult = result
        }
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
    
    func resultsListItemLabel(_ result: Result) -> String {
        var label = result.unwrappedPlate
        if label == "" {
            label = "-       -"
        }
        return label
    }
    
    func resultIsSelected(_ result: Result) -> Bool {
        return selectedResult?.id == result.unwrappedId
    }
}
