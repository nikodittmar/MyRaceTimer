//
//  DataController.swift
//  Race Timer
//
//  Created by niko dittmar on 8/3/22.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Race_Timer")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    func removePlateDigit(result: Result) {
        let objectToEdit = container.viewContext.object(with: result.objectID)
        
        let plateKey = objectToEdit.value(forKey: "plate")
        
        var plate: String = ""
        
        if let plateString = plateKey as? String {
            plate = plateString
        }
        
        if plate != "" {
            plate.removeLast()
        }
        
        objectToEdit.setValue(plate, forKey: "plate")
        
        do {
            try container.viewContext.save()
        } catch {
            container.viewContext.rollback()
            print("Unable to delete last plate digit: \(error)")
        }
    }
    
    
    func appendPlateDigit(result: Result, digit: Int) {
        let objectToEdit = container.viewContext.object(with: result.objectID)
        
        let plateKey = objectToEdit.value(forKey: "plate")
        
        var plate: String = ""
        
        if let plateString = plateKey as? String {
            plate = plateString
        }
        
        if plate.count < 5 {
            plate.append(String(digit))
        }
        
        objectToEdit.setValue(plate, forKey: "plate")
            
        do {
            try container.viewContext.save()
        } catch {
            container.viewContext.rollback()
            print("Unable to append plate digit: \(error)")
        }
    }
    
    func delete(_ result: Result) {
        let objectToDelete = container.viewContext.object(with: result.objectID)
        container.viewContext.delete(objectToDelete)
        do {
            try container.viewContext.save()
        } catch {
            container.viewContext.rollback()
            print("Unable to delete result: \(error)")
        }
    }
    
    func deleteAll() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Result")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try container.viewContext.execute(deleteRequest)
        } catch {
            print("Unable to delete all results: \(error)")
        }
    }
    
    func getAllResults() -> [Result] {
        let fetchRequest: NSFetchRequest<Result> = Result.fetchRequest()
        let sortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            return try container.viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    func getAllPlates() -> [String] {
        let results: [Result] = getAllResults()
        var plates: [String] = []
        for result in results {
            let plate = result.unwrappedPlate
            if plate != "" {
                plates.append(result.unwrappedPlate)
            }
        }
        return plates
    }
    
    func saveResult(plate: String) {
        let result = Result(context: container.viewContext)
        result.id = UUID()
        result.plate = plate
        result.timestamp = Double(Date().timeIntervalSince1970)
        
        do {
            try container.viewContext.save()
        } catch {
            print("Failed to save result")
        }
    }
    
    func getResultsFrom(_ results: TimingResult) -> [Result] {
        return results.resultArray
    }
    
    func getAllPlatesFrom(_ results: TimingResult) -> [String] {
        let results: [Result] = getResultsFrom(results)
        var plates: [String] = []
        for result in results {
            let plate = result.unwrappedPlate
            if plate != "" {
                plates.append(result.unwrappedPlate)
            }
        }
        return plates
    }
    
    func createTimingResult(mode: TimingMode) {
        deactivateAllTimingResults()
        let timingResult = TimingResult(context: container.viewContext)
        timingResult.name = ""
        switch mode {
        case.start:
            timingResult.start = true
        case.finish:
            timingResult.start = false
        }
        timingResult.loaded = true
        timingResult.id = UUID()
        timingResult.lastUpdated = Double(Date().timeIntervalSince1970)
        
        do {
            try container.viewContext.save()
            
        } catch {
            print("Failed to save timing Result")
        }
    }
    
    func getAllTimingResults() -> [TimingResult] {
        let fetchRequest: NSFetchRequest<TimingResult> = TimingResult.fetchRequest()
        let sortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "lastUpdated", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            return try container.viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    func getActiveTimingResult() -> TimingResult? {
        let TimingResults: [TimingResult] = getAllTimingResults()
        var activeTimingResults: [TimingResult] = []
        for timingResult in TimingResults {
            if timingResult.loaded == true {
                activeTimingResults.append(timingResult)
            }
        }
        if activeTimingResults.count != 1 {
            deactivateAllTimingResults()
            return nil
        } else {
            return activeTimingResults[0]
        }
    }
    
    func deactivateAllTimingResults() {
        let TimingResults: [TimingResult] = getAllTimingResults()
        for timingResult in TimingResults {
            let objectToEdit = container.viewContext.object(with: timingResult.objectID)
            objectToEdit.setValue(false, forKey: "loaded")
            do {
                try container.viewContext.save()
            } catch {
                container.viewContext.rollback()
                print("Unable to append deactivate all timing results: \(error)")
            }
        }
    }
    
    func saveResultTo(_ timingResult: TimingResult, plate: String) {
        let result = Result(context: container.viewContext)
        result.id = UUID()
        result.plate = plate
        result.timestamp = Double(Date().timeIntervalSince1970)
        result.timingResult = timingResult
        
        do {
            try container.viewContext.save()
        } catch {
            print("Failed to save result")
        }
    }
    
    func deleteTimingResult(_ timingResult: TimingResult) {
        let objectToDelete = container.viewContext.object(with: timingResult.objectID)
        container.viewContext.delete(objectToDelete)
        do {
            try container.viewContext.save()
        } catch {
            container.viewContext.rollback()
            print("Unable to delete timingResult: \(error)")
        }
    }
    
    func setTimingResultName(_ timingResult: TimingResult, name: String) {
        let objectToEdit = container.viewContext.object(with: timingResult.objectID)
        objectToEdit.setValue(name, forKey: "name")
        objectToEdit.setValue(Double(Date().timeIntervalSince1970), forKey: "lastUpdated")
        do {
            try container.viewContext.save()
        } catch {
            container.viewContext.rollback()
            print("Unable to set Timing Result Name: \(error)")
        }
    }
    
    func setTimingResultType(_ timingResult: TimingResult, timingMode: TimingMode) {
        let objectToEdit = container.viewContext.object(with: timingResult.objectID)
        objectToEdit.setValue(Double(Date().timeIntervalSince1970), forKey: "lastUpdated")
        
        switch timingMode {
        case.start:
            objectToEdit.setValue(true, forKey: "start")
        case.finish:
            objectToEdit.setValue(false, forKey: "start")
        }

        do {
            try container.viewContext.save()
        } catch {
            container.viewContext.rollback()
            print("Unable to set Timing Result Type: \(error)")
        }
    }

    func activateTimingResult(_ timingResult: TimingResult) {
        deactivateAllTimingResults()
        let objectToEdit = container.viewContext.object(with: timingResult.objectID)
        objectToEdit.setValue(true, forKey: "loaded")
    }
    
}
