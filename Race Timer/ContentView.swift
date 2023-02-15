//
//  ContentView.swift
//  Race Timer
//
//  Created by niko dittmar on 7/24/22.
//

import SwiftUI

struct ContentView: View {
    
    let coreDM: DataController
    
    @StateObject var viewModel: ContentViewViewModel = ContentViewViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Button {
                    viewModel.recordTime()
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
                
                Text(viewModel.results.count == 1 ? "\(viewModel.results.count) Recording" : "\(viewModel.results.count) Recordings")
                    .frame(maxWidth: .infinity)
                    .font(.footnote)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .border(Color(UIColor.systemGray4))
                    .background(Color(UIColor.systemGray6))
                
                ResultsList(viewModel: viewModel)
                
                if viewModel.timingMode == .start {
                    UpcomingPlateEntry(viewModel: viewModel)
                }
                
                NumberPad(viewModel: viewModel)
            }
            .navigationTitle("MyRaceTimer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        viewModel.presentingMenuSheet = true
                    } label: {
                        Text("Menu")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if viewModel.plateList.count < viewModel.results.count && viewModel.plateList.hasDuplicates() {
                            viewModel.presentingDuplicateAndMissingPlateWarning = true
                        } else if viewModel.plateList.hasDuplicates() {
                            viewModel.presentingDuplicatePlateWarning = true
                        } else if viewModel.plateList.count < viewModel.results.count {
                            viewModel.presentingMissingPlateWarning = true
                        } else {
                            viewModel.presentingExportSheet = true
                        }
                    } label: {
                        Text("Finish")
                            .fontWeight(.bold)
                    }
                    .disabled(viewModel.results.isEmpty)
                }
            }
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
                ExportRecordingsSheet(viewModel: viewModel)
            }
            .sheet(isPresented: $viewModel.presentingMenuSheet) {
                MenuSheet(viewModel: viewModel)
            }
            .ignoresSafeArea(.keyboard)
        }
    }
}

enum TimingMode {
    case start
    case finish
}

@MainActor class ContentViewViewModel: ObservableObject {
    let coreDM: DataController = DataController()
    
    @Published var timingResultSet: TimingResult
    
    @Published var results: [Result]
    @Published var plateList: [String]
    
    @Published var selectedResult: Result?
    
    @Published var presentingDeleteWarning: Bool = false
    @Published var presentingMissingPlateWarning: Bool = false
    @Published var presentingDuplicatePlateWarning: Bool = false
    @Published var presentingDuplicateAndMissingPlateWarning: Bool = false

    @Published var presentingMenuSheet: Bool = false
    @Published var presentingExportSheet: Bool = false
    
    @Published var presentingResetWarning: Bool = false
    @Published var timingMode: TimingMode = .start
    
    @Published var upcomingPlateEntrySelected: Bool = false
    @Published var upcomingPlate: String = ""
    
    @Published var stageName: String = ""
    @Published var recordingsType: TimingMode = .start
    
    
    init() {
        
        let activeTimingResult: TimingResult? = coreDM.getActiveTimingResult()
        if activeTimingResult != nil {
            print("Active Results Set Found.")
            self.timingResultSet = activeTimingResult!
            self.results = coreDM.getResultsFrom(activeTimingResult!)
            self.plateList = coreDM.getAllPlatesFrom(activeTimingResult!)
        } else {
            print("No Active Results Set Found, Creating New Result Set!")
            coreDM.createTimingResult(mode: .start)
            let newActiveTimingResult: TimingResult? = coreDM.getActiveTimingResult()
            self.timingResultSet = newActiveTimingResult!
            self.results = []
            self.plateList = []
        }
    }
    
    func syncResults() {
        results = coreDM.getResultsFrom(timingResultSet)
        plateList = coreDM.getAllPlatesFrom(timingResultSet)
    }
    
    func recordTime() {
        coreDM.saveResultTo(timingResultSet, plate: upcomingPlate)
        syncResults()
        upcomingPlateEntrySelected = false
        upcomingPlate = ""
        selectedResult = results[0]
    }
    
    //Functions for Number Pad
    
    func appendDigit(_ digit: Int) {
        if selectedResult != nil {
            coreDM.appendPlateDigit(result: selectedResult!, digit: digit)
            syncResults()
        } else if upcomingPlateEntrySelected == true {
            if upcomingPlate.count < 5 {
                upcomingPlate.append(String(digit))
            }
        }
    }
    func backspace() {
        if selectedResult != nil {
            coreDM.removePlateDigit(result: selectedResult!)
            syncResults()
        } else if upcomingPlateEntrySelected == true {
            if upcomingPlate.count > 0 {
                upcomingPlate.removeLast()
            }
        }
    }
    func presentDeleteWarning() {
        if selectedResult != nil {
            presentingDeleteWarning = true
        }
    }
    func deleteResult() {
        if selectedResult != nil {
            coreDM.delete(selectedResult!)
            selectedResult = nil
            syncResults()
        }
    }
    
    //Functions for Results List
    
    func resultListItemNumber(_ result: Result) -> String {
        return String(results.firstIndex(where: {$0.id == result.id}) ?? 0)
    }
    
    func resultsListItemLabel(_ result: Result) -> String {
        var label = result.unwrappedPlate
        if label == "" {
            label = "-       -"
        }
        return label
    }
    
    func hasDuplicatePlate(_ result: Result) -> Bool {
        if result.unwrappedPlate.occurrencesIn(plateList) > 1 {
            return true
        } else if upcomingPlate != "" && result.unwrappedPlate == upcomingPlate  {
            return true
        } else {
            return false
        }
    }
    
    func toggleSelectedResult(_ result: Result) {
        if selectedResult == result {
            selectedResult = nil
        } else {
            upcomingPlateEntrySelected = false
            selectedResult = result
        }
    }
    
    func resultIsSelected(_ result: Result) -> Bool {
        return selectedResult?.id == result.unwrappedId
    }
    
    func deleteAll() {
        coreDM.deleteAll()
        syncResults()
        selectedResult = nil
    }
    
    func selectUpcomingPlateEntry() {
        if upcomingPlateEntrySelected == true {
            upcomingPlateEntrySelected = false
        } else {
            selectedResult = nil
            upcomingPlateEntrySelected = true
        }
    }
    
    func upcomingPlateIsDuplicate() -> Bool {
        if upcomingPlate.occurrencesIn(plateList) >= 1 {
            return true
        } else {
            return false
        }
    }
    
    func upcomingPlateLabel() -> String {
        var label: String = upcomingPlate
        if label == "" {
            label = "-               -"
        }
        return label
    }
    
    func resetNextPlateEntryField() {
        upcomingPlate = ""
        recordingsType = timingMode
    }
    
    func updateTimingResultDetails() {
        coreDM.setTimingResultName(timingResultSet, name: stageName)
        coreDM.setTimingResultType(timingResultSet, timingMode: recordingsType)
    }
    
    func allTimingResults() -> [TimingResult] {
        return coreDM.getAllTimingResults()
    }
    
    func switchTimingResultTo(_ timingResult: TimingResult) {
        coreDM.activateTimingResult(timingResult)
        timingResultSet = timingResult
        syncResults()
    }
    
    func newRecordingSet() {
        coreDM.createTimingResult(mode: timingMode)
        recordingsType = timingMode
        syncResults()
    }
}
