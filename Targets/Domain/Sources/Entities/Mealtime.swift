//
//  Mealtime.swift
//  Feature
//
//  Created by 홍성준 on 2023/05/29.
//

import Foundation

public struct Mealtime {
    
    public let year: Int
    public let month: Int
    public let day: Int
    public let slot: MealtimeSlot
    
    public init(year: Int, month: Int, day: Int, slot: MealtimeSlot) {
        self.year = year
        self.month = month
        self.day = day
        self.slot = slot
    }
    
}
