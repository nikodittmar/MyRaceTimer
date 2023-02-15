//
//  NumberPadViewModel.swift
//  Race Timer
//
//  Created by niko dittmar on 2/15/23.
//

import SwiftUI
import Foundation

extension ContentViewViewModel {
    
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
}
