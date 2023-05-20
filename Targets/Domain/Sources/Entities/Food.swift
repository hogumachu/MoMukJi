//
//  Food.swift
//  Domain
//
//  Created by 홍성준 on 2023/05/19.
//

import Foundation

public struct Food {
    
    public let name: String
    public let category: String
    public let count: Int
    
    public init(name: String, category: String, count: Int) {
        self.name = name
        self.category = category
        self.count = count
    }
    
}
