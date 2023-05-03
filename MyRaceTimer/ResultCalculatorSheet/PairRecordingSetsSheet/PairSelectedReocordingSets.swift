//
//  PairRecordings.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 2/18/23.
//

import SwiftUI

struct PairSelectedRecordingSets: View {
    @StateObject var viewModel: PairSelectedRecordingSetsViewModel
    
    init(selectedRecordingSets: [RecordingSet]) {
        _viewModel = StateObject(wrappedValue: PairSelectedRecordingSetsViewModel(selectedRecordingSets: selectedRecordingSets))
    }
    
    var body: some View {
        VStack {
            Form {
                if !viewModel.selectedRecordingSets.isEmpty {
                    Section(header: Text("Selected Recording Sets")) {
                        List(viewModel.selectedRecordingSets, id: \.wrappedId) { recordingSet in
                            Button {
                                viewModel.selectRecordingSetForPairing(recordingSet)
                            } label: {
                                HStack {
                                    if viewModel.selectedRecordingSetForPairing?.wrappedId == recordingSet.wrappedId {
                                        Image(systemName: "circle.inset.filled")
                                    } else {
                                        Image(systemName: "circle")
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        if recordingSet.wrappedName == "" {
                                            Text("Untitled Stage")
                                                .foregroundColor(.gray)
                                                .lineLimit(1)
                                                .padding(.top, 2)
                                        } else {
                                            Text(recordingSet.wrappedName)
                                                .padding(.top, 2)
                                                .foregroundColor(Color(UIColor.label))
                                                .lineLimit(1)
                                        }
                                        Text(recordingSet.label)
                                            .font(.caption)
                                            .padding(.bottom, 2)
                                            .foregroundColor(Color(UIColor.label))
                                    }
                                    Spacer()
                                    if recordingSet.warningCount != 0 {
                                        HStack {
                                            Text(String(recordingSet.warningCount))
                                                .foregroundColor(Color(UIColor.label))
                                            Image(systemName: "exclamationmark.triangle.fill")
                                                .foregroundColor(.yellow)
                                        }
                                    }
                                }
                            }
                            .disabled(viewModel.recordingSetIsDisabled(recordingSet))
                        }
                    }
                }
                if !viewModel.recordingSetPairs.isEmpty {
                    Section(header: Text("Paired Recording Sets")) {
                        ForEach(viewModel.recordingSetPairs, id: \.id) { recordingSetPair in
                            Button {
                                viewModel.deleteRecordingSetPair(recordingSetPair)
                            } label: {
                                VStack {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 2) {
                                            if recordingSetPair.start.wrappedName == "" {
                                                Text("Untitled Stage")
                                                    .foregroundColor(.gray)
                                                    .lineLimit(1)
                                                    .padding(.top, 2)
                                            } else {
                                                Text(recordingSetPair.start.wrappedName)
                                                    .padding(.top, 2)
                                                    .foregroundColor(Color(UIColor.label))
                                                    .lineLimit(1)
                                            }
                                            Text(recordingSetPair.start.label)
                                                .font(.caption)
                                                .padding(.bottom, 2)
                                                .foregroundColor(Color(UIColor.label))
                                        }
                                        Spacer()
                                        if recordingSetPair.start.warningCount != 0 {
                                            HStack {
                                                Text(String(recordingSetPair.start.warningCount))
                                                    .foregroundColor(Color(UIColor.label))
                                                Image(systemName: "exclamationmark.triangle.fill")
                                                    .foregroundColor(.yellow)
                                            }
                                        }
                                    }
                                    HStack {
                                        VStack(alignment: .leading, spacing: 2) {
                                            if recordingSetPair.finish.wrappedName == "" {
                                                Text("Untitled Stage")
                                                    .foregroundColor(.gray)
                                                    .lineLimit(1)
                                                    .padding(.top, 2)
                                            } else {
                                                Text(recordingSetPair.finish.wrappedName)
                                                    .padding(.top, 2)
                                                    .foregroundColor(Color(UIColor.label))
                                                    .lineLimit(1)
                                            }
                                            Text(recordingSetPair.finish.label)
                                                .font(.caption)
                                                .padding(.bottom, 2)
                                                .foregroundColor(Color(UIColor.label))
                                        }
                                        Spacer()
                                        if recordingSetPair.finish.warningCount != 0 {
                                            HStack {
                                                Text(String(recordingSetPair.finish.warningCount))
                                                    .foregroundColor(Color(UIColor.label))
                                                Image(systemName: "exclamationmark.triangle.fill")
                                                    .foregroundColor(.yellow)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                Section {
                    Button {
                        viewModel.next()
                    } label: {
                        HStack {
                            Text("Next")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color(UIColor.systemGray))
                        }
                        
                    }
                    .disabled(!viewModel.selectedRecordingSets.isEmpty)
                    .navigationDestination(isPresented: $viewModel.navigatingToResolveIssues) {
                        ResolveIssues(recordingSetPairs: viewModel.recordingSetPairs)
                    }
                }

//                .navigationDestination(isPresented: $viewModel.navigatingToResultName) {
//                    ResultName()
//                }
            }
        }
        .navigationTitle("Pair Recording Sets")
    }
}
