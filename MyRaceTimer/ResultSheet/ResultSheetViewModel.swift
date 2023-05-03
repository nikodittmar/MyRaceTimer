//
//  ResultSheetViewModel.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 4/30/23.
//

import Foundation

@MainActor class ResultSheetViewModel: ObservableObject {
    let dataController: DataController = DataController.shared
    
    @Published var results: [Result] = []
    @Published var displayingResultCalculatorSheet: Bool = false
    
    init() {
        updateResults()
    }
    
    func updateResults() {
        results = dataController.getResults()
    }
    
    func navigateToResult(result: Result) {
        displayingResultCalculatorSheet = false
        updateResults()
    }
}
