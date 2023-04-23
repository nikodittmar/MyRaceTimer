//
//  AddPlateButton.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 4/22/23.
//

import SwiftUI

struct AddPlateButton: View {
    @EnvironmentObject var coreData: CoreDataViewModel
    
    var body: some View {
        Button {
            coreData.createRecording(withoutTimestamp: true)
        } label: {
            Text("Add Plate Number")
                .foregroundColor(.blue)
                .font(.title3)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .border(Color(UIColor.systemGray4))
                .background(Color(UIColor.systemGray6))
        }
        .padding(.bottom, -1)
    }
}
