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
}
