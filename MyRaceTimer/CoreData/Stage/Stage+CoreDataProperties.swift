//
//  Stage+CoreDataProperties.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 4/29/23.
//
//

import Foundation
import CoreData


extension Stage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Stage> {
        return NSFetchRequest<Stage>(entityName: "Stage")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var stageResults: NSSet?
    @NSManaged public var result: Result?
    
    public var wrappedId: UUID {
        id ?? UUID()
    }
    
    public var wrappedName: String {
        name ?? ""
    }

}

// MARK: Generated accessors for stageResults
extension Stage {

    @objc(addStageResultsObject:)
    @NSManaged public func addToStageResults(_ value: StageResult)

    @objc(removeStageResultsObject:)
    @NSManaged public func removeFromStageResults(_ value: StageResult)

    @objc(addStageResults:)
    @NSManaged public func addToStageResults(_ values: NSSet)

    @objc(removeStageResults:)
    @NSManaged public func removeFromStageResults(_ values: NSSet)

}

extension Stage : Identifiable {

}
