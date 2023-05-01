//
//  RecordingSetsSheetViewModel.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 2/15/23.
//

import Foundation

@MainActor class RecordingSetsSheetViewModel: ObservableObject {
    let dataController: DataController = DataController.shared
    
    @Published var selectedRecordingSetName: String = ""
    @Published var selectedRecordingSetType: RecordingsType = RecordingsType.Start

    @Published var presentingDeleteRecordingSetWarning: Bool = false
    @Published var presentingShareSheet: Bool = false
    
    @Published var fileToShareURL: [URL] = []
    
    init() {
        updateSelectedRecordingNameAndTypeField()
    }
    
    func updateRecordingSetName() {
        dataController.updateSelectedRecordingSetName(selectedRecordingSetName)
    }
    
    func updateRecordingSetType() {
        dataController.updateSelectedRecordingSetType(selectedRecordingSetType)
    }
    
    func updateSelectedRecordingNameAndTypeField() {
        if let selectedRecordingSet = dataController.selectedRecordingSet {
            self.selectedRecordingSetName = selectedRecordingSet.wrappedName
            self.selectedRecordingSetType = selectedRecordingSet.wrappedType
        }
    }
    
    func selectedRecordingSetHasDuplicatePlates() -> Bool {
        if let selectedRecordingSet = dataController.getSelectedRecordingSet() {
            return selectedRecordingSet.hasDuplicatePlates
        } else {
            return false
        }
    }
    
    func selectedRecordingSetHasMissingPlates() -> Bool {
        if let selectedRecordingSet = dataController.getSelectedRecordingSet() {
            return selectedRecordingSet.missingPlates
        } else {
            return false
        }
    }
    
    func selectedRecordingSetHasMissingTimestamps() -> Bool {
        if let selectedRecordingSet = dataController.getSelectedRecordingSet() {
            return selectedRecordingSet.missingTimestamps
        } else {
            return false
        }
    }
    
    func selectedRecordingSetIsEmpty() -> Bool {
        if let selectedRecordingSet = dataController.getSelectedRecordingSet() {
            return selectedRecordingSet.wrappedName.isEmpty && selectedRecordingSet.wrappedRecordings.isEmpty
        } else {
            return false
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func exportSelectedRecordingSet() {
        if let selectedRecordingSet = dataController.getSelectedRecordingSet() {
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(selectedRecordingSet)
                let fileName = selectedRecordingSet.fileName
                let fileURL = getDocumentsDirectory().appendingPathComponent(fileName, conformingTo: .recordingSet)
                do {
                    try FileManager.default.removeItem(at: fileURL)
                } catch {}
                do {
                    try data.write(to: fileURL)
                    fileToShareURL = [fileURL]
                    presentingShareSheet = true
                } catch {}
            } catch {
                print("An Unknown Export Error Has Occured.")
            }
        }
    }
    
    func exportSelectedRecordingSetCSV() {
        if let selectedRecordingSet = dataController.getSelectedRecordingSet() {
            let data = selectedRecordingSet.recordingsCSVString
            let fileName = selectedRecordingSet.fileName
            let fileURL = getDocumentsDirectory().appendingPathComponent(fileName, conformingTo: .commaSeparatedText)
            do {
                try FileManager.default.removeItem(at: fileURL)
            } catch {}
            do {
                try data.write(to: fileURL, atomically: true, encoding: .utf8)
                fileToShareURL = [fileURL]
                presentingShareSheet = true
            } catch {}
        }
    }
    
    func createRecordingSet() {
        dataController.createRecordingSet()
        updateSelectedRecordingNameAndTypeField()
    }
    
    func recordingSetsWithoutSelectedRecordingSet() -> [RecordingSet] {
        if let selectedRecordingSet = dataController.getSelectedRecordingSet() {
            return dataController.getRecordingSets().without(selectedRecordingSet)
        } else {
            return dataController.getRecordingSets()
        }
    }
    
    func selectRecordingSet(_ recordingSet: RecordingSet) {
        dataController.selectRecordingSet(recordingSet)
        updateSelectedRecordingNameAndTypeField()
    }
    
    func deleteSelectedRecordingSet() {
        dataController.deleteSelectedRecordingSet()
        updateSelectedRecordingNameAndTypeField()
    }
}
