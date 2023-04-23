//
//  Result+CoreDataProperties.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 4/18/23.
//
//

import Foundation
import CoreData
import SwiftUI


extension Result {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Result> {
        return NSFetchRequest<Result>(entityName: "Result")
    }

    @NSManaged public var createdDate: Double
    @NSManaged public var updatedDate: Double
    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var id: UUID?
    @NSManaged public var recordings: NSSet?

    public var wrappedId: UUID {
        id ?? UUID()
    }
    
    public var wrappedName: String {
        name ?? ""
    }
    
    public var wrappedUpdatedDate: Date {
        Date(timeIntervalSince1970: updatedDate)
    }
    
    public var wrappedCreatedDate: Date {
        Date(timeIntervalSince1970: createdDate)
    }
    
    public var wrappedType: ResultType {
        if type ?? "" == ResultType.Finish.rawValue {
            return ResultType.Finish
        } else {
            return ResultType.Start
        }
    }
    
    public var wrappedRecordings: [Recording] {
        let set = recordings as? Set<Recording> ?? []
        
        return set.sorted {
            $0.createdDate > $1.createdDate
        }
    }
    
    public var wrappedRecordingsWithoutTimestamps: [Recording] {
        return wrappedRecordings.filter {
            $0.timestamp == 0.0
        }
    }
    
    public var recordingsCSVString: String {
        var csvString: String = ""
        
        for recording in wrappedRecordings {
            csvString.append("\(recording.wrappedPlate),\(recording.timestampString)\n")
        }
        
        return csvString
    }
    
    public var fileName: String {
        var name: String = wrappedName
        if name == "" {
            name = "Untitled_Result"
        }

        return name.replacingOccurrences(of: " ", with: "_") + "_" + (type?.capitalized ?? "Start")
    }
    
    public var missingPlates: Bool {
        return wrappedRecordings.plates().count != wrappedRecordings.count
    }
    
    public var missingTimestamps: Bool {
        return !wrappedRecordingsWithoutTimestamps.isEmpty
    }
    
    public var hasDuplicatePlates: Bool {
        return !wrappedRecordings.plates().duplicates().isEmpty
    }
    
    public var warningCount: Int {
        var count: Int = 0
        if missingPlates {
            count += 1
        }
        if missingTimestamps {
            count += 1
        }
        if hasDuplicatePlates {
            count += 1
        }
        return count
    }
}

// MARK: Generated accessors for recordings
extension Result {

    @objc(addRecordingsObject:)
    @NSManaged public func addToRecordings(_ value: Recording)

    @objc(removeRecordingsObject:)
    @NSManaged public func removeFromRecordings(_ value: Recording)

    @objc(addRecordings:)
    @NSManaged public func addToRecordings(_ values: NSSet)

    @objc(removeRecordings:)
    @NSManaged public func removeFromRecordings(_ values: NSSet)

}

extension Result : Identifiable {

}

