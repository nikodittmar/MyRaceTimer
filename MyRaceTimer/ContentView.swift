//
//  ContentView.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 7/24/22.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: ContentViewViewModel
        
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Button {
                    viewModel.handleRecordTime()
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
                .accessibilityLabel("Record Time Button")
                
                HStack {
                    Text(viewModel.recordingCountLabel())
                    Spacer()
                    if viewModel.timerIsActive {
                        Text("Since Last: \(viewModel.timeElapsedString)")
                            .onReceive(viewModel.timer) { _ in
                                viewModel.updateTime()
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .font(.footnote)
                .padding(.horizontal)
                .padding(.vertical, 8)
                .border(Color(UIColor.systemGray4))
                .background(Color(UIColor.systemGray6))
                
                RecordingsList(recordings: viewModel.recordings, selectedRecording: viewModel.selectedRecording,selectRecording: { (recording: Recording) in viewModel.handleSelectRecording(recording: recording)})
                
                if viewModel.displayingUpcomingPlateButton() {
                    Button {
                        viewModel.handleAddUpcomingPlate()
                    } label: {
                        Text("Add Plate Number")
                            .foregroundColor(.blue)
                            .font(.title3)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .border(Color(UIColor.systemGray4))
                            .background(Color(UIColor.systemGray6))
                    }
                    .padding(.bottom, -1)
                }
                
                NumberPad(onInputDigit: { (digit: Int) in
                    viewModel.handleAppendPlateDigit(digit: digit)
                }, onBackspace: {
                    viewModel.handleRemoveLastPlateDigit()
                }, onDelete: {
                    viewModel.presentingDeleteResultWarning.toggle()
                })
            }
            .navigationTitle("MyRaceTimer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                    } label: {
                        Text("Results")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.presentingRecordingSetsSheet = true
                    } label: {
                        Text("Recordings")
                    }
                }
            }
            .alert("Are you sure you want to delete this recording?", isPresented: $viewModel.presentingDeleteResultWarning, actions: {
                Button("No", role: .cancel, action: {})
                Button("Yes", role: .destructive, action: {
                    viewModel.handleDeleteRecording()
                })
            }, message: {
                Text("This cannot be undone.")
            })
            .sheet(isPresented: $viewModel.presentingRecordingSetsSheet) {
                RecordingSetsSheet(update: {
                    viewModel.updateRecordings()
                }, deactivateTimer: {
                    viewModel.deactivateTimer()
                })
            }
            .ignoresSafeArea(.keyboard)
        }
    }
}
