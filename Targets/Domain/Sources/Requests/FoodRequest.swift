//
//  FoodRequest.swift
//  Domain
//
//  Created by 홍성준 on 2023/05/19.
//

import Foundation

public struct FoodRequest {
    
    public let predicate: NSPredicate?
    
    public init(category: String? = nil) {
        guard let category else {
            self.predicate = nil
            return
        }
        self.predicate = NSPredicate(format: "category.name == %@", category)
    }
    
    public init(name: String? = nil) {
        guard let name else {
            self.predicate = nil
            return
        }
        self.predicate = NSPredicate(format: "name == %@", name)
    }
    
}
