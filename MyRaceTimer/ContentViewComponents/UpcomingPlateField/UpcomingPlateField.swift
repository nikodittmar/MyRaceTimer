//
//  UpcomingPlateEntry.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 2/14/23.
//

import SwiftUI

struct UpcomingPlateField: View {
    @EnvironmentObject var coreData: CoreDataViewModel
    @StateObject var viewModel: UpcomingPlateFieldViewModel = UpcomingPlateFieldViewModel()
    
    var body: some View {
        Button {
            coreData.selectUpcomingPlateField()
        } label: {
            ZStack {
                HStack {
                    Text("Next:")
                        .padding(.leading)
                        .foregroundColor(Color(UIColor.label))
                        .font(.title3)
                    Spacer()
                    if coreData.upcomingPlateIsDuplicate() {
                        Image(systemName: "square.on.square")
                            .foregroundColor(.yellow)
                            .padding(.trailing)
                    }
                }
                Text(viewModel.label(upcomingPlate: coreData.upcomingPlate))
                    .frame(width: 160, height: 30)
                    .padding(6)
                    .overlay( RoundedRectangle(cornerRadius: 8) .stroke(Color(UIColor.systemGray2), lineWidth: 0.5))
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(8)
                    .foregroundColor(Color(UIColor.label))
                    .font(.title3)

            }
            .frame(maxWidth: .infinity)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .border(Color(UIColor.systemGray4))
            .background(coreData.upcomingPlateFieldSelected ? Color.accentColor.opacity(0.2) : Color(UIColor.systemGray6))
        }
        .padding(.bottom, -1)
    }
}
