//
//  RecordingsList.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 2/13/23.
//

import SwiftUI

struct RecordingsList: View {
    
    var recordings: [Recording]
    var selectedRecording: Recording?
    var selectRecording: (Recording) -> Void
    
    var body: some View {
        ZStack {
            List(recordings, id: \.wrappedId) { recording in
                RecordingsListItem(recording: recording, onTap: { self.selectRecording(recording) }, hasDuplicatePlate: recordings.plates().duplicates().contains(recording.wrappedPlate), index: recordings.firstIndex(of: recording) ?? 0)
                    .listRowBackground(selectedRecording == recording ? Color.accentColor.opacity(0.2) : .clear)
                    .accessibilityLabel("Recording")
            }
            .accessibilityLabel("Recordings")
            .listStyle(.inset)
            
            if recordings.isEmpty {
                Text("No recordings to display\nTap \"Record Time\" to create a recording.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(UIColor.systemGray2))
            }
        }
    }
}

struct RecordingsListItem: View {
    
    var recording: Recording
    var onTap: () -> Void
    var hasDuplicatePlate: Bool
    var index: Int
    
    var body: some View {
        Button {
            self.onTap()
        } label: {
            HStack {
                Text("\(String(index)).")
                    .frame(width: 40, height: 20, alignment: .leading)
                    .padding(6)
                Text(recording.plateLabel)
                    .frame(width: 80, height: 20)
                    .padding(6)
                    .overlay(RoundedRectangle(cornerRadius: 8) .stroke(Color(UIColor.systemGray2), lineWidth: 0.5))
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                    .accessibilityLabel("Plate")
                if hasDuplicatePlate {
                    Image(systemName: "square.on.square")
                        .foregroundColor(.yellow)
                }
                Spacer()
                Text(recording.timestampString).font(.subheadline.monospaced())
            }
        }
    }
}
