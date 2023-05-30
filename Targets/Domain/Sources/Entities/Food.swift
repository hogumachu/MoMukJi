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
    public let mealtimes: [Mealtime]
    public let isFavorite: Bool?
    
    public init(name: String, category: Category?, mealtimes: [Mealtime], isFavorite: Bool? = nil) {
        self.name = name
        self.category = category
        self.mealtimes = mealtimes
        self.isFavorite = isFavorite
    }
    
}
