//
//  FoodTimeObject.swift
//  Service
//
//  Created by 홍성준 on 2023/05/26.
//

import Domain
import Foundation
import RealmSwift

final class FoodTimeObject: EmbeddedObject {
    
    @Persisted private(set) var morningCount: Int
    @Persisted private(set) var lunchCount: Int
    @Persisted private(set) var dinnerCount: Int
    @Persisted private(set) var midnightSnackCount: Int
    
    convenience init(morningCount: Int, lunchCount: Int, dinnerCount: Int, midnightSnackCount: Int) {
        self.init()
        self.morningCount = morningCount
        self.lunchCount = lunchCount
        self.dinnerCount = dinnerCount
        self.midnightSnackCount = midnightSnackCount
    }
    
    var model: FoodTime {
        return FoodTime(
            morningCount: self.morningCount,
            lunchCount: self.lunchCount,
            dinnerCount: self.dinnerCount,
            midnightSnackCount: self.midnightSnackCount
        )
    }
    
}


extension FoodTime {
    
    func object() -> FoodTimeObject {
        return FoodTimeObject(
            morningCount: self.morningCount,
            lunchCount: self.lunchCount,
            dinnerCount: self.dinnerCount,
            midnightSnackCount: self.midnightSnackCount
        )
    }
    
}
