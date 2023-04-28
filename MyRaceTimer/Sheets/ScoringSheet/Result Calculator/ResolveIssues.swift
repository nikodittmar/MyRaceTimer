////
////  ResolveIssues.swift
////  MyRaceTimer
////
////  Created by niko dittmar on 2/18/23.
////
//
//import SwiftUI
//
//struct ResolveIssues: View {
//    @EnvironmentObject var viewModel: RecordingSetsSheetViewModel
//    
//    var body: some View {
//        VStack {
//            Form {
//                Section {
//                    Text("The following Issues Were Found.")
//                }
//                ForEach(viewModel.timingRecordingSetPairs, id: \.id) { timingRecordingSetPair in
//                    Text(timingRecordingSetPair.start.unwrappedName + ", " + timingRecordingSetPair.finish.unwrappedName)
//                    Section(header: Text("No Matches Found")) {
//                        List(timingRecordingSetPair.recordingsWithNoMatch(), id: \.id) { recording in
//                            RecordingListItem(plate: recording.unwrappedPlate, timeString: recording.timeString, start: timingRecordingSetPair.recordingIsStart(recording))
//                        }
//                    }
//                    Section(header: Text("Too Many Matches")) {
//                        List(timingRecordingSetPair.recordingsWithTooManyMatches(), id: \.id) { recording in
//                            RecordingListItem(plate: recording.unwrappedPlate, timeString: recording.timeString, start: timingRecordingSetPair.recordingIsStart(recording))
//                        }
//                    }
//                    Section(header: Text("Missing Plates")) {
//                        List(timingRecordingSetPair.recordingsWithNoPlate(), id: \.id) { recording in
//                            RecordingListItem(plate: recording.unwrappedPlate, timeString: recording.timeString, start: timingRecordingSetPair.recordingIsStart(recording))
//                        }
//                    }
//                }
//            }
//        }
//    }
//}
//
//struct RecordingListItem: View {
//    var plate: String
//    var timeString: String
//    var start: Bool
//    
//    var body: some View {
//        HStack {
//            Text(plate)
//                .frame(width: 80, height: 20)
//                .padding(6)
//                .overlay(RoundedRectangle(cornerRadius: 8) .stroke(Color(UIColor.systemGray2), lineWidth: 0.5))
//                .background(Color(UIColor.systemGray6))
//                .cornerRadius(8)
//                .padding(.leading, 10)
//            Spacer()
//            if start {
//                Text("START")
//            } else {
//                Text("FINISH")
//            }
//            Text(timeString)
//        }
//    }
//}
