//
//  SelectRecordings.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 2/18/23.
//

import SwiftUI

struct SelectRecordingSets: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: SelectRecordingSetsViewModel = SelectRecordingSetsViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(header: Text("Recording Sets")) {
                        List(viewModel.recordingSets, id: \.wrappedId) { recordingSet in
                            Button {
                                viewModel.selectRecordingSet(recordingSet: recordingSet)
                            } label: {
                                HStack {
                                    if viewModel.selectedRecordingSets.contains(recordingSet) {
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
                                                .foregroundColor(Color(UIColor.label))
                                                .padding(.top, 2)
                                                .lineLimit(1)
                                        }
                                        Text(recordingSet.label)
                                            .foregroundColor(Color(UIColor.label))
                                            .font(.caption)
                                            .padding(.bottom, 2)
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
                        .disabled(viewModel.selectedRecordingSets.isEmpty)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .fontWeight(.bold)
                    }
                }
            }
            .navigationDestination(isPresented: $viewModel.navigatingToPairRecordingSets) {
                PairSelectedRecordingSets(selectedRecordingSets: viewModel.selectedRecordingSets)
            }
            .navigationTitle("Select Recording Sets")
            .alert("Select the same amount of start and finish Recording Sets to continue.", isPresented: $viewModel.presentingUnequalSelectionWarning) {
                Button("Ok", role: .cancel) {}
            }
        }
    }
}
