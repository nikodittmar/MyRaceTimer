//
//  ResultDetailSheet.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 4/30/23.
//

import SwiftUI

struct ResultDetailSheet: View {
    @StateObject var viewModel: ResultDetailSheetViewModel
    @Environment(\.presentationMode) var presentationMode
    
    init(result: Result) {
        _viewModel = StateObject(wrappedValue: ResultDetailSheetViewModel(result: result))
    }
    
    var body: some View {
        VStack {
            Menu(viewModel.standingsSelectorText()) {
                Button("Overall", action: { viewModel.selectOverall() })
                ForEach(viewModel.stages, id: \.id) { stage in
                    Button(stage.wrappedName, action: { viewModel.selectStage(stage: stage) })
                }
            }
            List(viewModel.standings, id: \.id) { racer in
                HStack {
                    Text(viewModel.placeOf(racer: racer))
                        .frame(width: 40, height: 20, alignment: .leading)
                        .padding(6)
                    Text(racer.wrappedPlate)
                        .frame(width: 80, height: 20)
                        .padding(6)
                        .overlay(RoundedRectangle(cornerRadius: 8) .stroke(Color(UIColor.systemGray2), lineWidth: 0.5))
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                        .accessibilityLabel("Plate")
                    if viewModel.hasPenalty(racer: racer) {
                        Text(viewModel.penaltyFor(racer: racer))
                            .foregroundColor(.yellow)
                    }
                    Spacer()
                    Text(racer.overallTimeString).font(.subheadline.monospaced())
                }
            }
            .listStyle(.inset)
            Button {
                viewModel.deleteResult()
                presentationMode.wrappedValue.dismiss()
            } label: {
                Label("Delete Result", systemImage: "")
            }
        }
        .navigationTitle(viewModel.result.wrappedName)
    }
}
