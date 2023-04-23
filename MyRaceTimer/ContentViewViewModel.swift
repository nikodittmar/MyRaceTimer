//
//  ContentViewViewModel.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 2/15/23.
//

import SwiftUI
import Foundation

@MainActor class ContentViewViewModel: ObservableObject {
    @Published var presentingMenuSheet: Bool = false
    
    func recordingCountLabel(count: Int) -> String {
        return count == 1 ? "\(count) Recording" : "\(count) Recordings"
    }
}
