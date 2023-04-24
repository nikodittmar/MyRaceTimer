//
//  MenuSheetViewModel.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 2/15/23.
//

import Foundation

@MainActor class MenuSheetViewModel: ObservableObject {
    @Published var presentingDeleteResultWarning: Bool = false
    @Published var presentingClearRecordingsWarning: Bool = false
    @Published var presentingOverallResultCalculator: Bool = false
    
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
}
