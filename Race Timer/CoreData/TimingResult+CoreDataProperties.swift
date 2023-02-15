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
    
    public var unwrappedUpdatedTimestamp: Date {
        Date(timeIntervalSince1970: lastUpdated)
    }
    
    public var updatedTimeString: String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        return dateFormatter.string(from: unwrappedUpdatedTimestamp)
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
