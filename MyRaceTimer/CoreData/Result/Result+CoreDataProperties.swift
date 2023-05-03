//
//  Result+CoreDataProperties.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 4/29/23.
//
//

import Foundation
import CoreData


extension Result {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Result> {
        return NSFetchRequest<Result>(entityName: "Result")
    }
    
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var createdDate: Double
    @NSManaged public var updatedDate: Double
    @NSManaged public var racers: NSSet?
    @NSManaged public var stages: NSSet?
    
    public var wrappedId: UUID {
        id ?? UUID()
    }
    
    public var wrappedName: String {
        name ?? ""
    }
    
    public var wrappedCreatedDate: Date {
        Date(timeIntervalSince1970: createdDate)
    }
    
    public var wrappedUpdatedDate: Date {
        Date(timeIntervalSince1970: updatedDate)
    }
    
    public var standings: [Racer] {
        let set = racers as? Set<Racer> ?? []
        
        return set.sorted {
            $0.overallTime < $1.overallTime
        }
    }
    
    public func standingsFor(stage: Stage) -> [Racer] {
        let set = racers as? Set<Racer> ?? []
        
        return set.sorted {
            $0.timeFor(stage: stage) < $1.timeFor(stage: stage)
        }
    }
    
    public var wrappedStages: [Stage] {
        let set = stages as? Set<Stage> ?? []
        
        return set.sorted {
            $0.wrappedName > $1.wrappedName
        }
    }
    
    public var wrappedRacers: [Racer] {
        let set = racers as? Set<Racer> ?? []
        
        return set.sorted {
            $0.wrappedPlate > $1.wrappedPlate
        }
    }
    
    public var label: String {
        let stageCount: Int = wrappedStages.count
        let racerCount: Int = standings.count
        
        let stageLabel: String = stageCount == 1 ? "\(String(stageCount)) Stage" : "\(String(stageCount)) Stages"
        let racerLabel: String = racerCount == 1 ? "\(String(racerCount)) Racer" : "\(String(racerCount)) Racers"
        
        return "\(stageLabel), \(racerLabel)"
    }

}

// MARK: Generated accessors for racers
extension Result {

    @objc(addRacersObject:)
    @NSManaged public func addToRacers(_ value: Racer)

    @objc(removeRacersObject:)
    @NSManaged public func removeFromRacers(_ value: Racer)

    @objc(addRacers:)
    @NSManaged public func addToRacers(_ values: NSSet)

    @objc(removeRacers:)
    @NSManaged public func removeFromRacers(_ values: NSSet)

}

// MARK: Generated accessors for stages
extension Result {

    @objc(addStagesObject:)
    @NSManaged public func addToStages(_ value: Stage)

    @objc(removeStagesObject:)
    @NSManaged public func removeFromStages(_ value: Stage)

    @objc(addStages:)
    @NSManaged public func addToStages(_ values: NSSet)

    @objc(removeStages:)
    @NSManaged public func removeFromStages(_ values: NSSet)

}

extension Result : Identifiable {

}
