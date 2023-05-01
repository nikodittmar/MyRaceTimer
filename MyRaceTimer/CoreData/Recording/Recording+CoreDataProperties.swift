//
//  Recording+CoreDataProperties.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 4/18/23.
//
//

import Foundation
import CoreData


extension Recording {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recording> {
        return NSFetchRequest<Recording>(entityName: "Recording")
    }

    @NSManaged public var timestamp: Double
    @NSManaged public var createdDate: Double
    @NSManaged public var plate: String?
    @NSManaged public var id: UUID?
    @NSManaged public var recordingSet: RecordingSet?
    
    public var wrappedId: UUID {
        id ?? UUID()
    }
    
    public var wrappedPlate: String {
        plate ?? ""
    }
    
    public var wrappedTimestamp: Date {
        Date(timeIntervalSince1970: timestamp)
    }
    
    public var wrappedCreatedDate: Date {
        Date(timeIntervalSince1970: createdDate)
    }
    
    public var timestampString: String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm:ss.SS"
        if Date(timeIntervalSince1970: 0.0) == wrappedTimestamp {
            return "--:--:--.--"
        } else {
            return dateFormatter.string(from: wrappedTimestamp)
        }
    }
    
    public var plateLabel: String {
        var label = self.wrappedPlate
        if label == "" {
            label = "-       -"
        }
        return label
    }
    
    public var missingTimestamp: Bool {
        return timestamp == 0.0
    }
}

extension Recording : Identifiable {

}
