//
//  MealtimeHelper.swift
//  Feature
//
//  Created by 홍성준 on 2023/05/27.
//

import Domain
import Foundation

final class MealtimeHelper {
    
    private let calendar = Calendar(identifier: .gregorian)
    
    func makeMealtime(using date: Date, slot: MealtimeSlot) -> Mealtime {
        let year = year(from: date)
        let month = month(from: date)
        let day = day(from: date)
        return Mealtime(year: year, month: month, day: day, slot: slot)
    }
    
    func currentMealtimeSlot() -> MealtimeSlot {
        let date = Date()
        let hour = hour(from: date)
        
        if hour >= 5 && hour < 10 {
            return .breakfast
        }
        
        if hour >= 10 && hour < 16 {
            return .lunch
        }
        
        if hour >= 16 && hour < 22 {
            return .dinner
        }
        
        return .midnightSnack
    }
    
    func year(from date: Date) -> Int {
        return calendar.component(.year, from: date)
    }
    
    func month(from date: Date) -> Int {
        return calendar.component(.month, from: date)
    }
    
    func day(from date: Date) -> Int {
        return calendar.component(.day, from: date)
    }
    
    func hour(from date: Date) -> Int {
        return calendar.component(.hour, from: date)
    }
    
}
