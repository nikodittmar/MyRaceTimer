//
//  Result+CoreDataClass.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 4/18/23.
//
//

import UniformTypeIdentifiers
import Foundation
import CoreData
import SwiftUI
import CoreTransferable

@objc(Result)
public class Result: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
        case name, type, id, createdDate, updatedDate, recordings
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.type = try container.decode(String.self, forKey: .type)
        self.id = UUID()
        self.createdDate = try container.decode(Double.self, forKey: .createdDate)
        self.updatedDate = try container.decode(Double.self, forKey: .updatedDate)
        self.recordings = try container.decode(Set<Recording>.self, forKey: .recordings) as NSSet
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(type, forKey: .type)
        try container.encode(id, forKey: .id)
        try container.encode(createdDate, forKey: .createdDate)
        try container.encode(updatedDate, forKey: .updatedDate)
        try container.encode(recordings as! Set<Recording>, forKey: .recordings)
    }
}
