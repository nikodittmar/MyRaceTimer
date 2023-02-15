//
//  UpcomingPlateEntryViewModel.swift
//  Race Timer
//
//  Created by niko dittmar on 2/15/23.
//

import SwiftUI
import Foundation

extension ContentViewViewModel {
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
    
    func selectUpcomingPlateEntry() {
        if upcomingPlateEntrySelected == true {
            upcomingPlateEntrySelected = false
        } else {
            selectedResult = nil
            upcomingPlateEntrySelected = true
        }
    }
    
    func resultListItemNumber(_ result: Result) -> String {
        return String(results.firstIndex(where: {$0.id == result.id}) ?? 0)
    }
}
