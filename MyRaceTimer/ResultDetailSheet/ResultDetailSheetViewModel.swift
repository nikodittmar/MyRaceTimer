//
//  ResultDetailSheetViewModel.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 4/30/23.
//

import Foundation

@MainActor class ResultDetailSheetViewModel: ObservableObject {
    let dataController: DataController = DataController.shared
    var result: Result
    
    @Published var selectedStage: Stage? = nil
    @Published var stages: [Stage]
    @Published var standings: [Racer]
    
    init(result: Result) {
        self.result = result
        self.stages = result.wrappedStages
        self.standings = result.standings
    }
    
    func updateStandings() {
        if let selectedStage = self.selectedStage {
            standings = result.standingsFor(stage: selectedStage)
        } else {
            standings = result.standings
        }
    }
    
    func standingsSelectorText() -> String {
        if let selectedStage = self.selectedStage {
            return selectedStage.wrappedName
        } else {
            return "Overall"
        }
    }
    
    func selectStage(stage: Stage) {
        selectedStage = stage
        updateStandings()
    }
    
    func selectOverall() {
        selectedStage = nil
        updateStandings()
    }
    
    func placeOf(racer: Racer) -> String {
        if let index = standings.firstIndex(of: racer) {
            return "\(String(index + 1))."
        } else {
            return "-."
        }
    }
    
    func hasPenalty(racer: Racer) -> Bool {
        if let selectedStage = self.selectedStage {
            return racer.penaltyFor(stage: selectedStage) != 0.0
        } else {
            return racer.overallPenalties != 0.0
        }
    }
    
    func penaltyFor(racer: Racer) -> String {
        if let selectedStage = self.selectedStage {
            let penalty = racer.penaltyFor(stage: selectedStage)
            return "+\(String(penalty))s"
        } else {
            let penalty = racer.overallPenalties
            return "+\(String(penalty))s"
        }
    }
    
    func deleteResult() {
        dataController.deleteResult(result: result)
    }
}
