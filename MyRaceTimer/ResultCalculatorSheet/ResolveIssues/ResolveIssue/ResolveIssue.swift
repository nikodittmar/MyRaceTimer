//
//  ResolveIssue.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 5/2/23.
//

import SwiftUI

struct ResolveIssue: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: ResolveIssueViewModel
    
    init(recordingSetPair: RecordingSetPair) {
        _viewModel = StateObject(wrappedValue: ResolveIssueViewModel(recordingSetPair: recordingSetPair))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section(header: Text("Start")) {
                        ForEach(viewModel.recordingSetPair.start.wrappedRecordings, id: \.id) { recording in
                            IssueRecordingListItem(recording: recording, onTap: {
                                viewModel.selectRecording(recording)
                            }, selected: viewModel.selectedRecording == recording, errors: viewModel.getErrors(recording), errorCount: viewModel.errorCount(recording))
                            .listRowBackground(viewModel.selectedRecording == recording ? Color.accentColor.opacity(0.2) : .clear)
                        }
                    }
                    Section(header: Text("Finish")) {
                        ForEach(viewModel.recordingSetPair.finish.wrappedRecordings, id: \.id) { recording in
                            IssueRecordingListItem(recording: recording, onTap: {
                                viewModel.selectRecording(recording)
                            }, selected: viewModel.selectedRecording == recording, errors: viewModel.getErrors(recording), errorCount: viewModel.errorCount(recording))
                            .listRowBackground(viewModel.selectedRecording == recording ? Color.accentColor.opacity(0.2) : .clear)
                        }
                    }
                }
                .listStyle(.inset)
                NumberPad(onInputDigit: { (digit: Int) in
                    viewModel.handleAppendPlateDigit(digit: digit)
                }, onBackspace: {
                    viewModel.handleRemoveLastPlateDigit()
                }, onDelete: {
                    viewModel.handleDeleteRecording()
                })
            }
            .navigationTitle(viewModel.recordingSetPair.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            
        }
    }
}

struct IssueRecordingListItem: View {
    var recording: Recording
    var onTap: () -> Void
    var selected: Bool
    var errors: RecordingErrors
    var errorCount: Int
    
    var body: some View {
        Button {
            self.onTap()
        } label: {
            VStack {
                HStack {
                    Text(recording.plateLabel)
                        .frame(width: 80, height: 20)
                        .padding(6)
                        .overlay(RoundedRectangle(cornerRadius: 8) .stroke(Color(UIColor.systemGray2), lineWidth: 0.5))
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                        .accessibilityLabel("Plate")
                    if errorCount > 0 {
                        Text(errorCount == 1 ? "\(errorCount) Error" : "\(errorCount) Errors")
                            .foregroundColor(.yellow)
                            .font(.callout)
                    }
                    Spacer()
                    Text(recording.timestampString).font(.subheadline.monospaced())
                }
                if selected {
                    if errors.missingPlate {
                        Text("Missing Plate")
                            .font(.footnote)
                    }
                    if errors.multipleMatches {
                        Text("Multiple Matches")
                            .font(.footnote)
                    }
                    if errors.missingPlate {
                        Text("Missing Plate")
                            .font(.footnote)
                    }
                    if errors.noMatches {
                        Text("Missing Timestamp")
                            .font(.footnote)
                    }
                    if errors.negativeTime {
                        Text("Pair Results in Negative Time")
                            .font(.footnote)
                    }
                    
                }
            }
        }
    }
}
