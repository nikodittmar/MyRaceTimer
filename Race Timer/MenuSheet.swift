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
                    Section(header: Text("Interface Setting")) {
                        Picker("Interface", selection: $viewModel.timingMode) {
                            Text("Stage Start")
                                .tag(TimingMode.start)
                            Text("Stage Finish")
                                .tag(TimingMode.finish)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .onChange(of: viewModel.timingMode, perform: { (value) in
                            viewModel.resetNextPlateEntryField()
                        })
                    }
                    Button("New Recordings Set", role: .destructive) {
                        viewModel.newRecordingSet()
                    }
                    List(viewModel.allTimingResults(), id: \.unwrappedId) { timingResult in
                        Button {
                            viewModel.switchTimingResultTo(timingResult)
                        } label: {
                            Text("\(timingResult.unwrappedName), \(timingResult.updatedTimeString), \(timingResult.resultArray.count)")
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
