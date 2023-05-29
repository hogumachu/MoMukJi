//
//  FoodTimeHelper.swift
//  Feature
//
//  Created by 홍성준 on 2023/05/27.
//

import Domain
import Foundation

final class FoodTimeHelper {
    
    private let calendar = Calendar(identifier: .gregorian)
    
    func currentTimeEnum() -> FoodTimeEnum {
        let date = Date()
        let hour = hour(from: date)
        
        if hour >= 5 && hour < 10 {
            return .morning
        }
        
        if hour >= 10 && hour < 16 {
            return .lunch
        }
        
        if hour >= 16 && hour < 22 {
            return .dinner
        }
        
        return .midnightSnack
    }
    
    func hour(from date: Date) -> Int {
        return calendar.component(.hour, from: date)
    }
    
}
