//
//  ResultSheet.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 4/29/23.
//

import SwiftUI

struct ResultSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: ResultSheetViewModel = ResultSheetViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Button("Calculate Results") {
                        viewModel.displayingResultCalculatorSheet = true
                    }
                    if !viewModel.results.isEmpty {
                        Section(header: Text("Results")) {
                            List(viewModel.results, id: \.wrappedId) { result in
                                NavigationLink {
                                    ResultDetailSheet(result: result)
                                } label: {
                                    VStack(alignment: .leading, spacing: 2) {
                                        if result.wrappedName == "" {
                                            Text("Untitled Result")
                                                .foregroundColor(.gray)
                                                .lineLimit(1)
                                                .padding(.top, 2)
                                        } else {
                                            Text(result.wrappedName)
                                                .padding(.top, 2)
                                                .foregroundColor(Color(UIColor.label))
                                                .lineLimit(1)
                                        }
                                        Text(result.label)
                                            .font(.caption)
                                            .padding(.bottom, 2)
                                            .foregroundColor(Color(UIColor.label))
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .fullScreenCover(isPresented: $viewModel.displayingResultCalculatorSheet, content: {
                SelectRecordingSets()
            })
            .navigationBarTitle(Text("Recording Sets"), displayMode: .inline)
        }
    }
}

struct ResultSheet_Previews: PreviewProvider {
    static var previews: some View {
        ResultSheet()
    }
}
