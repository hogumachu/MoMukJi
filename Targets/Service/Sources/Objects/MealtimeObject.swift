//
//  MealtimeObject.swift
//  Service
//
//  Created by 홍성준 on 2023/05/29.
//

import Domain
import Foundation
import RealmSwift

final class MealtimeObject: EmbeddedObject {
    
    @Persisted private(set) var year: Int
    @Persisted private(set) var month: Int
    @Persisted private(set) var day: Int
    @Persisted private(set) var slot: Int
    
    convenience init(mealtime: Mealtime) {
        self.init()
        self.year = mealtime.year
        self.month = mealtime.month
        self.day = mealtime.day
        self.slot = mealtime.slot.rawValue
    }
    
    var model: Mealtime {
        return Mealtime(
            year: self.year,
            month: self.month,
            day: self.day,
            slot: MealtimeSlot(rawValue: self.slot)!
        )
    }
    
}

extension Mealtime {
    
    func object() -> MealtimeObject {
        return MealtimeObject(mealtime: self)
    }
}
