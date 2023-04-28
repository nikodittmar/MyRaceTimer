//
//  Extensions.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 8/3/22.
//

import Foundation

extension String {
    func occurrencesIn(_ array: [String]) -> Int {
        var count: Int = 0
        for item in array {
            if self == item {
                count += 1
            }
        }
        return count
    }
}

extension Array where Element == String {
    func hasDuplicates() -> Bool {
        if Set(self).count < self.count {
            return true
        } else {
            return false
        }
    }
}

extension Array where Element: Hashable {
    func duplicates() -> Array {
        let groups = Dictionary(grouping: self, by: {$0})
        let duplicateGroups = groups.filter {$1.count > 1}
        let duplicates = Array(duplicateGroups.keys)
        return duplicates
    }
}

extension Array where Element == Recording {
    func plates() -> [String] {
        var plates: [String] = []
        for recording in self {
            if recording.wrappedPlate != "" {
                plates.append(recording.wrappedPlate)
            }
        }
        return plates
    }
    func recordingsWithoutTimestamps() -> [Recording] {
        return self.filter {
            $0.timestamp == 0.0
        }
    }
    
}

extension Array where Element: Equatable {
    func without(_ element: Element) -> [Element] {
        return self.filter {
            $0 != element
        }
    }
}

extension URL: Identifiable {
    public var id: UUID {
        return UUID()
    }
}
