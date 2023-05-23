//
//  Category.swift
//  Domain
//
//  Created by 홍성준 on 2023/05/23.
//

import Foundation

public struct Category {
    
    public let name: String
    public let textColor: String
    public let backgroundColor: String
    
    public init(name: String, textColor: String, backgroundColor: String) {
        self.name = name
        self.textColor = textColor
        self.backgroundColor = backgroundColor
    }
    
}
