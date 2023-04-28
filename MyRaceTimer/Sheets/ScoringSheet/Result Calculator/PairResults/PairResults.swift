////
////  PairRecordings.swift
////  MyRaceTimer
////
////  Created by niko dittmar on 2/18/23.
////
//
//import SwiftUI
//
//struct PairSelectedRecordingSets: View {
//    @EnvironmentObject var calculatorViewModel: RecordingSetCalculatorViewModel
//    
//    var body: some View {
//        VStack {
//            Form {
//                if !calculatorViewModel.selectedRecordingSets.isEmpty {
//                    Section(header: Text("Selected RecordingSets")) {
//                        List(calculatorViewModel.selectedRecordingSets, id: \.wrappedId) { RecordingSet in
//                            Button {
//                                calculatorViewModel.selectRecordingSetForPairing(RecordingSet: RecordingSet)
//                            } label: {
//                                HStack {
//                                    if calculatorViewModel.selectedRecordingSetForPairing?.wrappedId == RecordingSet.wrappedId {
//                                        Image(systemName: "circle.inset.filled")
//                                    } else {
//                                        Image(systemName: "circle")
//                                    }
//                                    
//                                    VStack(alignment: .leading, spacing: 2) {
//                                        if RecordingSet.wrappedName == "" {
//                                            Text("Untitled Stage")
//                                                .foregroundColor(.gray)
//                                                .lineLimit(1)
//                                                .padding(.top, 2)
//                                        } else {
//                                            Text(RecordingSet.wrappedName)
//                                                .padding(.top, 2)
//                                                .foregroundColor(.black)
//                                                .lineLimit(1)
//                                        }
//                                        Text("\(RecordingSet.wrappedRecordings.count) Recordings, Stage \(RecordingSet.wrappedType.rawValue.capitalized)")
//                                            .font(.caption)
//                                            .padding(.bottom, 2)
//                                            .foregroundColor(.black)
//                                    }
//                                    Spacer()
//                                    if RecordingSet.warningCount != 0 {
//                                        HStack {
//                                            Text(String(RecordingSet.warningCount))
//                                                .foregroundColor(.black)
//                                            Image(systemName: "exclamationmark.triangle.fill")
//                                                .foregroundColor(.yellow)
//                                        }
//                                    }
//                                }
//                            }
//                            .disabled(!calculatorViewModel.RecordingSetIsAvailibleForPairing(RecordingSet: RecordingSet))
//                        }
//                    }
//                }
//                if !calculatorViewModel.RecordingSetPairs.isEmpty {
//                    Section(header: Text("Paired RecordingSets")) {
//                        ForEach(calculatorViewModel.RecordingSetPairs, id: \.id) { RecordingSetPair in
//                            Button {
//                                calculatorViewModel.deleteRecordingSetPair(RecordingSetPair: RecordingSetPair)
//                            } label: {
//                                VStack {
//                                    HStack {
//                                        VStack(alignment: .leading, spacing: 2) {
//                                            if RecordingSetPair.start.wrappedName == "" {
//                                                Text("Untitled Stage")
//                                                    .foregroundColor(.gray)
//                                                    .lineLimit(1)
//                                                    .padding(.top, 2)
//                                            } else {
//                                                Text(RecordingSetPair.start.wrappedName)
//                                                    .padding(.top, 2)
//                                                    .foregroundColor(.black)
//                                                    .lineLimit(1)
//                                            }
//                                            Text("\(RecordingSetPair.start.wrappedRecordings.count) Recordings, Stage \(RecordingSetPair.start.wrappedType.rawValue.capitalized)")
//                                                .font(.caption)
//                                                .padding(.bottom, 2)
//                                                .foregroundColor(.black)
//                                        }
//                                        Spacer()
//                                        if RecordingSetPair.start.warningCount != 0 {
//                                            HStack {
//                                                Text(String(RecordingSetPair.start.warningCount))
//                                                    .foregroundColor(.black)
//                                                Image(systemName: "exclamationmark.triangle.fill")
//                                                    .foregroundColor(.yellow)
//                                            }
//                                        }
//                                    }
//                                    HStack {
//                                        VStack(alignment: .leading, spacing: 2) {
//                                            if RecordingSetPair.finish.wrappedName == "" {
//                                                Text("Untitled Stage")
//                                                    .foregroundColor(.gray)
//                                                    .lineLimit(1)
//                                                    .padding(.top, 2)
//                                            } else {
//                                                Text(RecordingSetPair.finish.wrappedName)
//                                                    .padding(.top, 2)
//                                                    .foregroundColor(.black)
//                                                    .lineLimit(1)
//                                            }
//                                            Text("\(RecordingSetPair.finish.wrappedRecordings.count) Recordings, Stage \(RecordingSetPair.finish.wrappedType.rawValue.capitalized)")
//                                                .font(.caption)
//                                                .padding(.bottom, 2)
//                                                .foregroundColor(.black)
//                                        }
//                                        Spacer()
//                                        if RecordingSetPair.finish.warningCount != 0 {
//                                            HStack {
//                                                Text(String(RecordingSetPair.finish.warningCount))
//                                                    .foregroundColor(.black)
//                                                Image(systemName: "exclamationmark.triangle.fill")
//                                                    .foregroundColor(.yellow)
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//                Section {
//                    Button {
//                        
//                    } label: {
//                        HStack {
//                            Text("Next")
//                            Spacer()
//                            Image(systemName: "chevron.right")
//                                .foregroundColor(Color(UIColor.systemGray))
//                        }
//                    }
//                    .disabled(!calculatorViewModel.selectedRecordingSets.isEmpty)
//                }
//            }
//        }
////        .toolbar {
////            ToolbarItem(placement: .navigationBarTrailing) {
////                NavigationLink {
////
////                } label: {
////                    Text("Next")
////                        .fontWeight(.bold)
////                }
////                .disabled(calculatorViewModel.selectedRecordingSets.isEmpty)
////            }
////        }
//        .navigationTitle("Pair RecordingSets")
//    }
//}
