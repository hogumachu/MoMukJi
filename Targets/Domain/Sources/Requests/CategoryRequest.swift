//
//  CategoryRequest.swift
//  Domain
//
//  Created by 홍성준 on 2023/05/23.
//

import Foundation

public struct CategoryRequest {
    
    public let predicate: NSPredicate?
    
    public init(category: String? = nil) {
        guard let category else {
            self.predicate = nil
            return
        }
        self.predicate = NSPredicate(format: "name == %@", category)
    }
    
}
