//
//  PairRecordings.swift
//  Race Timer
//
//  Created by niko dittmar on 2/18/23.
//

import SwiftUI

struct PairRecordings: View {
    @EnvironmentObject var viewModel: ResultsSheetViewModel
    
    var body: some View {
        VStack {
            Form {
                Section {
                    Text("Pair Recordings")
                }
                ForEach(viewModel.timingResultPairs, id: \.id) { resultPair in
                    Section {
                        Button {
                            viewModel.deleteResultPair(resultPair: resultPair)
                        } label: {
                            VStack {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        if resultPair.start.unwrappedName == "" {
                                            Text("Untitled Stage")
                                                .foregroundColor(.gray)
                                                .lineLimit(1)
                                                .padding(.top, 2)
                                        } else {
                                            Text(resultPair.start.unwrappedName)
                                                .padding(.top, 2)
                                                .foregroundColor(.black)
                                                .lineLimit(1)
                                        }
                                        Text("\(resultPair.start.recordingCount) Recordings, Stage \(resultPair.start.recordingsTypeLabel)")
                                            .font(.caption)
                                            .padding(.bottom, 2)
                                            .foregroundColor(.black)
                                    }
                                    Spacer()
                                    if resultPair.start.recordingsIssuesCount != 0 {
                                        HStack {
                                            Text(String(resultPair.start.recordingsIssuesCount))
                                                .foregroundColor(.black)
                                            Image(systemName: "exclamationmark.triangle.fill")
                                                .foregroundColor(.yellow)
                                        }
                                    }
                                }
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        if resultPair.finish.unwrappedName == "" {
                                            Text("Untitled Stage")
                                                .foregroundColor(.gray)
                                                .lineLimit(1)
                                                .padding(.top, 2)
                                        } else {
                                            Text(resultPair.finish.unwrappedName)
                                                .padding(.top, 2)
                                                .foregroundColor(.black)
                                                .lineLimit(1)
                                        }
                                        Text("\(resultPair.finish.recordingCount) Recordings, Stage \(resultPair.finish.recordingsTypeLabel)")
                                            .font(.caption)
                                            .padding(.bottom, 2)
                                            .foregroundColor(.black)
                                    }
                                    Spacer()
                                    if resultPair.finish.recordingsIssuesCount != 0 {
                                        HStack {
                                            Text(String(resultPair.finish.recordingsIssuesCount))
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

                if !viewModel.selectedTimingResults.isEmpty {
                    Section(header: Text("Selected Results")) {
                        List(viewModel.selectedTimingResults, id: \.unwrappedId) { timingResult in
                            Button {
                                viewModel.selectPair(timingResult: timingResult)
                            } label: {
                                HStack {
                                    if viewModel.timingResultIsSelectedForPair(timingResult: timingResult) {
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
                            .disabled(!viewModel.timingResultIsAvailible(timingResult: timingResult))
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    ResolveIssues()
                } label: {
                    Text("Next")
                        .fontWeight(.bold)
                }
                .disabled(!viewModel.selectedTimingResults.isEmpty)
            }
        }
    }
}
