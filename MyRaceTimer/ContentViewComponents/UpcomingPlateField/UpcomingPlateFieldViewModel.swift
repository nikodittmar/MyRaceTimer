//
//  UpcomingPlateFieldViewModel.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 4/21/23.
//

import Foundation
import SwiftUI

@MainActor class UpcomingPlateFieldViewModel: ObservableObject {
    
    func label(upcomingPlate: String) -> String {
        var label: String = upcomingPlate
        if label == "" {
            label = "-               -"
        }
        return label
    }
}
