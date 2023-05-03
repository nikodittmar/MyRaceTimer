//
//  PairSelectedRecordingSetsViewModel.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 4/30/23.
//

import Foundation

@MainActor class PairSelectedRecordingSetsViewModel: ObservableObject {    
    @Published var selectedRecordingSets: [RecordingSet]
    @Published var recordingSetPairs: [RecordingSetPair] = []
    @Published var selectedRecordingSetForPairing: RecordingSet? = nil
    @Published var navigatingToResolveIssues: Bool = false
    @Published var navigatingToResultName: Bool = false
    
    init(selectedRecordingSets: [RecordingSet]) {
        self.selectedRecordingSets = selectedRecordingSets
    }
    
    func recordingSetIsDisabled(_ recordingSet: RecordingSet) -> Bool {
        if let selectedRecordingSet = selectedRecordingSetForPairing {
            if selectedRecordingSet.wrappedId == recordingSet.wrappedId {
                return false
            } else {
                if selectedRecordingSet.wrappedType == recordingSet.wrappedType {
                    return true
                } else {
                    return false
                }
            }
        } else {
            return false
        }
    }
    
    func selectRecordingSetForPairing(_ recordingSet: RecordingSet) {
        if let selectedRecordingSet = selectedRecordingSetForPairing {
            if selectedRecordingSet == recordingSet {
                selectedRecordingSetForPairing = nil
            } else {
                if selectedRecordingSet.wrappedType != recordingSet.wrappedType {
                    if selectedRecordingSet.wrappedType == RecordingsType.Start {
                        let recordingSetPair = RecordingSetPair(start: selectedRecordingSet, finish: recordingSet, name: selectedRecordingSet.wrappedName)
                        recordingSetPairs.append(recordingSetPair)
                        selectedRecordingSets = selectedRecordingSets.filter {
                            $0.wrappedId != selectedRecordingSet.wrappedId &&  $0.wrappedId != recordingSet.wrappedId
                        }
                        selectedRecordingSetForPairing = nil
                    } else {
                        let recordingSetPair = RecordingSetPair(start: recordingSet, finish: selectedRecordingSet, name: selectedRecordingSet.wrappedName)
                        recordingSetPairs.append(recordingSetPair)
                        selectedRecordingSets = selectedRecordingSets.filter {
                            $0.wrappedId != selectedRecordingSet.wrappedId &&  $0.wrappedId != recordingSet.wrappedId
                        }
                        selectedRecordingSetForPairing = nil
                    }
                }
            }
        } else {
            selectedRecordingSetForPairing = recordingSet
        }
    }
    
    func deleteRecordingSetPair(_ recordingSetPair: RecordingSetPair) {
        recordingSetPairs = recordingSetPairs.filter {
            $0.id != recordingSetPair.id
        }
        selectedRecordingSets.append(recordingSetPair.start)
        selectedRecordingSets.append(recordingSetPair.finish)
    }
    
    func next() {
        for recordingSetPair in recordingSetPairs {
            if !recordingSetPair.errors().isEmpty {
                navigatingToResolveIssues = true
                return
            }
        }
        navigatingToResultName = true
    }
}
