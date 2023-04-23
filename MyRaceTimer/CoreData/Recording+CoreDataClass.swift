//
//  Recording+CoreDataClass.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 4/18/23.
//
//

import Foundation
import CoreData
import CoreTransferable

@objc(Recording)
public class Recording: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
        case timestamp, createdDate, plate, id
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.timestamp = try container.decode(Double.self, forKey: .timestamp)
        self.createdDate = try container.decode(Double.self, forKey: .createdDate)
        self.plate = try container.decode(String.self, forKey: .plate)
        self.id = UUID()
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(createdDate, forKey: .createdDate)
        try container.encode(id, forKey: .id)
        try container.encode(plate, forKey: .plate)
    }
}
