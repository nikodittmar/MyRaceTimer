//
//  SelectRecordings.swift
//  Race Timer
//
//  Created by niko dittmar on 2/18/23.
//

import SwiftUI

struct SelectRecordings: View {
    @EnvironmentObject var viewModel: ResultsSheetViewModel
    
    var body: some View {
        VStack {
            Form {
                Section {
                    Text("Select all race results.")
                }
                List(viewModel.allTimingResults(), id: \.unwrappedId) { timingResult in
                    Button {
                        viewModel.toggleTimingResultSelection(timingResult: timingResult)
                    } label: {
                        HStack {
                            if viewModel.timingResultIsSelected(timingResult: timingResult) {
                                Image(systemName: "circle.inset.filled")
                            } else {
                                Image(systemName: "circle")
                            }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                if timingResult.unwrappedName == "" {
                                    Text("Untitled Stage")
                                        .foregroundColor(.gray)
                                        .lineLimit(1)
                                        .padding(.top, 2)
                                } else {
                                    Text(timingResult.unwrappedName)
                                    .padding(.top, 2)
                                    .foregroundColor(.black)
                                    .lineLimit(1)
                                }
                                Text("\(timingResult.recordingCount) Recordings, Stage \(timingResult.recordingsTypeLabel)")
                                    .font(.caption)
                                    .padding(.bottom, 2)
                                    .foregroundColor(.black)
                            }
                            Spacer()
                            if timingResult.recordingsIssuesCount != 0 {
                                HStack {
                                    Text(String(timingResult.recordingsIssuesCount))
                                        .foregroundColor(.black)
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundColor(.yellow)
                                }
                            }
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.selectRecordingsNextButton()
                } label: {
                    Text("Next")
                        .fontWeight(.bold)
                }
                .disabled(viewModel.selectedTimingResults.isEmpty)
            }
        }
        .navigationDestination(isPresented: $viewModel.navigateToPairRecordings) {
            PairRecordings()
        }
        .alert("Select the same amount of start and finish results to continue.", isPresented: $viewModel.displayingIncorrectSelectionWarning) {
            Button("Ok", role: .cancel) {}
        }
    }
}
