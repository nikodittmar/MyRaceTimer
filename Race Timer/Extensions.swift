//
//  Extensions.swift
//  Race Timer
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
