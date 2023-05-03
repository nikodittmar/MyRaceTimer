//
//  ResolveIssues.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 4/30/23.
//

import SwiftUI

struct ResolveIssues: View {
    @StateObject var viewModel: ResolveIssuesViewModel
    
    init(recordingSetPairs: [RecordingSetPair]) {
        _viewModel = StateObject(wrappedValue: ResolveIssuesViewModel(recordingSetPairs: recordingSetPairs))
    }
    
    var body: some View {
        VStack {
            Form {
                List(viewModel.recordingSetPairs, id: \.id) { recordingSetPair in
                    if viewModel.errorCount(recordingSetPair: recordingSetPair) > 0 {
                        Section(header: Text(recordingSetPair.name)) {
                            Text("\(String(viewModel.errorCount(recordingSetPair: recordingSetPair))) Issues Found.")
                                .foregroundColor(.yellow)
                            Button("Resolve") {
                                viewModel.selectedRecordingSetPair = recordingSetPair
                            }

                        }
                    }
                }
            }
            .sheet(item: $viewModel.selectedRecordingSetPair, content: { recordingSetPair in
                ResolveIssue(recordingSetPair: recordingSetPair)
            })
            .navigationTitle("Resolve Issues")
        }
    }
}

