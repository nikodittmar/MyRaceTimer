//
//  SelectResultsViewModel.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 4/23/23.
//

import Foundation
import SwiftUI

@MainActor class SelectResultsViewModel: ObservableObject {
    @Published var navigatingToPairResults: Bool = false
    @Published var presentingUnequalSelectionWarning: Bool = false
    
    func next(selectedResults: [Result]) {
        var startCount = 0
        var finishCount = 0
        
        for result in selectedResults {
            if result.wrappedType == ResultType.Start {
                startCount += 1
            } else {
                finishCount += 1
            }
        }
        
        if startCount == finishCount {
            navigatingToPairResults = true
        } else {
            presentingUnequalSelectionWarning = true
        }
    }
}
