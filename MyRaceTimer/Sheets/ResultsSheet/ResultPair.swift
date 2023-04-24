//
//  ResultPair.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 4/23/23.
//

import Foundation
import SwiftUI

struct ResultPair: Identifiable {
    var id: UUID = UUID()
    var start: Result
    var finish: Result
}
