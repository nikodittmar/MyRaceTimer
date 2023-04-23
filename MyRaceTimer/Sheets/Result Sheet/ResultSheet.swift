//
//  ResultSheet.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 8/4/22.
//

import SwiftUI

struct ResultSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var coreData: CoreDataViewModel
    @StateObject var viewModel: ResultSheetViewModel = ResultSheetViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Current Result")) {
                        TextField("Result Name", text: $coreData.resultName)
                            .onSubmit {
                                coreData.setResultName(coreData.resultName)
                            }
                        Picker("Timing Position", selection: $coreData.resultType) {
                            Text("Start")
                                .tag(ResultType.Start)
                            Text("Finish")
                                .tag(ResultType.Finish)
                        }
                        .onChange(of: coreData.resultType, perform: { (value) in
                            coreData.setResultType(value)
                        })
                        .pickerStyle(SegmentedPickerStyle())
//                        if viewModel.duplicatePlateNumbersIn(viewModel.timingResultSet) {
//                            HStack {
//                                Image(systemName: "exclamationmark.triangle.fill")
//                                    .foregroundColor(.yellow)
//                                Text("Duplicate Race Plate Numbers")
//                                    .foregroundColor(.black)
//                            }
//                        }
//                        if viewModel.missingPlateNumbersIn(viewModel.timingResultSet) {
//                            HStack {
//                                Image(systemName: "exclamationmark.triangle.fill")
//                                    .foregroundColor(.yellow)
//                                Text("Missing Race Plate Numbers")
//                                    .foregroundColor(.black)
//                            }
//                        }
                    }
                    Section {
                        ShareLink(item: coreData.selectedResult!, preview: SharePreview("result")) {
                            Text("Share Stage Result")
                        }
                        .disabled(coreData.selectedResultIsEmpty())
//                        ShareLink(item: viewModel.resultCsv(), preview: SharePreview(viewModel.exportableStageResultName())) {
//                            Text("Download Stage Result CSV")
//                        }
//                        .disabled(viewModel.emptyResultSet())
                    }
                    Section {
                        Button("Clear Recordings", role: .destructive) {
                            viewModel.presentingClearRecordingsWarning = true
                        }
                        .disabled(coreData.selectedResultIsEmpty())
                        Button("Delete Result", role: .destructive) {
                            viewModel.presentingDeleteResultWarning = true
                        }
                        .disabled(coreData.selectedResultIsEmpty())
                    }
                    Section(header: Text("Saved Stage Results")) {
                        Button("Create New Stage Result") {
                            coreData.createResult()
                        }
                        .disabled(coreData.selectedResultIsEmpty())
                        Section {
                            List(coreData.displayedResults(), id: \.wrappedId) { result in
                                Button {
                                    coreData.selectResult(result)
                                } label: {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 2) {
                                            if result.wrappedName == "" {
                                                Text("Untitled Stage")
                                                    .foregroundColor(.gray)
                                                    .lineLimit(1)
                                                    .padding(.top, 2)
                                            } else {
                                                Text(result.wrappedName)
                                                .padding(.top, 2)
                                                .foregroundColor(.black)
                                                .lineLimit(1)
                                            }
                                            Text(viewModel.resultLabel(recordingCount: result.wrappedRecordings.count))
                                                .font(.caption)
                                                .padding(.bottom, 2)
                                                .foregroundColor(.black)
                                        }
                                        Spacer()
//                                        if viewModel.warningCountIn(timingResult) != 0 {
//                                            HStack {
//                                                Text(String(viewModel.warningCountIn(timingResult)))
//                                                    .foregroundColor(.black)
//                                                Image(systemName: "exclamationmark.triangle.fill")
//                                                    .foregroundColor(.yellow)
//                                            }
//                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Stage Results"), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .alert("Are you sure you want to delete all recordings?", isPresented: $viewModel.presentingClearRecordingsWarning, actions: {
                Button("No", role: .cancel, action: {})
                Button("Yes", role: .destructive, action: {
                    coreData.clearRecordings()
                })
            }, message: {
                Text("This cannot be undone.")
            })
            .alert("Are you sure you want to delete this result?", isPresented: $viewModel.presentingDeleteResultWarning, actions: {
                Button("No", role: .cancel, action: {})
                Button("Yes", role: .destructive, action: {
                    coreData.deleteSelectedResult()
                })
            }, message: {
                Text("This cannot be undone.")
            })
        }
    }
}
