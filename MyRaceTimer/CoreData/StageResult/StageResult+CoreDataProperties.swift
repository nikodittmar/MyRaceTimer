//
//  StageResult+CoreDataProperties.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 4/29/23.
//
//

import Foundation
import CoreData

extension StageResult {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StageResult> {
        return NSFetchRequest<StageResult>(entityName: "StageResult")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var startTime: Double
    @NSManaged public var endTime: Double
    @NSManaged public var penalty: Double
    @NSManaged public var racer: Racer?
    @NSManaged public var stage: Stage?
    
    public var wrappedId: UUID {
        id ?? UUID()
    }
    
    public var overallTime: TimeInterval {
        return endTime - startTime + penalty
    }
    
    public var wrappedStartTime: Date {
        return Date(timeIntervalSince1970: startTime)
    }
    
    public var wrappedEndTime: Date {
        return Date(timeIntervalSince1970: endTime)
    }

}

extension StageResult : Identifiable {

}
