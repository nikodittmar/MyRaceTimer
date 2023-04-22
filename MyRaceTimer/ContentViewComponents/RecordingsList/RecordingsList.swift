//
//  RecordingsList.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 2/13/23.
//

import SwiftUI

struct RecordingsList: View {
    @EnvironmentObject var coreData: CoreDataViewModel
    
    var body: some View {
        ZStack {
            List(coreData.recordings, id: \.wrappedId) { recording in
                RecordingsListItem(recording: recording)
                    .listRowBackground(coreData.recordingIsSelected(recording) ? Color.accentColor.opacity(0.2) : .clear)
            }
            .listStyle(.inset)
            
            if coreData.recordings.isEmpty {
                Text("No recordings to display\nTap \"Record Time\" to create a recording.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(UIColor.systemGray2))
            }
        }
    }
}

struct RecordingsListItem: View {
    @EnvironmentObject var coreData: CoreDataViewModel
    
    var recording: Recording
    
    var body: some View {
        Button {
            coreData.selectRecording(recording)
        } label: {
            HStack {
                Text("\(coreData.recordingPlaceLabel(recording: recording)).")
                    .frame(width: 40, height: 20, alignment: .leading)
                    .padding(6)
                Text(recording.plateLabel)
                    .frame(width: 80, height: 20)
                    .padding(6)
                    .overlay(RoundedRectangle(cornerRadius: 8) .stroke(Color(UIColor.systemGray2), lineWidth: 0.5))
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                if coreData.isDuplicate(recording: recording) {
                    Image(systemName: "square.on.square")
                        .foregroundColor(.yellow)
                }
                Spacer()
                Text(recording.timestampString)
            }
        }
    }
}
