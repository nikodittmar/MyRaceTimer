//
//  CoreDataCodable.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 4/22/23.
//

import Foundation

extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

enum DecoderConfigurationError: Error {
    case missingManagedObjectContext
}
