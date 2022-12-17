//
//  ContentView.swift
//  Race Timer
//
//  Created by niko dittmar on 7/24/22.
//

import SwiftUI

enum DefaultSettings {
    static let nextPlateEntryScreen = false
}

struct ContentView: View {
    
    let coreDM: DataController
    
    @ObservedObject var viewModel: ViewModel = ViewModel()
    
    @AppStorage("showNextPlateEntry") var nextPlateEntry: Bool = DefaultSettings.nextPlateEntryScreen
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Button {
                    coreDM.saveResult(viewModel.nextRecordingPlate ?? "")
                    viewModel.nextRecordingPlate = nil
                    viewModel.plateFieldSelected = false
                    viewModel.results = coreDM.getAllResults()
                    viewModel.plateList = coreDM.getAllPlates()
                    viewModel.selectedResult = viewModel.results[0]
                    viewModel.startTimer()
                } label: {
                    Text("Record Time")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .font(.title3)
                        .foregroundColor(.white)
                        .background(.blue)
                        .border(Color(UIColor.systemGray5))
                }
                .padding(.top, 8)
                .padding(.bottom, -1)
                HStack {
                    //Text("Since Last: \(String(viewModel.timeSinceLastRecording))s")
                    Text("Since Last: 15s")
                    
                    Spacer()
                    if viewModel.results.count == 1 {
                        Text("\(viewModel.results.count) Recording")
                    } else {
                        Text("\(viewModel.results.count) Recordings")
                    }
                }
                .frame(maxWidth: .infinity)
                .font(.footnote)
                .padding(.horizontal)
                .padding(.vertical, 8)
                .border(Color(UIColor.systemGray4))
                .background(Color(UIColor.systemGray6))
                
                ZStack {
                    List(viewModel.results, id: \.unwrappedId) { result in
                        Button {
                            if viewModel.selectedResult == result {
                                viewModel.selectedResult = nil
                            } else {
                                viewModel.selectedResult = result
                                viewModel.plateFieldSelected = false
                            }
                        } label: {
                            HStack {
                                Text("\(String(viewModel.results.firstIndex(where: {$0.id == result.id}) ?? 0)).")
                                    .frame(width: 40, height: 20, alignment: .leading)
                                    .padding(6)
                                    
                                if result.unwrappedPlate == "" {
                                    Text("-       -")
                                        .frame(width: 80, height: 20)
                                        .padding(6)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color(UIColor.systemGray2), lineWidth: 0.5)
                                        )
                                        .background(Color(UIColor.systemGray6))
                                        .cornerRadius(8)
                                } else {
                                    Text("\(result.unwrappedPlate)")
                                        .frame(width: 80, height: 20)
                                        .padding(6)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color(UIColor.systemGray2), lineWidth: 0.5)
                                        )
                                        .background(Color(UIColor.systemGray6))
                                        .cornerRadius(8)
                                }
                                if result.unwrappedPlate.occurrencesIn(viewModel.plateList) > 1 {
                                    Image(systemName: "square.on.square")
                                        .foregroundColor(.yellow)
                                }
                                Spacer()
                                Text("\(result.timeString)")
                            }
                        }
                        .listRowBackground(viewModel.selectedResult?.id == result.unwrappedId ? Color.accentColor.opacity(0.2) : .clear)
                    }
                    .listStyle(.inset)
                    
                    if viewModel.results.isEmpty {
                        Text("No recordings to display\nTap \"Record Time\" to create a recording")
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(UIColor.systemGray2))
                    }
                }
                VStack(spacing: -1) {
                    if nextPlateEntry == true {
                        Button {
                            if viewModel.plateFieldSelected == true {
                                viewModel.plateFieldSelected = false
                            } else {
                                viewModel.selectedResult = nil
                                viewModel.plateFieldSelected = true
                            }
                            
                        } label: {
                            ZStack {
                                HStack {
                                    Text("Next:")
                                        .padding(.leading)
                                        .foregroundColor(Color(UIColor.label))
                                        .font(.title3)
                                    
                                    Spacer()


                                    if (viewModel.nextRecordingPlate ?? "").occurrencesIn(viewModel.plateList) > 1 {
                                        Image(systemName: "square.on.square")
                                            .foregroundColor(.yellow)
                                            .padding(.trailing)
                                            
                                    }

                                }
                                Text(viewModel.nextRecordingPlate ?? "-       -")
                                    .frame(width: 160, height: 30)
                                    .padding(6)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color(UIColor.systemGray2), lineWidth: 0.5)
                                    )
                                    .background(Color(UIColor.systemBackground))
                                    .cornerRadius(8)
                                    .foregroundColor(Color(UIColor.label))
                                    .font(.title3)

                            }
                            .frame(maxWidth: .infinity)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .border(Color(UIColor.systemGray4))
                            .background(viewModel.plateFieldSelected ? Color.accentColor.opacity(0.2) : Color(UIColor.systemGray6))


                        }
                            
                    }
                    
                    HStack(spacing: -1) {
                        Button {
                            if viewModel.selectedResult != nil {
                                coreDM.appendPlateDigit(result: viewModel.selectedResult!, digit: 1)
                                viewModel.results = coreDM.getAllResults()
                                viewModel.plateList = coreDM.getAllPlates()
                                if viewModel.nextRecordingPlate != nil {
                                    viewModel.plateList.append(viewModel.nextRecordingPlate!)
                                }
                            } else if viewModel.plateFieldSelected == true {
                                var plate = viewModel.nextRecordingPlate ?? ""
                                if plate.count < 6 {
                                    plate.append("1")
                                }
                                viewModel.nextRecordingPlate = plate
                                viewModel.plateList = coreDM.getAllPlates()
                                viewModel.plateList.append(plate)
                            }
                        } label: {
                            Text("1")
                                .font(.title)
                                .foregroundColor(Color(UIColor.label))
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .border(Color(UIColor.systemGray4))
                                .background(Color(UIColor.systemGray6))
                        }

                        Button {
                            if viewModel.selectedResult != nil {
                                coreDM.appendPlateDigit(result: viewModel.selectedResult!, digit: 2)
                                viewModel.results = coreDM.getAllResults()
                                viewModel.plateList = coreDM.getAllPlates()
                                if viewModel.nextRecordingPlate != nil {
                                    viewModel.plateList.append(viewModel.nextRecordingPlate!)
                                }
                            } else if viewModel.plateFieldSelected == true {
                                var plate = viewModel.nextRecordingPlate ?? ""
                                if plate.count < 6 {
                                    plate.append("2")
                                }
                                viewModel.nextRecordingPlate = plate
                                viewModel.plateList = coreDM.getAllPlates()
                                viewModel.plateList.append(plate)
                            }
                        } label: {
                            Text("2")
                                .font(.title)
                                .foregroundColor(Color(UIColor.label))
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .border(Color(UIColor.systemGray4))
                                .background(Color(UIColor.systemGray6))
                        }

                        Button {
                            if viewModel.selectedResult != nil {
                                coreDM.appendPlateDigit(result: viewModel.selectedResult!, digit: 3)
                                viewModel.results = coreDM.getAllResults()
                                viewModel.plateList = coreDM.getAllPlates()
                                if viewModel.nextRecordingPlate != nil {
                                    viewModel.plateList.append(viewModel.nextRecordingPlate!)
                                }
                            } else if viewModel.plateFieldSelected == true {
                                var plate = viewModel.nextRecordingPlate ?? ""
                                if plate.count < 6 {
                                    plate.append("3")
                                }
                                viewModel.nextRecordingPlate = plate
                                viewModel.plateList = coreDM.getAllPlates()
                                viewModel.plateList.append(plate)
                            }
                        } label: {
                            Text("3")
                                .font(.title)
                                .foregroundColor(Color(UIColor.label))
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .border(Color(UIColor.systemGray4))
                                .background(Color(UIColor.systemGray6))
                        }

                    }

                    HStack(spacing: -1) {
                        Button {
                            if viewModel.selectedResult != nil {
                                coreDM.appendPlateDigit(result: viewModel.selectedResult!, digit: 4)
                                viewModel.results = coreDM.getAllResults()
                                viewModel.plateList = coreDM.getAllPlates()
                                if viewModel.nextRecordingPlate != nil {
                                    viewModel.plateList.append(viewModel.nextRecordingPlate!)
                                }
                            } else if viewModel.plateFieldSelected == true {
                                var plate = viewModel.nextRecordingPlate ?? ""
                                if plate.count < 6 {
                                    plate.append("4")
                                }
                                viewModel.nextRecordingPlate = plate
                                viewModel.plateList = coreDM.getAllPlates()
                                viewModel.plateList.append(plate)
                            }
                        } label: {
                            Text("4")
                                .font(.title)
                                .foregroundColor(Color(UIColor.label))
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .border(Color(UIColor.systemGray4))
                                .background(Color(UIColor.systemGray6))
                        }

                        Button {
                            if viewModel.selectedResult != nil {
                                coreDM.appendPlateDigit(result: viewModel.selectedResult!, digit: 5)
                                viewModel.results = coreDM.getAllResults()
                                viewModel.plateList = coreDM.getAllPlates()
                                if viewModel.nextRecordingPlate != nil {
                                    viewModel.plateList.append(viewModel.nextRecordingPlate!)
                                }
                            } else if viewModel.plateFieldSelected == true {
                                var plate = viewModel.nextRecordingPlate ?? ""
                                if plate.count < 6 {
                                    plate.append("5")
                                }
                                viewModel.nextRecordingPlate = plate
                                viewModel.plateList = coreDM.getAllPlates()
                                viewModel.plateList.append(plate)
                            }
                        } label: {
                            Text("5")
                                .font(.title)
                                .foregroundColor(Color(UIColor.label))
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .border(Color(UIColor.systemGray4))
                                .background(Color(UIColor.systemGray6))
                        }

                        Button {
                            if viewModel.selectedResult != nil {
                                coreDM.appendPlateDigit(result: viewModel.selectedResult!, digit: 6)
                                viewModel.results = coreDM.getAllResults()
                                viewModel.plateList = coreDM.getAllPlates()
                                if viewModel.nextRecordingPlate != nil {
                                    viewModel.plateList.append(viewModel.nextRecordingPlate!)
                                }
                            } else if viewModel.plateFieldSelected == true {
                                var plate = viewModel.nextRecordingPlate ?? ""
                                if plate.count < 6 {
                                    plate.append("6")
                                }
                                viewModel.nextRecordingPlate = plate
                                viewModel.plateList = coreDM.getAllPlates()
                                viewModel.plateList.append(plate)
                            }
                        } label: {
                            Text("6")
                                .font(.title)
                                .foregroundColor(Color(UIColor.label))
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .border(Color(UIColor.systemGray4))
                                .background(Color(UIColor.systemGray6))
                        }

                    }

                    HStack(spacing: -1) {
                        Button {
                            if viewModel.selectedResult != nil {
                                coreDM.appendPlateDigit(result: viewModel.selectedResult!, digit: 7)
                                viewModel.results = coreDM.getAllResults()
                                viewModel.plateList = coreDM.getAllPlates()
                                if viewModel.nextRecordingPlate != nil {
                                    viewModel.plateList.append(viewModel.nextRecordingPlate!)
                                }
                            } else if viewModel.plateFieldSelected == true {
                                var plate = viewModel.nextRecordingPlate ?? ""
                                if plate.count < 6 {
                                    plate.append("7")
                                }
                                viewModel.nextRecordingPlate = plate
                                viewModel.plateList = coreDM.getAllPlates()
                                viewModel.plateList.append(plate)
                            }
                        } label: {
                            Text("7")
                                .font(.title)
                                .foregroundColor(Color(UIColor.label))
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .border(Color(UIColor.systemGray4))
                                .background(Color(UIColor.systemGray6))
                        }

                        Button {
                            if viewModel.selectedResult != nil {
                                coreDM.appendPlateDigit(result: viewModel.selectedResult!, digit: 8)
                                viewModel.results = coreDM.getAllResults()
                                viewModel.plateList = coreDM.getAllPlates()
                                if viewModel.nextRecordingPlate != nil {
                                    viewModel.plateList.append(viewModel.nextRecordingPlate!)
                                }
                            } else if viewModel.plateFieldSelected == true {
                                var plate = viewModel.nextRecordingPlate ?? ""
                                if plate.count < 6 {
                                    plate.append("8")
                                }
                                viewModel.nextRecordingPlate = plate
                                viewModel.plateList = coreDM.getAllPlates()
                                viewModel.plateList.append(plate)
                            }
                        } label: {
                            Text("8")
                                .font(.title)
                                .foregroundColor(Color(UIColor.label))
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .border(Color(UIColor.systemGray4))
                                .background(Color(UIColor.systemGray6))
                        }

                        Button {
                            if viewModel.selectedResult != nil {
                                coreDM.appendPlateDigit(result: viewModel.selectedResult!, digit: 9)
                                viewModel.results = coreDM.getAllResults()
                                viewModel.plateList = coreDM.getAllPlates()
                                if viewModel.nextRecordingPlate != nil {
                                    viewModel.plateList.append(viewModel.nextRecordingPlate!)
                                }
                            } else if viewModel.plateFieldSelected == true {
                                var plate = viewModel.nextRecordingPlate ?? ""
                                if plate.count < 6 {
                                    plate.append("9")
                                }
                                viewModel.nextRecordingPlate = plate
                                viewModel.plateList = coreDM.getAllPlates()
                                viewModel.plateList.append(plate)
                            }
                        } label: {
                            Text("9")
                                .font(.title)
                                .foregroundColor(Color(UIColor.label))
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .border(Color(UIColor.systemGray4))
                                .background(Color(UIColor.systemGray6))
                        }

                    }

                    HStack(spacing: -1) {
                        Button {
                            if viewModel.selectedResult != nil {
                                viewModel.presentingDeleteWarning = true
                            }
                        } label: {
                            Image(systemName: "trash")
                                .font(.title)
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .border(Color(UIColor.systemGray4))
                                .background(Color(UIColor.systemGray6))
                        }

                        Button {
                            if viewModel.selectedResult != nil {
                                coreDM.appendPlateDigit(result: viewModel.selectedResult!, digit: 0)
                                viewModel.results = coreDM.getAllResults()
                                viewModel.plateList = coreDM.getAllPlates()
                                if viewModel.nextRecordingPlate != nil {
                                    viewModel.plateList.append(viewModel.nextRecordingPlate!)
                                }
                            } else if viewModel.plateFieldSelected == true {
                                var plate = viewModel.nextRecordingPlate ?? ""
                                if plate.count < 6 {
                                    plate.append("0")
                                }
                                viewModel.nextRecordingPlate = plate
                                viewModel.plateList = coreDM.getAllPlates()
                                viewModel.plateList.append(plate)
                            }
                        } label: {
                            Text("0")
                                .font(.title)
                                .foregroundColor(Color(UIColor.label))
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .border(Color(UIColor.systemGray4))
                                .background(Color(UIColor.systemGray6))
                        }
                        
                        Button {
                            if viewModel.selectedResult != nil {
                                coreDM.removePlateDigit(result: viewModel.selectedResult!)
                                viewModel.results = coreDM.getAllResults()
                                viewModel.plateList = coreDM.getAllPlates()
                                if viewModel.nextRecordingPlate != nil {
                                    viewModel.plateList.append(viewModel.nextRecordingPlate!)
                                }
                            } else if viewModel.plateFieldSelected == true {
                                var plate = viewModel.nextRecordingPlate ?? ""
                                if plate != "" {
                                    plate.removeLast()
                                }
                                if plate == "" {
                                    viewModel.nextRecordingPlate = nil
                                    viewModel.plateList = coreDM.getAllPlates()
                                } else {
                                    viewModel.nextRecordingPlate = plate
                                    viewModel.plateList = coreDM.getAllPlates()
                                    viewModel.plateList.append(plate)
                                }
                                
                            }
                        } label: {
                            Image(systemName: "delete.left")
                                .font(.title)
                                .foregroundColor(Color(UIColor.label))
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .border(Color(UIColor.systemGray4))
                                .background(Color(UIColor.systemGray6))
                        }
                    }
                }
            }
            .navigationTitle("MyRaceTimer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        viewModel.presentingSettingsSheet = true
                    } label: {
                        Text("Settings")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if viewModel.plateList.count < viewModel.results.count && viewModel.plateList.hasDuplicates() {
                            viewModel.presentingDuplicateAndMissingPlateWarning = true
                            viewModel.exportWarning = .both
                        } else if viewModel.plateList.hasDuplicates() {
                            viewModel.presentingDuplicatePlateWarning = true
                            viewModel.exportWarning = .duplicatePlates
                        } else if viewModel.plateList.count < viewModel.results.count {
                            viewModel.presentingMissingPlateWarning = true
                            viewModel.exportWarning = .missingPlates
                        } else {
                            viewModel.presentingExportSheet = true
                            viewModel.exportWarning = .none
                        }
                    } label: {
                        Text("Export")
                            .fontWeight(.bold)
                    }
                    .disabled(viewModel.results.isEmpty)
                }
            }
            .alert("Are you sure you want to delete the selected recording?", isPresented: $viewModel.presentingDeleteWarning, actions: {
                Button("No", role: .cancel, action: {})
                Button("Yes", role: .destructive, action: {
                    if viewModel.selectedResult != nil {
                        coreDM.delete(viewModel.selectedResult!)
                        viewModel.results = coreDM.getAllResults()
                        viewModel.plateList = coreDM.getAllPlates()
                        viewModel.selectedResult = nil
                    }
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
            .alert("Some recordings have duplicate plate numbers.", isPresented: $viewModel.presentingDuplicatePlateWarning, actions: {
                Button("Cancel", action: {})
                Button("Continue", action: {
                    viewModel.presentingExportSheet = true
                })
            }, message: {
                Text("Would you like to continue?")
            })
            .alert("Some recordings have duplicate or missing plate numbers.", isPresented: $viewModel.presentingDuplicateAndMissingPlateWarning, actions: {
                Button("Cancel", action: {})
                Button("Continue", action: {
                    viewModel.presentingExportSheet = true
                })
            }, message: {
                Text("Would you like to continue?")
            })
            .sheet(isPresented: $viewModel.presentingExportSheet) {
                ExportRecordingsSheet(warnings: viewModel.exportWarning)
            }
            .sheet(isPresented: $viewModel.presentingSettingsSheet) {
                SettingsSheet(resetAction: {
                    coreDM.deleteAll()
                    viewModel.results = coreDM.getAllResults()
                    viewModel.plateList = coreDM.getAllPlates()
                    viewModel.selectedResult = nil
                }, nextPlate: $viewModel.nextRecordingPlate,
                              plateList: $viewModel.plateList)
            }
            .ignoresSafeArea(.keyboard)
        }
    }
}

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        let coreDM: DataController = DataController()
        
        @Published var results: [Result]
        @Published var plateList: [String]
        
        @Published var selectedResult: Result?
        
        @Published var presentingDeleteWarning: Bool = false
        @Published var presentingMissingPlateWarning: Bool = false
        @Published var presentingDuplicatePlateWarning: Bool = false
        @Published var presentingDuplicateAndMissingPlateWarning: Bool = false

        @Published var presentingSettingsSheet: Bool = false
        @Published var presentingExportSheet: Bool = false
        
        @Published var nextRecordingPlate: String?
        @Published var plateFieldSelected: Bool = false
        
        @Published var timeSinceLastRecording: Int = 0
        
        @Published var exportWarning: exportWarnings = .none
        
        var timer = Timer()
        
        init() {
            self.results = coreDM.getAllResults()
            self.plateList = coreDM.getAllPlates()
        }
        
        func startTimer() {
            self.timeSinceLastRecording = 0 
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(coreDM: DataController())
    }
}
