//
//  FoodRequest.swift
//  Domain
//
//  Created by 홍성준 on 2023/05/19.
//

import Foundation

public struct FoodRequest {
    
    public let predicate: NSPredicate?
    
    public init(predicate: NSPredicate? = nil) {
        self.predicate = predicate
    }
    
}
