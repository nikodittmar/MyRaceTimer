//
//  SettingsSheet.swift
//  Race Timer
//
//  Created by niko dittmar on 8/4/22.
//

import SwiftUI

struct SettingsSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ViewModel = ViewModel()
    
    @AppStorage("showNextPlateEntry") var nextPlateEntry: Bool = DefaultSettings.nextPlateEntryScreen
    
    let coreDM: DataController = DataController()
    
    var resetAction: () -> ()
    
    @Binding var nextPlate: String?
    @Binding var plateList: [String]
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        Toggle("Next Plate Entry", isOn: $nextPlateEntry)
                            .onChange(of: nextPlateEntry) { plateOn in
                                nextPlate = nil
                                plateList = coreDM.getAllPlates()
                            }
                    }
                    Section {
                        Button("CLEAR RECORDINGS", role: .destructive) {
                            viewModel.presentingResetWarning = true
                        }
                    }
                    Section {
                        Button("Calculate Results") {
                            
                        }
                    }
                    Section {
                        Button("Load Results") {
                            
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Settings"), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done", role:.cancel) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .alert("Are you sure you want to delete all recordings?", isPresented: $viewModel.presentingResetWarning, actions: {
                Button("No", role: .cancel, action: {})
                Button("Yes", role: .destructive, action: {
                    self.resetAction()
                    presentationMode.wrappedValue.dismiss()
                })
            }, message: {
                Text("This cannot be undone.")
            })
        }
    }
}

extension SettingsSheet {
    @MainActor class ViewModel: ObservableObject {
        @Published var password: String = ""
        @Published var presentingResetWarning: Bool = false
        @Published var incorrectPasswordWarning: Bool = false
        
    }
}

