//
//  Race_TimerApp.swift
//  Race Timer
//
//  Created by niko dittmar on 7/24/22.
//

import SwiftUI

@main
struct Race_TimerApp: App {
    @StateObject var viewModel: ContentViewViewModel = ContentViewViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(coreDM: DataController(), viewModel: viewModel)
                .onOpenURL(perform: { url in
                    viewModel.importStageResult(url: url)
                })
        }
    }
}
