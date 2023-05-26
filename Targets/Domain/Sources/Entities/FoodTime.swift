//
//  FoodTime.swift
//  Domain
//
//  Created by 홍성준 on 2023/05/26.
//

import Foundation

public struct FoodTime {
    
    public let morningCount: Int
    public let lunchCount: Int
    public let dinnerCount: Int
    public let midnightSnackCount: Int
    
    public init(morningCount: Int, lunchCount: Int, dinnerCount: Int, midnightSnackCount: Int) {
        self.morningCount = morningCount
        self.lunchCount = lunchCount
        self.dinnerCount = dinnerCount
        self.midnightSnackCount = midnightSnackCount
    }
    
    public static let zero = FoodTime(morningCount: 0, lunchCount: 0, dinnerCount: 0, midnightSnackCount: 0)
    
    public var count: Int {
        return self.morningCount + self.lunchCount + self.dinnerCount + self.midnightSnackCount
    }
    
}

public enum FoodTimeEnum {
    
    case morning
    case lunch
    case dinner
    case midnightSnack
    
    public func updating(time: FoodTime) -> FoodTime {
        var morningCount = time.morningCount
        var lunchCount = time.lunchCount
        var dinnerCount = time.dinnerCount
        var midnightSnackCount = time.midnightSnackCount
        switch self {
        case .morning: morningCount += 1
        case .lunch: lunchCount += 1
        case .dinner: dinnerCount += 1
        case .midnightSnack: midnightSnackCount += 1
        }
        return FoodTime(morningCount: morningCount, lunchCount: lunchCount, dinnerCount: dinnerCount, midnightSnackCount: midnightSnackCount)
    }
    
}
