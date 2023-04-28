////
////  SelectRecordings.swift
////  MyRaceTimer
////
////  Created by niko dittmar on 2/18/23.
////
//
//import SwiftUI
//
//struct SelectRecordingSets: View {
//    @Environment(\.dismiss) var dismiss
//    @StateObject var calculatorViewModel: RecordingSetCalculatorViewModel = RecordingSetCalculatorViewModel()
//    @StateObject var viewModel: SelectRecordingSetsViewModel = SelectRecordingSetsViewModel()
//    
//    var body: some View {
//        NavigationStack {
//            VStack {
//                Form {
//                    Section(header: Text("RecordingSets")) {
//                        List(coreData.recordingSets, id: \.wrappedId) { recordingSet in
//                            Button {
//                                calculatorViewModel.toggleRecordingSetSelection(RecordingSet: recordingSet)
//                            } label: {
//                                HStack {
//                                    if calculatorViewModel.selectedRecordingSets.contains(recordingSet) {
//                                        Image(systemName: "circle.inset.filled")
//                                    } else {
//                                        Image(systemName: "circle")
//                                    }
//                                    
//                                    VStack(alignment: .leading, spacing: 2) {
//                                        if recordingSet.wrappedName == "" {
//                                            Text("Untitled Stage")
//                                                .foregroundColor(.gray)
//                                                .lineLimit(1)
//                                                .padding(.top, 2)
//                                        } else {
//                                            Text(recordingSet.wrappedName)
//                                                .padding(.top, 2)
//                                                .foregroundColor(.black)
//                                                .lineLimit(1)
//                                        }
//                                        Text(calculatorViewModel.RecordingSetLabel(RecordingSet: recordingSet))
//                                            .font(.caption)
//                                            .padding(.bottom, 2)
//                                            .foregroundColor(.black)
//                                    }
//                                    Spacer()
//                                    if recordingSet.warningCount != 0 {
//                                        HStack {
//                                            Text(String(recordingSet.warningCount))
//                                                .foregroundColor(.black)
//                                            Image(systemName: "exclamationmark.triangle.fill")
//                                                .foregroundColor(.yellow)
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                    Section {
//                        Button {
//                            viewModel.next(selectedRecordingSets: calculatorViewModel.selectedRecordingSets)
//                            calculatorViewModel.RecordingSetPairs = []
//                        } label: {
//                            HStack {
//                                Text("Next")
//                                Spacer()
//                                Image(systemName: "chevron.right")
//                                    .foregroundColor(Color(UIColor.systemGray))
//                            }
//                        }
//                        .disabled(calculatorViewModel.selectedRecordingSets.isEmpty)
//                    }
//                }
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button {
//                        dismiss()
//                    } label: {
//                        Text("Cancel")
//                            .fontWeight(.bold)
//                    }
//                }
//            }
//            .navigationDestination(isPresented: $viewModel.navigatingToPairRecordingSets) {
//                PairSelectedRecordingSets()
//            }
//            .navigationTitle("Select RecordingSets")
//            .alert("Select the same amount of start and finish RecordingSets to continue.", isPresented: $viewModel.presentingUnequalSelectionWarning) {
//                Button("Ok", role: .cancel) {}
//            }
//            
//        }
//        .environmentObject(calculatorViewModel)
//
//    }
//}
