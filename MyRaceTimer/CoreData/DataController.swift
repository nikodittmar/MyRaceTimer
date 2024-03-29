//
//  DataController.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 4/26/23.
//

import Foundation
import CoreData
import SwiftUI
import UniformTypeIdentifiers

public enum RecordingsType: String {
    case Start = "start"
    case Finish = "finish"
}

extension UTType {
    static var recordingSet: UTType { UTType(exportedAs: "com.nikodittmar.MyRaceTimer.recordingset") }
}

public enum ImportError: Error {
    case cannotAccessUrlData
    case cannotDecodeData
    case cannotDeleteOldEmptyRecordingSet
}

// Core Data controller
class DataController {
    static let shared: DataController = DataController()
    
    private let viewContext: NSManagedObjectContext = PersistenceController.shared.viewContext
    
    private let userDefaultsSelectedRecordingSetIdStringKey: String
    
    var selectedRecordingSet: RecordingSet? {
        didSet {
            UserDefaults.standard.set(selectedRecordingSet?.wrappedId.uuidString ?? "", forKey: userDefaultsSelectedRecordingSetIdStringKey)
        }
    }
    
    init(forTesting: Bool = false) {
        if forTesting {
            self.userDefaultsSelectedRecordingSetIdStringKey = "selectedRecordingSetIdStringTest"
        } else {
            self.userDefaultsSelectedRecordingSetIdStringKey = "selectedRecordingSetIdString"
        }
        
        if let selectedRecordingSet = getSelectedRecordingSet() {
            self.selectedRecordingSet = selectedRecordingSet
        } else {
            createRecordingSet()
        }
    }
    
    // CREATE
    
    func createRecordingSet(name: String = "", type: RecordingsType = RecordingsType.Start) {
        let recordingSet = RecordingSet(context: viewContext)
        let recordingSetId: UUID = UUID()
        
        recordingSet.id = recordingSetId
        recordingSet.createdDate = Double(Date().timeIntervalSince1970)
        recordingSet.updatedDate = Double(Date().timeIntervalSince1970)
        recordingSet.type = type.rawValue
        recordingSet.name = name
        
        do {
            try viewContext.save()
            self.selectedRecordingSet = recordingSet
        } catch {
            print("Failed to create Recording Set!")
        }
    }
    
    func createRecording(withTimestamp: Bool = true) -> Recording? {
        if let selectedRecordingSet = self.selectedRecordingSet {
            let recording = Recording(context: viewContext)
            
            recording.id = UUID()
            recording.plate = ""
            recording.createdDate = Double(Date().timeIntervalSince1970)
            recording.timestamp = withTimestamp ? Double(Date().timeIntervalSince1970) : 0.0
            recording.recordingSet = selectedRecordingSet
            
            selectedRecordingSet.setValue(Double(Date().timeIntervalSince1970), forKey: "updatedDate")
            
            do {
                try viewContext.save()
                return recording
            } catch {
                print("Failed to save Recording!")
                return nil
            }
        } else {
            print("No selected Recording Set found, Recording was not created!")
            return nil
        }
    }
    
    // READ
    
    func getRecordingSets() -> [RecordingSet] {
        let fetchRequest = NSFetchRequest<RecordingSet>(entityName: "RecordingSet")
        let sortDescriptor = NSSortDescriptor(key: "updatedDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch Recording Sets!")
            return []
        }
    }
    
    func getSelectedRecordingSet() -> RecordingSet? {
        if let selectedRecordingSetIdString = UserDefaults.standard.object(forKey: userDefaultsSelectedRecordingSetIdStringKey) as? String {
            if let selectedRecordingSetId = UUID(uuidString: selectedRecordingSetIdString) {
                let fetchRequest: NSFetchRequest<RecordingSet> = RecordingSet.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", selectedRecordingSetId as CVarArg)
                fetchRequest.fetchLimit = 1
                return try? viewContext.fetch(fetchRequest).first
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func getRecordings() -> [Recording] {
        return selectedRecordingSet?.wrappedRecordings ?? []
    }
    
    // UPDATE
    
    func updateSelectedRecordingSetName(_ name: String) {
        if let selectedRecordingSet = self.selectedRecordingSet {
            selectedRecordingSet.setValue(name, forKey: "name")
            do {
                try viewContext.save()
            } catch {
                viewContext.rollback()
                print("Unable to set Recording Set type: \(error)")
            }
        } else {
            print("No selected Recording Set found, cannot update Recording Set name!")
        }
    }
    
    func updateSelectedRecordingSetType(_ type: RecordingsType) {
        if let selectedRecordingSet = self.selectedRecordingSet {
            selectedRecordingSet.setValue(type.rawValue, forKey: "type")
            do {
                try viewContext.save()
            } catch {
                viewContext.rollback()
                print("Unable to set Recording Set type: \(error)")
            }
        } else {
            print("No selected Recording Set found, cannot update Recording Set type!")
        }
    }
    
    func appendRecordingPlateDigit(_ recording: Recording, digit: Int) {
        guard digit <= 9 && digit >= 0 else {
            return
        }
        
        var plateString = recording.wrappedPlate
        
        if plateString.count < 6 {
            plateString.append(String(digit))
            updateRecordingPlate(recording, plate: plateString)
        }
    }
    
    func deleteLastRecordingPlateDigit(_ recording: Recording) {

        let plateString = recording.wrappedPlate
        
        if plateString.count > 0 {
            updateRecordingPlate(recording, plate: String(plateString.dropLast(1)))
        }
    }
    
    private func updateRecordingPlate(_ recording: Recording, plate: String) {
        recording.setValue(plate, forKey: "plate")
        
        do {
            try viewContext.save()
        } catch {
            viewContext.rollback()
            print("Unable to set Recording plate: \(error)")
        }
    }
    
    func updateRecordingTimestamp(_ recording: Recording, timestamp: Date) {
        recording.setValue(Double(timestamp.timeIntervalSince1970), forKey: "timestamp")
        
        do {
            try viewContext.save()
        } catch {
            viewContext.rollback()
            print("Unable to set Recording timestamps: \(error)")
        }
    }
    
    // DESTROY
    
    func deleteRecording(_ recording: Recording) {
        viewContext.delete(recording)
        
        do {
            try viewContext.save()
        } catch {
            viewContext.rollback()
            print("Unable to delete recording")
        }
    }
        
    func deleteSelectedRecordingSet() {
        if let selectedRecordingSet = self.selectedRecordingSet {
            viewContext.delete(selectedRecordingSet)
            do {
                try viewContext.save()
                createRecordingSet()
            } catch {
                viewContext.rollback()
                print("Unable to delete selected Recording: \(error)")
            }
        }
    }
    
    // OTHER
    
    func selectRecordingSet(_ recordingSet: RecordingSet) {
        recordingSet.setValue(Double(Date().timeIntervalSince1970), forKey: "updatedDate")
        
        if let currentRecordingSet = selectedRecordingSet {
            if currentRecordingSet.wrappedRecordings.isEmpty && currentRecordingSet.wrappedName.isEmpty {
                viewContext.delete(currentRecordingSet)
            }
        }
        
        do {
            try viewContext.save()
            selectedRecordingSet = recordingSet
        } catch {
            viewContext.rollback()
            print("Unable to set Recording Set updated date: \(error)")
        }
    }
    
    private func getImportedRecordingSetData(url: URL) -> Data? {
        do {
            return try Data(contentsOf: url)
        } catch {
            if url.startAccessingSecurityScopedResource() {
                do {
                    let data = try Data(contentsOf: url)
                    url.stopAccessingSecurityScopedResource()
                    return data
                } catch {
                    url.stopAccessingSecurityScopedResource()
                    return nil
                }
            } else {
                url.stopAccessingSecurityScopedResource()
                return nil
            }
        }
    }
    
    func importRecordingSet(url: URL) throws {
        if let data = getImportedRecordingSetData(url: url) {
            let decoder = JSONDecoder()
            decoder.userInfo[CodingUserInfoKey.managedObjectContext] = viewContext
            
            do {
                let recordingSet = try decoder.decode(RecordingSet.self, from: data)
                
                if let selectedRecordingSet = self.selectedRecordingSet {
                    if selectedRecordingSet.wrappedRecordings.isEmpty && selectedRecordingSet.wrappedName.isEmpty {
                        viewContext.delete(selectedRecordingSet)
                    }
                }
                do {
                    try viewContext.save()
                    selectedRecordingSet = recordingSet
                } catch {
                    viewContext.rollback()
                    throw ImportError.cannotDeleteOldEmptyRecordingSet
                }
            } catch {
                throw ImportError.cannotDecodeData
            }
        } else {
            throw ImportError.cannotAccessUrlData
        }
    }
    
    // Results
    
    func getResults() -> [Result] {
        let fetchRequest = NSFetchRequest<Result>(entityName: "Result")
        let sortDescriptor = NSSortDescriptor(key: "updatedDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch Results")
            return []
        }
    }
    
    func deleteResult(result: Result) {
        viewContext.delete(result)
        
        do {
            try viewContext.save()
        } catch {
            viewContext.rollback()
            print("Unable to delete result")
        }
    }
    
    func getOverallStandings(result: Result) -> [Racer] {
        return result.standings
    }
    
    func getStandingsFor(result: Result, stage: Stage) -> [Racer] {
        return result.standingsFor(stage: stage)
    }
    
    func getStages(result: Result) -> [Stage] {
        return result.wrappedStages
    }
    
    private func getRacerByPlate(result: Result, plate: String) -> Racer? {
        for racer in result.wrappedRacers {
            if racer.wrappedPlate == plate {
                return racer
            }
        }
        return nil
    }
    
    func createResult(recordingSetPairs: [RecordingSetPair], name: String) -> Result? {
        let result = Result(context: viewContext)
        result.id = UUID()
        result.name = name
        result.createdDate = Double(Date().timeIntervalSince1970)
        result.updatedDate = Double(Date().timeIntervalSince1970)
        
        do {
            try viewContext.save()
            for recordingSetPair in recordingSetPairs {
                if let stage = createStage(result: result, name: recordingSetPair.name) {
                    for recordingPair in recordingSetPair.recordingPairs() {
                        if let racer = getRacerByPlate(result: result, plate: recordingPair.plate) {
                            createStageResult(racer: racer, stage: stage, startTime: recordingPair.startTime, endTime: recordingPair.endTime, penalty: 0.0)
                        } else if let racer = createRacer(result: result, plate: recordingPair.plate, name: "") {
                            createStageResult(racer: racer, stage: stage, startTime: recordingPair.startTime, endTime: recordingPair.endTime, penalty: 0.0)
                        }
                    }
                }
            }
            
            return result
        } catch {
            return nil
        }
    }
    
    private func createRacer(result: Result, plate: String, name: String) -> Racer? {
        let racer = Racer(context: viewContext)
        racer.id = UUID()
        racer.plate = plate
        racer.name = name
        racer.result = result
        
        do {
            try viewContext.save()
            return racer
        } catch {
            return nil
        }
    }
    
    private func createStage(result: Result, name: String) -> Stage? {
        let stage = Stage(context: viewContext)
        stage.id = UUID()
        stage.name = name
        stage.result = result
        
        do {
            try viewContext.save()
            return stage
        } catch {
            return nil
        }
    }
    
    private func createStageResult(racer: Racer, stage: Stage, startTime: Double, endTime: Double, penalty: Double) {
        let stageResult = StageResult(context: viewContext)
        stageResult.racer = racer
        stageResult.stage = stage
        stageResult.id = UUID()
        stageResult.startTime = startTime
        stageResult.endTime = endTime
        stageResult.penalty = penalty
        
        do {
            try viewContext.save()
        } catch {
        }
    }
}

