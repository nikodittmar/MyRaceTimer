//
//  ContentView.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 7/24/22.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var coreData: CoreDataViewModel
    @StateObject var viewModel: ContentViewViewModel = ContentViewViewModel()
        
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Button {
                    coreData.handleRecordTime()
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
                
                HStack {
                    Text(viewModel.recordingCountLabel(count: coreData.recordings.count))
                    Spacer()
                    if coreData.timerIsActive {
                        Text("Since Last: \(coreData.timeElapsedString)")
                            .onReceive(coreData.timer) { _ in
                                coreData.updateTime()
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .font(.footnote)
                .padding(.horizontal)
                .padding(.vertical, 8)
                .border(Color(UIColor.systemGray4))
                .background(Color(UIColor.systemGray6))
                
                RecordingsList()
                
                if coreData.selectedResult?.wrappedType == ResultType.Start {
                    AddPlateButton()
                }
                
                NumberPad()
            }
            .navigationTitle("MyRaceTimer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.presentingResultSheet = true
                    } label: {
                        Text("Menu")
                    }
                }
            }
            .sheet(isPresented: $viewModel.presentingResultSheet) {
                ResultSheet()
            }
//            .sheet(isPresented: $viewModel.presentingImportSheet) {
//                ImportSheet(viewModel: viewModel)
//            }
//            .sheet(isPresented: $viewModel.presentingResultSheet) {
//                ResultsSheet()
//            }
            .alert("Unable to Import Result", isPresented: $coreData.presentingImportFailModal) {
                Button("Ok", role: .cancel) { }
            }
            .alert("Result Successfully Imported!", isPresented: $coreData.presentingImportSuccessModal) {
                Button("Ok", role: .cancel) { }
            }
            .ignoresSafeArea(.keyboard)
        }
    }
}
