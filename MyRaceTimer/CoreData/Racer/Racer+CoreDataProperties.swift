//
//  Racer+CoreDataProperties.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 4/29/23.
//
//

import Foundation
import CoreData


extension Racer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Racer> {
        return NSFetchRequest<Racer>(entityName: "Racer")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var plate: String?
    @NSManaged public var name: String?
    @NSManaged public var result: Result?
    @NSManaged public var stageResults: NSSet?
    
    public var wrappedId: UUID {
        id ?? UUID()
    }
    
    public var wrappedPlate: String {
        plate ?? ""
    }
    
    public var wrappedName: String {
        name ?? ""
    }
    
    public var wrappedStageResults: [StageResult] {
        let set = stageResults as? Set<StageResult> ?? []
        
        return set.sorted {
            $0.overallTime > $1.overallTime
        }
    }
    
    public var overallTime: TimeInterval {
        var overallTime: Double = 0.0
        for stageResult in wrappedStageResults {
            overallTime += stageResult.overallTime
        }
        
        return overallTime
    }
    
    public var overallTimeString: String {
        let dateComponentsFormatter: DateComponentsFormatter = DateComponentsFormatter()
        
        if overallTime == 0.0 {
            return "DNF"
        } else {
            return dateComponentsFormatter.string(from: overallTime) ?? ""
        }
    }
    
    public func timeFor(stage: Stage) -> TimeInterval {
        for stageResult in wrappedStageResults {
            if stage == stageResult.stage {
                return stageResult.overallTime
            }
        }
        return 0.0
    }
    
    public var overallPenalties: TimeInterval {
        var overallPenalties: Double = 0.0
        for stageResult in wrappedStageResults {
            overallPenalties += stageResult.penalty
        }
        
        return overallPenalties
    }
    
    public func penaltyFor(stage: Stage) -> TimeInterval {
        for stageResult in wrappedStageResults {
            if stage == stageResult.stage {
                return stageResult.penalty
            }
        }
        return 0.0
    }

}

// MARK: Generated accessors for stageResults
extension Racer {

    @objc(addStageResultsObject:)
    @NSManaged public func addToStageResults(_ value: StageResult)

    @objc(removeStageResultsObject:)
    @NSManaged public func removeFromStageResults(_ value: StageResult)

    @objc(addStageResults:)
    @NSManaged public func addToStageResults(_ values: NSSet)

    @objc(removeStageResults:)
    @NSManaged public func removeFromStageResults(_ values: NSSet)

}

extension Racer : Identifiable {

}
