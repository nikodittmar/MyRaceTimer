//
//  Race_TimerApp.swift
//  Race Timer
//
//  Created by niko dittmar on 7/24/22.
//

import SwiftUI

@main
struct Race_TimerApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView(coreDM: DataController())
        }
    }
}
