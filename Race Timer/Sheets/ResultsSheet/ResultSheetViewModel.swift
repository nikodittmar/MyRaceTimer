//
//  ResultSheetViewModel.swift
//  Race Timer
//
//  Created by niko dittmar on 2/18/23.
//

import Foundation
import SwiftUI

@MainActor class ResultsSheetViewModel: ObservableObject {
    let coreDM: DataController = DataController()
    
    //Select Recordings Step
    @Published var selectedTimingResults: [TimingResult] = []
    @Published var displayingIncorrectSelectionWarning: Bool = false
    @Published var navigateToPairRecordings: Bool = false
    
    //Pair Recordings Step
    @Published var timingResultPairs: [TimingResultPair] = []
    @Published var startTimingResult: TimingResult?
    @Published var finishTimingResult: TimingResult?
}
