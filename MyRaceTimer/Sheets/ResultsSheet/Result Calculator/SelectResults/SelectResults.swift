//
//  SelectRecordings.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 2/18/23.
//

import SwiftUI

struct SelectResults: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var coreData: CoreDataViewModel
    @StateObject var calculatorViewModel: ResultCalculatorViewModel = ResultCalculatorViewModel()
    @StateObject var viewModel: SelectResultsViewModel = SelectResultsViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section {
                        List(coreData.results, id: \.wrappedId) { result in
                            Button {
                                calculatorViewModel.toggleResultSelection(result: result)
                            } label: {
                                HStack {
                                    if calculatorViewModel.selectedResults.contains(result) {
                                        Image(systemName: "circle.inset.filled")
                                    } else {
                                        Image(systemName: "circle")
                                    }
                                    
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
                                        Text(calculatorViewModel.resultLabel(result: result))
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
                    Section {
                        Button {
                            viewModel.next(selectedResults: calculatorViewModel.selectedResults)
                        } label: {
                            HStack {
                                Text("Next")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color(UIColor.systemGray))
                            }
                        }
                        .disabled(calculatorViewModel.selectedResults.isEmpty)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .fontWeight(.bold)
                    }
                }
            }
            .navigationDestination(isPresented: $viewModel.navigatingToPairResults) {
                PairSelectedResults()
            }
            .navigationTitle("Select Recordings")
            .alert("Select the same amount of start and finish results to continue.", isPresented: $viewModel.presentingUnequalSelectionWarning) {
                Button("Ok", role: .cancel) {}
            }
            
        }
        .environmentObject(calculatorViewModel)

    }
}
