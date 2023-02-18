//
//  ContentView.swift
//  Race Timer
//
//  Created by niko dittmar on 7/24/22.
//

import SwiftUI

struct ContentView: View {
    
    let coreDM: DataController
    
    @ObservedObject var viewModel: ContentViewViewModel
    
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
                
                HStack {
                    Text(viewModel.results.count == 1 ? "\(viewModel.results.count) Recording" : "\(viewModel.results.count) Recordings")
                    Spacer()
                    Text("Since Last: \(viewModel.timeElapsedString)")
                        .onReceive(viewModel.timer) { _ in
                            viewModel.updateTime()
                        }
                }
                .frame(maxWidth: .infinity)
                .font(.footnote)
                .padding(.horizontal)
                .padding(.vertical, 8)
                .border(Color(UIColor.systemGray4))
                .background(Color(UIColor.systemGray6))
                
                ResultsList(viewModel: viewModel)
                
                if viewModel.recordingsType == .start {
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
                        Text("Stage")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        
                    } label: {
                        Text("Race")
                    }
                }
            }
            .sheet(isPresented: $viewModel.presentingMenuSheet) {
                StageSheet(viewModel: viewModel)
            }
            .sheet(isPresented: $viewModel.presentingImportSheet) {
                ImportSheet(viewModel: viewModel)
            }
            .alert("Unable to Import Stage Result", isPresented: $viewModel.presentingImportErrorWarning) {
                Button("Ok", role: .cancel) { }
            }
            .ignoresSafeArea(.keyboard)
        }
    }
}
