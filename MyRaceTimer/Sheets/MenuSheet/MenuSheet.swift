//
//  MenuSheet.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 8/4/22.
//

import SwiftUI
import CoreTransferable

struct MenuSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var coreData: CoreDataViewModel
    @StateObject var viewModel: MenuSheetViewModel = MenuSheetViewModel()
    
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
                        if coreData.selectedResult?.hasDuplicatePlates ?? false {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.yellow)
                                Text("Duplicate Race Plate Numbers")
                                    .foregroundColor(.black)
                            }
                        }
                        if coreData.selectedResult?.missingPlates ?? false {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.yellow)
                                Text("Missing Race Plate Numbers")
                                    .foregroundColor(.black)
                            }
                        }
                        if coreData.selectedResult?.missingTimestamps ?? false {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.yellow)
                                Text("Missing Timestamps")
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    Section {
                        Button("Share Result") {
                            coreData.exportResult()
                        }
                        .disabled(coreData.selectedResultIsEmpty())
                        Button("Download Result CSV") {
                            coreData.exportResultCSV()
                        }
                        .disabled(coreData.selectedResultIsEmpty())
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
                                        if result.warningCount != 0 {
                                            HStack {
                                                Text(String(result.warningCount))
                                                    .foregroundColor(.black)
                                                Image(systemName: "exclamationmark.triangle.fill")
                                                    .foregroundColor(.yellow)
                                            }
                                        }
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
            .sheet(isPresented: $coreData.presentingShareSheet, content: {
                ActivityViewController(itemsToShare: coreData.fileToShareURL)
            })
        }
    }
}
