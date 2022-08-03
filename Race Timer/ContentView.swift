//
//  ContentView.swift
//  Race Timer
//
//  Created by niko dittmar on 7/24/22.
//

import SwiftUI

struct Recording: Identifiable {
    var id = UUID()
    var plate: String
    var time: Date
}

struct ContentView: View {
    
    @ObservedObject var viewModel: ViewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Button {
                    let recording = Recording(plate: "", time: Date())
                    viewModel.recordings.insert(recording, at: 0)
                    viewModel.selectedRecording = recording.id
                    viewModel.recordings = viewModel.recordings.sorted(by: {(recording0: Recording, recording1: Recording) -> Bool in return recording0.time > recording1.time})
                } label: {
                    Text("Record Time")
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .font(.title3)
                        .foregroundColor(.white)
                        .background(.blue)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                Text("\(viewModel.recordings.count) Recording(s)")
                    .font(.footnote)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                
                List(viewModel.recordings) { recording in
                    Button {
                        viewModel.selectedRecording = recording.id
                    } label: {
                        if recording.plate == "" {
                            HStack {
                                Text("\(String(viewModel.recordings.firstIndex(where: {$0.id == recording.id}) ?? 0)).")
                                Text("-    -")
                                Spacer()
                                Text(viewModel.dateFormatter.string(from: recording.time))
                            }
                        } else {
                            HStack {
                                Text("\(String(viewModel.recordings.firstIndex(where: {$0.id == recording.id}) ?? 0)).")
                                Text(recording.plate)
                                Spacer()
                                Text(viewModel.dateFormatter.string(from: recording.time))
                            }
                        }
                        
                    }
                    .listRowBackground(recording.id == viewModel.selectedRecording ? Color.accentColor.opacity(0.3) : Color(UIColor.systemGray5))
                    
                }
                .listStyle(.inset)
                
                VStack(spacing: -1) {
                    HStack(spacing: -1) {
                        Button {
                            if viewModel.selectedRecording != nil {
                                viewModel.presentingDeleteWarning = true
                            }
                        } label: {
                            Text("Delete")
                                .font(.title3)
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity)
                                .frame(height: 40)
                                .border(Color(UIColor.systemGray5))
                        }
                        
                        Button {
                            if let selectedRecordingId = viewModel.selectedRecording {
                                for i in 0..<viewModel.recordings.count {
                                    if viewModel.recordings[i].id == selectedRecordingId {
                                        viewModel.recordings[i].time.addTimeInterval(-1)
                                        viewModel.recordings = viewModel.recordings.sorted(by: {(recording0: Recording, recording1: Recording) -> Bool in return recording0.time > recording1.time})
                                        break
                                    }
                                }
                            }
                        } label: {
                            Text("-1s")
                                .font(.title3)
                                .foregroundColor(Color(UIColor.label))
                                .frame(maxWidth: .infinity)
                                .frame(height: 40)
                                .border(Color(UIColor.systemGray5))
                        }
                        
                        Button {
                            if let selectedRecordingId = viewModel.selectedRecording {
                                for i in 0..<viewModel.recordings.count {
                                    if viewModel.recordings[i].id == selectedRecordingId {
                                        viewModel.recordings[i].time.addTimeInterval(1)
                                        viewModel.recordings = viewModel.recordings.sorted(by: {(recording0: Recording, recording1: Recording) -> Bool in return recording0.time > recording1.time})
                                        break
                                    }
                                }
                            }
                        } label: {
                            Text("+1s")
                                .font(.title3)
                                .foregroundColor(Color(UIColor.label))
                                .frame(maxWidth: .infinity)
                                .frame(height: 40)
                                .border(Color(UIColor.systemGray5))
                        }
                        
                    }
                    
                    
                    
                    HStack(spacing: -1) {
                        Button {
                            if let selectedRecordingId = viewModel.selectedRecording {
                                for i in 0..<viewModel.recordings.count {
                                    if viewModel.recordings[i].id == selectedRecordingId {
                                        viewModel.recordings[i].plate.append("1")
                                    }
                                }
                            }
                        } label: {
                            Text("1")
                                .font(.title)
                                .foregroundColor(Color(UIColor.label))
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .border(Color(UIColor.systemGray5))
                        }
                        
                        Button {
                            if let selectedRecordingId = viewModel.selectedRecording {
                                for i in 0..<viewModel.recordings.count {
                                    if viewModel.recordings[i].id == selectedRecordingId {
                                        viewModel.recordings[i].plate.append("2")
                                    }
                                }
                            }
                        } label: {
                            Text("2")
                                .font(.title)
                                .foregroundColor(Color(UIColor.label))
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .border(Color(UIColor.systemGray5))
                        }
                        
                        Button {
                            if let selectedRecordingId = viewModel.selectedRecording {
                                for i in 0..<viewModel.recordings.count {
                                    if viewModel.recordings[i].id == selectedRecordingId {
                                        viewModel.recordings[i].plate.append("3")
                                    }
                                }
                            }
                        } label: {
                            Text("3")
                                .font(.title)
                                .foregroundColor(Color(UIColor.label))
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .border(Color(UIColor.systemGray5))
                        }
                        
                    }
                    
                    HStack(spacing: -1) {
                        Button {
                            if let selectedRecordingId = viewModel.selectedRecording {
                                for i in 0..<viewModel.recordings.count {
                                    if viewModel.recordings[i].id == selectedRecordingId {
                                        viewModel.recordings[i].plate.append("4")
                                    }
                                }
                            }
                        } label: {
                            Text("4")
                                .font(.title)
                                .foregroundColor(Color(UIColor.label))
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .border(Color(UIColor.systemGray5))
                        }
                        
                        Button {
                            if let selectedRecordingId = viewModel.selectedRecording {
                                for i in 0..<viewModel.recordings.count {
                                    if viewModel.recordings[i].id == selectedRecordingId {
                                        viewModel.recordings[i].plate.append("5")
                                    }
                                }
                            }
                        } label: {
                            Text("5")
                                .font(.title)
                                .foregroundColor(Color(UIColor.label))
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .border(Color(UIColor.systemGray5))
                        }
                        
                        Button {
                            if let selectedRecordingId = viewModel.selectedRecording {
                                for i in 0..<viewModel.recordings.count {
                                    if viewModel.recordings[i].id == selectedRecordingId {
                                        viewModel.recordings[i].plate.append("6")
                                    }
                                }
                            }
                        } label: {
                            Text("6")
                                .font(.title)
                                .foregroundColor(Color(UIColor.label))
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .border(Color(UIColor.systemGray5))
                        }
                        
                    }
                    
                    HStack(spacing: -1) {
                        Button {
                            if let selectedRecordingId = viewModel.selectedRecording {
                                for i in 0..<viewModel.recordings.count {
                                    if viewModel.recordings[i].id == selectedRecordingId {
                                        viewModel.recordings[i].plate.append("7")
                                    }
                                }
                            }
                        } label: {
                            Text("7")
                                .font(.title)
                                .foregroundColor(Color(UIColor.label))
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .border(Color(UIColor.systemGray5))
                        }
                        
                        Button {
                            if let selectedRecordingId = viewModel.selectedRecording {
                                for i in 0..<viewModel.recordings.count {
                                    if viewModel.recordings[i].id == selectedRecordingId {
                                        viewModel.recordings[i].plate.append("8")
                                    }
                                }
                            }
                        } label: {
                            Text("8")
                                .font(.title)
                                .foregroundColor(Color(UIColor.label))
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .border(Color(UIColor.systemGray5))
                        }
                        
                        Button {
                            if let selectedRecordingId = viewModel.selectedRecording {
                                for i in 0..<viewModel.recordings.count {
                                    if viewModel.recordings[i].id == selectedRecordingId {
                                        viewModel.recordings[i].plate.append("9")
                                    }
                                }
                            }
                        } label: {
                            Text("9")
                                .font(.title)
                                .foregroundColor(Color(UIColor.label))
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .border(Color(UIColor.systemGray5))
                        }
                        
                    }
                    
                    HStack(spacing: -1) {
                        Button {
                            if let selectedRecordingId = viewModel.selectedRecording {
                                for i in 0..<viewModel.recordings.count {
                                    if viewModel.recordings[i].id == selectedRecordingId {
                                        if !viewModel.recordings[i].plate.isEmpty {
                                            viewModel.recordings[i].plate.removeLast()
                                        }
                                    }
                                }
                            }
                        } label: {
                            Image(systemName: "delete.left")
                                .font(.title)
                                .foregroundColor(Color(UIColor.label))
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .border(Color(UIColor.systemGray5))
                        }
                        
                        Button {
                            if let selectedRecordingId = viewModel.selectedRecording {
                                for i in 0..<viewModel.recordings.count {
                                    if viewModel.recordings[i].id == selectedRecordingId {
                                        viewModel.recordings[i].plate.append("0")
                                    }
                                }
                            }
                        } label: {
                            Text("0")
                                .font(.title)
                                .foregroundColor(Color(UIColor.label))
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .border(Color(UIColor.systemGray5))
                        }
                        
                        Button {
                            viewModel.selectedRecording = nil
                        } label: {
                            Image(systemName: "arrow.turn.down.left")
                                .font(.title)
                                .foregroundColor(Color(UIColor.label))
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .border(Color(UIColor.systemGray5))
                        }
                        
                    }
                }
            }
            .navigationTitle("JMP Enduro Timer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        viewModel.presentingResetWarning = true
                    } label: {
                        Text("Reset")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        var missingPlateNumbers = false
                        for recording in viewModel.recordings {
                            if recording.plate == "" {
                                missingPlateNumbers = true
                                viewModel.presentingMissingPlateWarning = true
                                break
                            }
                        }
                        if missingPlateNumbers == false {
                            viewModel.presentingExportSheet = true
                        }
                    } label: {
                        Text("Finish")
                            .fontWeight(.bold)
                    }
                    .disabled(viewModel.recordings.isEmpty)
                }
            }
            .alert("Are you sure you want to delete the selected recording?", isPresented: $viewModel.presentingDeleteWarning, actions: {
                Button("No", role: .cancel, action: {})
                Button("Yes", role: .destructive, action: {
                    viewModel.recordings = viewModel.recordings.filter {$0.id != viewModel.selectedRecording}
                    viewModel.selectedRecording = nil
                })
            }, message: {
                Text("This cannot be undone.")
            })
            .alert("Are you sure you want to delete all recordings?", isPresented: $viewModel.presentingResetWarning, actions: {
                Button("No", role: .cancel, action: {})
                Button("Yes", role: .destructive, action: {
                    viewModel.recordings = []
                })
            }, message: {
                Text("This cannot be undone.")
            })
            .alert("Some recordings are missing plate numbers.", isPresented: $viewModel.presentingMissingPlateWarning, actions: {
                Button("Cancel", action: {})
                Button("Continue", action: {
                    viewModel.presentingExportSheet = true
                })
            }, message: {
                Text("Would you like to continue?")
            })
            .sheet(isPresented: $viewModel.presentingExportSheet) {
                ExportRecordingsSheet(recordings: viewModel.recordings)
            }

        }
    }
}

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        @Published var recordings: [Recording]
        
        @Published var selectedRecording: UUID?
        
        @Published var presentingDeleteWarning: Bool = false
        @Published var presentingResetWarning: Bool = false
        @Published var presentingMissingPlateWarning: Bool = false
        
        @Published var presentingExportSheet: Bool = false
        
        let dateFormatter: DateFormatter
        
        
        init() {
            self.recordings = []
            self.dateFormatter = DateFormatter()
            self.dateFormatter.dateFormat = "H:mm:ss.SSSS"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
