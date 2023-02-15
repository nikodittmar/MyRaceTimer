//
//  ContentView.swift
//  Race Timer
//
//  Created by niko dittmar on 7/24/22.
//

import SwiftUI

struct ContentView: View {
    
    let coreDM: DataController
    
    @StateObject var viewModel: ContentViewViewModel = ContentViewViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Button {
                    viewModel.recordTime()
                } label: {
                    Text("Record Time")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .font(.title3)
                        .foregroundColor(.white)
                        .background(.blue)
                        .border(Color(UIColor.systemGray5))
                }
                .padding(.top, 8)
                .padding(.bottom, -1)
                
                Text(viewModel.results.count == 1 ? "\(viewModel.results.count) Recording" : "\(viewModel.results.count) Recordings")
                    .frame(maxWidth: .infinity)
                    .font(.footnote)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .border(Color(UIColor.systemGray4))
                    .background(Color(UIColor.systemGray6))
                
                ResultsList(viewModel: viewModel)
                
                if viewModel.timingMode == .start {
                    UpcomingPlateEntry(viewModel: viewModel)
                }
                
                NumberPad(viewModel: viewModel)
            }
            .navigationTitle("MyRaceTimer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        viewModel.presentingMenuSheet = true
                    } label: {
                        Text("Menu")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if viewModel.plateList.count < viewModel.results.count && viewModel.plateList.hasDuplicates() {
                            viewModel.presentingDuplicateAndMissingPlateWarning = true
                        } else if viewModel.plateList.hasDuplicates() {
                            viewModel.presentingDuplicatePlateWarning = true
                        } else if viewModel.plateList.count < viewModel.results.count {
                            viewModel.presentingMissingPlateWarning = true
                        } else {
                            viewModel.presentingExportSheet = true
                        }
                    } label: {
                        Text("Finish")
                            .fontWeight(.bold)
                    }
                    .disabled(viewModel.results.isEmpty)
                }
            }
            .alert("Some recordings are missing plate numbers.", isPresented: $viewModel.presentingMissingPlateWarning, actions: {
                Button("Cancel", action: {})
                Button("Continue", action: {
                    viewModel.presentingExportSheet = true
                })
            }, message: {
                Text("Would you like to continue?")
            })
            .alert("Some recordings have duplicate plate numbers.", isPresented: $viewModel.presentingDuplicatePlateWarning, actions: {
                Button("Cancel", action: {})
                Button("Continue", action: {
                    viewModel.presentingExportSheet = true
                })
            }, message: {
                Text("Would you like to continue?")
            })
            .alert("Some recordings have duplicate or missing plate numbers.", isPresented: $viewModel.presentingDuplicateAndMissingPlateWarning, actions: {
                Button("Cancel", action: {})
                Button("Continue", action: {
                    viewModel.presentingExportSheet = true
                })
            }, message: {
                Text("Would you like to continue?")
            })
            .sheet(isPresented: $viewModel.presentingExportSheet) {
                ExportRecordingsSheet(viewModel: viewModel)
            }
            .sheet(isPresented: $viewModel.presentingMenuSheet) {
                MenuSheet(viewModel: viewModel)
            }
            .ignoresSafeArea(.keyboard)
        }
    }
}

enum TimingMode {
    case start
    case finish
}
