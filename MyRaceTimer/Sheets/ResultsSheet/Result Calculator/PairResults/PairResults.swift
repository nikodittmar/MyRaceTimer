//
//  PairRecordings.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 2/18/23.
//

import SwiftUI

struct PairSelectedResults: View {
    @EnvironmentObject var calculatorViewModel: ResultCalculatorViewModel
    
    var body: some View {
        VStack {
            Form {
                ForEach(calculatorViewModel.resultPairs, id: \.id) { resultPair in
                    Section {
                        Button {
                            calculatorViewModel.deleteResultPair(resultPair: resultPair)
                        } label: {
                            VStack {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        if resultPair.start.wrappedName == "" {
                                            Text("Untitled Stage")
                                                .foregroundColor(.gray)
                                                .lineLimit(1)
                                                .padding(.top, 2)
                                        } else {
                                            Text(resultPair.start.wrappedName)
                                                .padding(.top, 2)
                                                .foregroundColor(.black)
                                                .lineLimit(1)
                                        }
                                        Text("\(resultPair.start.wrappedRecordings.count) Recordings, Stage \(resultPair.start.wrappedType.rawValue.capitalized)")
                                            .font(.caption)
                                            .padding(.bottom, 2)
                                            .foregroundColor(.black)
                                    }
                                    Spacer()
                                    if resultPair.start.warningCount != 0 {
                                        HStack {
                                            Text(String(resultPair.start.warningCount))
                                                .foregroundColor(.black)
                                            Image(systemName: "exclamationmark.triangle.fill")
                                                .foregroundColor(.yellow)
                                        }
                                    }
                                }
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        if resultPair.finish.wrappedName == "" {
                                            Text("Untitled Stage")
                                                .foregroundColor(.gray)
                                                .lineLimit(1)
                                                .padding(.top, 2)
                                        } else {
                                            Text(resultPair.finish.wrappedName)
                                                .padding(.top, 2)
                                                .foregroundColor(.black)
                                                .lineLimit(1)
                                        }
                                        Text("\(resultPair.finish.wrappedRecordings.count) Recordings, Stage \(resultPair.finish.wrappedType.rawValue.capitalized)")
                                            .font(.caption)
                                            .padding(.bottom, 2)
                                            .foregroundColor(.black)
                                    }
                                    Spacer()
                                    if resultPair.finish.warningCount != 0 {
                                        HStack {
                                            Text(String(resultPair.finish.warningCount))
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

                if !calculatorViewModel.selectedResults.isEmpty {
                    Section(header: Text("Selected Results")) {
                        List(calculatorViewModel.selectedResults, id: \.wrappedId) { result in
                            Button {
                                calculatorViewModel.selectResultForPairing(result: result)
                            } label: {
                                HStack {
                                    if calculatorViewModel.selectedResultForPairing?.wrappedId == result.wrappedId {
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
                                        Text("\(result.wrappedRecordings.count) Recordings, Stage \(result.wrappedType.rawValue.capitalized)")
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
                            .disabled(!calculatorViewModel.resultIsAvailibleForPairing(result: result))
                        }
                    }
                }
            }
        }
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                NavigationLink {
//
//                } label: {
//                    Text("Next")
//                        .fontWeight(.bold)
//                }
//                .disabled(calculatorViewModel.selectedResults.isEmpty)
//            }
//        }
        .navigationTitle("Pair Recordings")
    }
}
