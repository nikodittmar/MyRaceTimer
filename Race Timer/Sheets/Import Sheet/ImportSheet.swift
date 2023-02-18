//
//  ImportSheet.swift
//  Race Timer
//
//  Created by niko dittmar on 2/17/23.
//

import SwiftUI

struct ImportSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ContentViewViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Stage Name")) {
                        Text(viewModel.importStageName())
                    }
                    Section(header: Text("Stage Result Type")) {
                        Text(viewModel.importStageResultType())
                    }
                    Section(header: Text("Warnings")) {
                        if viewModel.overallDuplicateWarning() {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.yellow)
                                Text("Duplicate Race Plate Numbers")
                                    .foregroundColor(.black)
                            }
                        }
                        if viewModel.overallMissingWarning() {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.yellow)
                                Text("Missing Race Plate Numbers")
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    Section(header: Text("Stage Result Recordings")) {
                        List(viewModel.importStageRecordingsList(), id: \.id) { recording in
                            HStack {
                                Text(viewModel.importRecordingPlateString(recording))
                                    .frame(width: 80, height: 20)
                                    .padding(6)
                                    .overlay(RoundedRectangle(cornerRadius: 8) .stroke(Color(UIColor.systemGray2), lineWidth: 0.5))
                                    .background(Color(UIColor.systemGray6))
                                    .cornerRadius(8)
                                    .padding(.leading, 10)
                                if viewModel.importRecordingHasDuplicatePlate(recording.plate) {
                                    Image(systemName: "square.on.square")
                                        .foregroundColor(.yellow)
                                }
                                Spacer()
                                Text(viewModel.importRecordingTimeString(double: recording.timestamp))
                            }
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Import Stage Results"), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.addStageResultToCoreData()
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Import")
                            .fontWeight(.bold)
                    }
                }
            }
        }
    }
}
//
