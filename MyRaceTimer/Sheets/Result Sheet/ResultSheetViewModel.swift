//
//  ResultSheetViewModel.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 2/15/23.
//

import Foundation

@MainActor class ResultSheetViewModel: ObservableObject {
    @Published var presentingDeleteResultWarning: Bool = false
    @Published var presentingClearRecordingsWarning: Bool = false
}
