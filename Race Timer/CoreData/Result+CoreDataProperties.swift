//
//  Result+CoreDataProperties.swift
//  Race Timer
//
//  Created by niko dittmar on 2/15/23.
//
//

import Foundation
import CoreData


extension Result {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Result> {
        return NSFetchRequest<Result>(entityName: "Result")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var plate: String?
    @NSManaged public var timestamp: Double
    @NSManaged public var timingResult: TimingResult?

    public var unwrappedPlate: String {
        plate ?? ""
    }
    
    public var unwrappedId: UUID {
        id ?? UUID()
    }
    
    public var unwrappedTimestamp: Date {
        Date(timeIntervalSince1970: timestamp)
    }
    
    public var timeString: String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm:ss.SS"
        
        return dateFormatter.string(from: unwrappedTimestamp)
    }
}

extension Result : Identifiable {

}
