//
//  ResolveIssues.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 4/30/23.
//

import SwiftUI

struct IssuesNavigator: View {
    @StateObject var viewModel: IssuesNavigatorViewModel
    @EnvironmentObject var resultViewModel: ResultSheetViewModel
    
    init(recordingSetPairs: [RecordingSetPair], resultName: String) {
        _viewModel = StateObject(wrappedValue: IssuesNavigatorViewModel(recordingSetPairs: recordingSetPairs, resultName: resultName))
    }
    
    var body: some View {
        VStack {
            Form {
                List(viewModel.recordingSetPairs, id: \.id) { recordingSetPair in
                    Section(header: Text(recordingSetPair.name)) {
                        Text(viewModel.issueCountFor(recordingSetPair: recordingSetPair) == 1 ? "\(String(viewModel.issueCountFor(recordingSetPair: recordingSetPair))) Issue Found." : "\(String(viewModel.issueCountFor(recordingSetPair: recordingSetPair))) Issues Found.")
                        Button("Edit") {
                            viewModel.selectedRecordingSetPair = recordingSetPair
                        }
                    }
                }
                Section {
                    Button {
                        if let result = viewModel.createResult() {
                            resultViewModel.navigateToResult(result: result)
                        } else {
                            viewModel.presentingFixAllErrorsModal = true
                        }
                    } label: {
                        HStack {
                            Text("Next")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color(UIColor.systemGray))
                        }
                        
                    }
                    .alert("Please fix all errors before continuing.", isPresented: $viewModel.presentingFixAllErrorsModal, actions: {
                        Button("Ok", role: .cancel, action: {})
                    })
                }
            }
            .sheet(item: $viewModel.selectedRecordingSetPair, content: { recordingSetPair in
                ResolveIssuesSheet(recordingSetPair: recordingSetPair, resultName: viewModel.resultName)
            })
            .navigationTitle("Resolve Issues")
        }
    }
}

