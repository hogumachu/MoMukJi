//
//  Food.swift
//  Domain
//
//  Created by 홍성준 on 2023/05/19.
//

import Foundation

public struct Food {
    
    public let name: String
    public let category: Category?
    public let time: FoodTime?
    
    public init(name: String, category: Category?, time: FoodTime?) {
        self.name = name
        self.category = category
        self.time = time
    }
    
}
