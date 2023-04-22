//
//  NumberPadViewModel.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 2/15/23.
//

import SwiftUI
import Foundation

@MainActor class NumberPadViewModel: ObservableObject {
    @Published var presentingDeleteWarning: Bool = false
}
