//
//  MyRaceTimerApp.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 7/24/22.
//

import SwiftUI

@main
struct MyRaceTimerApp: App {
    @StateObject var coreData: CoreDataViewModel = CoreDataViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(coreData)
                .onOpenURL(perform: { url in
                    coreData.importResult(url: url)
                })
                
        }
    }
}
