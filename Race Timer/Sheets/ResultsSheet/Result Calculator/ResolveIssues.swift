//
//  ResolveIssues.swift
//  Race Timer
//
//  Created by niko dittmar on 2/18/23.
//

import SwiftUI

struct ResolveIssues: View {
    @EnvironmentObject var viewModel: ResultsSheetViewModel
    
    var body: some View {
        VStack {
            Form {
                Section {
                    Text("The following Issues Were Found.")
                }
                ForEach(viewModel.timingResultPairs, id: \.id) { timingResultPair in
                    Text(timingResultPair.start.unwrappedName + ", " + timingResultPair.finish.unwrappedName)
                    Section(header: Text("No Matches Found")) {
                        List(timingResultPair.recordingsWithNoMatch(), id: \.id) { recording in
                            RecordingListItem(plate: recording.unwrappedPlate, timeString: recording.timeString, start: timingResultPair.recordingIsStart(recording))
                        }
                    }
                    Section(header: Text("Too Many Matches")) {
                        List(timingResultPair.recordingsWithTooManyMatches(), id: \.id) { recording in
                            RecordingListItem(plate: recording.unwrappedPlate, timeString: recording.timeString, start: timingResultPair.recordingIsStart(recording))
                        }
                    }
                    Section(header: Text("Missing Plates")) {
                        List(timingResultPair.recordingsWithNoPlate(), id: \.id) { recording in
                            RecordingListItem(plate: recording.unwrappedPlate, timeString: recording.timeString, start: timingResultPair.recordingIsStart(recording))
                        }
                    }
                }
            }
        }
    }
}

struct RecordingListItem: View {
    var plate: String
    var timeString: String
    var start: Bool
    
    var body: some View {
        HStack {
            Text(plate)
                .frame(width: 80, height: 20)
                .padding(6)
                .overlay(RoundedRectangle(cornerRadius: 8) .stroke(Color(UIColor.systemGray2), lineWidth: 0.5))
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
                .padding(.leading, 10)
            Spacer()
            if start {
                Text("START")
            } else {
                Text("FINISH")
            }
            Text(timeString)
        }
    }
}
