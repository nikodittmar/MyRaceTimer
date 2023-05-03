//
//  ResolveIssue.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 5/2/23.
//

import SwiftUI

struct ResolveIssuesSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: ResolveIssuesSheetViewModel
    
    init(recordingSetPair: RecordingSetPair, resultName: String) {
        _viewModel = StateObject(wrappedValue: ResolveIssuesSheetViewModel(recordingSetPair: recordingSetPair))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section(header: Text("Start")) {
                        ForEach(viewModel.recordingSetPair.start.wrappedRecordings, id: \.id) { recording in
                            IssueRecordingListItem(recording: recording, onTap: {
                                viewModel.selectRecording(recording)
                            }, selected: viewModel.selectedRecording == recording, issues: viewModel.issuesFor(recording))
                            .listRowBackground(viewModel.selectedRecording == recording ? Color.accentColor.opacity(0.2) : .clear)
                        }
                    }
                    Section(header: Text("Finish")) {
                        ForEach(viewModel.recordingSetPair.finish.wrappedRecordings, id: \.id) { recording in
                            IssueRecordingListItem(recording: recording, onTap: {
                                viewModel.selectRecording(recording)
                            }, selected: viewModel.selectedRecording == recording, issues: viewModel.issuesFor(recording))
                            .listRowBackground(viewModel.selectedRecording == recording ? Color.accentColor.opacity(0.2) : .clear)
                        }
                    }
                }
                .padding(.bottom, -8)
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
    var issues: [RecordingIssue]
    
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
                    if issues.count > 0 {
                        Text(issues.count == 1 ? "\(String(issues.count)) Issue" : "\(String(issues.count)) Issues")
                            .foregroundColor(.yellow)
                            .font(.callout)
                    }
                    Spacer()
                    Text(recording.timestampString).font(.subheadline.monospaced())
                }
                if selected {
                    HStack {
                        VStack(alignment: .leading) {
                            ForEach(issues, id: \.self) { issue in
                                Text(issue.rawValue.uppercased())
                                    .font(.footnote.bold())
                                    .foregroundColor(Color(UIColor.secondaryLabel))
                                
                            }
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}
