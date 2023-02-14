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
                
                if viewModel.results.count == 1 {
                    Text("\(viewModel.results.count) Recording")
                        .frame(maxWidth: .infinity)
                        .font(.footnote)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .border(Color(UIColor.systemGray4))
                        .background(Color(UIColor.systemGray6))
                        
                } else {
                    Text("\(viewModel.results.count) Recordings")
                        .frame(maxWidth: .infinity)
                        .font(.footnote)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .border(Color(UIColor.systemGray4))
                        .background(Color(UIColor.systemGray6))
                }
                ResultsList(viewModel: viewModel)
                NumberPad(viewModel: viewModel)
            }
            .navigationTitle("MyRaceTimer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        viewModel.presentingResetSheet = true
                    } label: {
                        Text("Reset")
                    }
                    .disabled(viewModel.results.isEmpty)
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
                ExportRecordingsSheet()
            }
            .sheet(isPresented: $viewModel.presentingResetSheet) {
                MenuSheet(resetAction: {
                    coreDM.deleteAll()
                    viewModel.results = coreDM.getAllResults()
                    viewModel.plateList = coreDM.getAllPlates()
                    viewModel.selectedResult = nil
                })
            }
            .ignoresSafeArea(.keyboard)
        }
    }
}

class ContentViewViewModel: ObservableObject {
    let coreDM: DataController = DataController()
    
    @Published var results: [Result]
    @Published var plateList: [String]
    
    @Published var selectedResult: Result?
    
    @Published var presentingDeleteWarning: Bool = false
    @Published var presentingMissingPlateWarning: Bool = false
    @Published var presentingDuplicatePlateWarning: Bool = false
    @Published var presentingDuplicateAndMissingPlateWarning: Bool = false

    @Published var presentingResetSheet: Bool = false
    @Published var presentingExportSheet: Bool = false
    
    
    init() {
        self.results = coreDM.getAllResults()
        self.plateList = coreDM.getAllPlates()
    }
    
    func syncResults() {
        results = coreDM.getAllResults()
        plateList = coreDM.getAllPlates()
    }
    
    func recordTime() {
        coreDM.saveResult()
        syncResults()
        selectedResult = results[0]
    }
    
    //Functions for Number Pad
    
    func appendDigit(_ digit: Int) {
        if selectedResult != nil {
            coreDM.appendPlateDigit(result: selectedResult!, digit: digit)
            syncResults()
        }
    }
    func backspace() {
        if selectedResult != nil {
            coreDM.removePlateDigit(result: selectedResult!)
            syncResults()
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
        return result.unwrappedPlate.occurrencesIn(plateList) > 1
    }
    
    func toggleSelectedResult(_ result: Result) {
        if selectedResult == result {
            selectedResult = nil
        } else {
            selectedResult = result
        }
    }
    
    func resultIsSelected(_ result: Result) -> Bool {
        return selectedResult?.id == result.unwrappedId
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(coreDM: DataController())
    }
}
