//
//  CategoryObject.swift
//  Service
//
//  Created by 홍성준 on 2023/05/23.
//

import Domain
import RealmSwift

final class CategoryObject: Object {
    
    @Persisted private(set) var name: String
    @Persisted private(set) var textColor: String
    @Persisted private(set) var backgroundColor: String
    
    convenience init(category: Category) {
        self.init()
        self.name = category.name
        self.textColor = category.textColor
        self.backgroundColor = category.backgroundColor
    }
    
    var model: Domain.Category {
        return Category(name: self.name, textColor: self.textColor, backgroundColor: self.backgroundColor)
    }
    
}

extension Category {
    
    func object() -> CategoryObject {
        return CategoryObject(category: self)
    }
    
}
