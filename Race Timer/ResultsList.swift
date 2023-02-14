//
//  ResultsList.swift
//  Race Timer
//
//  Created by niko dittmar on 2/13/23.
//

import SwiftUI

struct ResultsListItem: View {
    var action: () -> Void
    var number: String
    var plate: String
    var isDuplicate: Bool
    var timestamp: String
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Text("\(number).")
                    .frame(width: 40, height: 20, alignment: .leading)
                    .padding(6)
                Text(plate)
                    .frame(width: 80, height: 20)
                    .padding(6)
                    .overlay(RoundedRectangle(cornerRadius: 8) .stroke(Color(UIColor.systemGray2), lineWidth: 0.5))
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                if isDuplicate {
                    Image(systemName: "square.on.square")
                        .foregroundColor(.yellow)
                }
                Spacer()
                Text(timestamp)
            }
        }
    }
}


struct ResultsList: View {
    @ObservedObject var viewModel: ContentViewViewModel
    
    var body: some View {
        ZStack {
            List(viewModel.results, id: \.unwrappedId) { result in
                ResultsListItem(action: {
                    viewModel.toggleSelectedResult(result)
                }, number: viewModel.resultListItemNumber(result), plate: viewModel.resultsListItemLabel(result), isDuplicate: viewModel.hasDuplicatePlate(result), timestamp: result.timeString)
                .listRowBackground(viewModel.resultIsSelected(result) ? Color.accentColor.opacity(0.2) : .clear)
            }
            .listStyle(.inset)
            
            if viewModel.results.isEmpty {
                Text("No recordings to display\nTap \"Record Time\" to create a recording")
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(UIColor.systemGray2))
            }
        }
    }
}

