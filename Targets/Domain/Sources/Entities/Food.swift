//
//  Food.swift
//  Domain
//
//  Created by 홍성준 on 2023/05/19.
//

import Foundation

public struct Food {
    
    public let name: String
    public let count: Int
    public let category: Category?
    
    public init(name: String, count: Int, category: Category?) {
        self.name = name
        self.count = count
        self.category = category
    }
    
}
