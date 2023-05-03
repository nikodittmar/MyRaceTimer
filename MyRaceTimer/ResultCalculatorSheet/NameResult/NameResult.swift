//
//  ResultNaming.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 5/2/23.
//

import SwiftUI

struct NameResult: View {
    @StateObject var viewModel: NameResultViewModel
    @EnvironmentObject var resultViewModel: ResultSheetViewModel
    
    init(recordingSetPairs: [RecordingSetPair]) {
        _viewModel = StateObject(wrappedValue: NameResultViewModel(recordingSetPairs: recordingSetPairs))
    }
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Result Name")) {
                    TextField("Result Name", text: $viewModel.resultName)
                }
                ForEach($viewModel.recordingSetPairs, id: \.id) { $recordingSetPair in
                    Section(header: Text(viewModel.pairName(recordingSetPair: recordingSetPair))) {
                        TextField("Stage Name", text: $recordingSetPair.name)
                    }
                }
                Section {
                    Button {
                        if let result = viewModel.createResult() {
                            resultViewModel.navigateToResult(result: result)
                        } else {
                            viewModel.navigatingToResolveIssues = true
                        }
                    } label: {
                        HStack {
                            Text("Next")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color(UIColor.systemGray))
                        }
                        
                    }
                    .navigationDestination(isPresented: $viewModel.navigatingToResolveIssues) {
                        IssuesNavigator(recordingSetPairs: viewModel.recordingSetPairs, resultName: viewModel.resultName)
                    }
                }
            }
            .navigationTitle("Name Result")
        }
    }
}

