//
//  MyRaceTimerApp.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 7/24/22.
//

import SwiftUI

@main
struct MyRaceTimerApp: App {
    
    @StateObject var viewModel: ContentViewViewModel = ContentViewViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
                .onOpenURL(perform: { url in
                    viewModel.importRecordingSet(url: url)
                })
        }
    }
}
