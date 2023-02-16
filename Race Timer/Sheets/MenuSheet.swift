//
//  MenuSheet.swift
//  Race Timer
//
//  Created by niko dittmar on 8/4/22.
//

import SwiftUI

struct MenuSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ContentViewViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Current Result")) {
                        TextField("Stage Name", text: $viewModel.stageName)
                            .onSubmit {
                                viewModel.updateTimingResultDetails()
                            }
                        Picker("Timing Position", selection: $viewModel.recordingsType) {
                            Text("Stage Start")
                                .tag(TimingMode.start)
                            Text("Stage Finish")
                                .tag(TimingMode.finish)
                        }
                        .onChange(of: viewModel.recordingsType, perform: { (value) in
                            viewModel.updateTimingResultDetails()
                        })
                        .pickerStyle(SegmentedPickerStyle())
                        if viewModel.duplicatePlateNumbersIn(viewModel.timingResultSet) {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.yellow)
                                Text("Duplicate Race Plate Numbers")
                                    .foregroundColor(.black)
                            }
                        }
                        if viewModel.missingPlateNumbersIn(viewModel.timingResultSet) {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.yellow)
                                Text("Missing Race Plate Numbers")
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    Section {
                        Button("Clear Recordings", role: .destructive) {
                            viewModel.deleteAllRecordingsFrom(viewModel.timingResultSet)
                        }
                        Button("Delete Result", role: .destructive) {
                            viewModel.clearResult()
                        }
                    }
                    Section(header: Text("Saved Results")) {
                        Button("Create New Result") {
                            viewModel.newRecordingSet()
                        }
                        Section {
                            List(viewModel.allTimingResults(), id: \.unwrappedId) { timingResult in
                                Button {
                                    viewModel.switchTimingResultTo(timingResult)
                                } label: {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 2) {
                                            if timingResult.unwrappedName == "" {
                                                Text("Untitled Stage")
                                                    .foregroundColor(.gray)
                                                    .lineLimit(1)
                                                    .padding(.top, 2)
                                            } else {
                                                Text(timingResult.unwrappedName)
                                                .padding(.top, 2)
                                                .foregroundColor(.black)
                                                .lineLimit(1)
                                            }
                                            Text("\(timingResult.resultArray.count) Recordings, Stage \(viewModel.resultsTypeLabel(resultsSet: timingResult))")
                                                .font(.caption)
                                                .padding(.bottom, 2)
                                                .foregroundColor(.black)
                                        }
                                        Spacer()
                                        if viewModel.warningCountIn(timingResult) != 0 {
                                            HStack {
                                                Text(String(viewModel.warningCountIn(timingResult)))
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
            .navigationBarTitle(Text("Menu"), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .alert("Are you sure you want to delete all recordings?", isPresented: $viewModel.presentingResetWarning, actions: {
                Button("No", role: .cancel, action: {})
                Button("Yes", role: .destructive, action: {
                    viewModel.deleteAll()
                    presentationMode.wrappedValue.dismiss()
                })
            }, message: {
                Text("This cannot be undone.")
            })
        }
    }
}
