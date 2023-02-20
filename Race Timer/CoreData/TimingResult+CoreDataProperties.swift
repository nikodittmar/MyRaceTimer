//
//  TimingResult+CoreDataProperties.swift
//  Race Timer
//
//  Created by niko dittmar on 2/15/23.
//
//

import Foundation
import CoreData


extension TimingResult {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TimingResult> {
        return NSFetchRequest<TimingResult>(entityName: "TimingResult")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var lastUpdated: Double
    @NSManaged public var start: Bool
    @NSManaged public var loaded: Bool
    @NSManaged public var result: NSSet?
    
   
    public var unwrappedName: String {
        name ?? ""
    }
        
    public var unwrappedId: UUID {
        id ?? UUID()
    }
    
    public var resultArray: [Result] {
        let set = result as? Set<Result> ?? []
        
        return set.sorted {
            $0.timestamp > $1.timestamp
        }
    }
    
    public var plateArray: [String] {
        var plateArray: [String] = []
        for result in resultArray {
            let plate = result.unwrappedPlate
            if plate != "" {
                plateArray.append(plate)
            }
        }
        return plateArray
    }
    
    public var unwrappedUpdatedTimestamp: Date {
        Date(timeIntervalSince1970: lastUpdated)
    }
    
    public var updatedTimeString: String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        return dateFormatter.string(from: unwrappedUpdatedTimestamp)
    }
    
    public var recordingsType: TimingMode {
        if start {
            return .start
        } else {
            return .finish
        }
    }
    
    public var recordingsTypeLabel: String {
        if start {
            return "Start"
        } else {
            return "Finish"
        }
    }
    
    public var recordingCount: Int {
        return resultArray.count
    }
    
    public var hasDuplicatePlates: Bool {
        plateArray.hasDuplicates()
    }
    
    public var hasMissingPlates: Bool {
        //The plate array does not include duplicates so if it is smaller than the overall recording count, there are recordings with missing plate numbers.
        recordingCount > plateArray.count
    }
    
    public var recordingsIssuesCount: Int {
        var warnings: Int = 0
        if hasDuplicatePlates {
            warnings += 1
        }
        if hasMissingPlates {
            warnings += 1
        }
        return warnings
    }

}

// MARK: Generated accessors for result
extension TimingResult {

    @objc(addResultObject:)
    @NSManaged public func addToResult(_ value: Result)

    @objc(removeResultObject:)
    @NSManaged public func removeFromResult(_ value: Result)

    @objc(addResult:)
    @NSManaged public func addToResult(_ values: NSSet)

    @objc(removeResult:)
    @NSManaged public func removeFromResult(_ values: NSSet)

}

extension TimingResult : Identifiable {

}
