//
//  RecordingSetsSheet.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 8/4/22.
//

import SwiftUI
import CoreTransferable

struct RecordingSetsSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: RecordingSetsSheetViewModel = RecordingSetsSheetViewModel()
    
    var update: () -> Void
    var deactivateTimer: () -> Void
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(header: Text("Current Recording Set")) {
                        TextField("Recording Set Name", text: $viewModel.selectedRecordingSetName)
                            .onSubmit {
                                viewModel.updateRecordingSetName()
                            }
                        Picker("Recordings Type", selection: $viewModel.selectedRecordingSetType) {
                            Text("Start")
                                .tag(RecordingsType.Start)
                            Text("Finish")
                                .tag(RecordingsType.Finish)
                        }
                        .onChange(of: viewModel.selectedRecordingSetType, perform: { (value) in
                            viewModel.updateRecordingSetType()
                            self.update()
                        })
                        .pickerStyle(SegmentedPickerStyle())
                        
                        if viewModel.selectedRecordingSetHasDuplicatePlates() {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.yellow)
                                Text("Duplicate Race Plate Numbers")
                                    .foregroundColor(.black)
                            }
                        }
                        
                        if viewModel.selectedRecordingSetHasMissingPlates() {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.yellow)
                                Text("Missing Race Plate Numbers")
                                    .foregroundColor(.black)
                            }
                        }
                        
                        if viewModel.selectedRecordingSetHasMissingTimestamps() {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.yellow)
                                Text("Missing Timestamps")
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    Section {
                        Button("Delete Recording Set", role: .destructive) {
                            viewModel.presentingDeleteRecordingSetWarning = true
                        }
                        .disabled(viewModel.selectedRecordingSetIsEmpty())
                    }
                    Section(header: Text("Saved Recording Sets")) {
                        Button("Create New Recording Set") {
                            viewModel.createRecordingSet()
                            self.update()
                            self.deactivateTimer()
                        }
                        .disabled(viewModel.selectedRecordingSetIsEmpty())
                        Section {
                            List(viewModel.recordingSetsWithoutSelectedRecordingSet(), id: \.wrappedId) { recordingSet in
                                Button {
                                    viewModel.selectRecordingSet(recordingSet)
                                    self.update()
                                    self.deactivateTimer()
                                } label: {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 2) {
                                            if recordingSet.wrappedName == "" {
                                                Text("Untitled Stage")
                                                    .foregroundColor(.gray)
                                                    .lineLimit(1)
                                                    .padding(.top, 2)
                                            } else {
                                                Text(recordingSet.wrappedName)
                                                    .padding(.top, 2)
                                                    .foregroundColor(.black)
                                                    .lineLimit(1)
                                            }
                                            Text(recordingSet.label)
                                                .font(.caption)
                                                .padding(.bottom, 2)
                                                .foregroundColor(.black)
                                        }
                                        Spacer()
                                        if recordingSet.warningCount != 0 {
                                            HStack {
                                                Text(String(recordingSet.warningCount))
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
            .navigationBarTitle(Text("Recording Sets"), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.exportSelectedRecordingSet()
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .disabled(viewModel.selectedRecordingSetIsEmpty())
                }
            }
            .alert("Are you sure you want to delete this Recording Set?", isPresented: $viewModel.presentingDeleteRecordingSetWarning, actions: {
                Button("No", role: .cancel, action: {})
                Button("Yes", role: .destructive, action: {
                    viewModel.deleteSelectedRecordingSet()
                    self.update()
                })
            }, message: {
                Text("This cannot be undone.")
            })
            .sheet(isPresented: $viewModel.presentingShareSheet, content: {
                ActivityViewController(itemsToShare: viewModel.fileToShareURL)
            })
        }
    }
}
