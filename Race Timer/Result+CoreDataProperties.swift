//
//  Result+CoreDataProperties.swift
//  Race Timer
//
//  Created by niko dittmar on 8/3/22.
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
        dateFormatter.dateFormat = "H:mm:ss.SSSS"
        
        return dateFormatter.string(from: unwrappedTimestamp)
    }

}

extension Result : Identifiable {

}
