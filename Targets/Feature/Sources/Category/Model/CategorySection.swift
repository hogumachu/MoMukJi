//
//  CategorySection.swift
//  Feature
//
//  Created by 홍성준 on 2023/05/23.
//

import RxDataSources

struct CategorySection: Equatable {
    
    var items: [CategoryItem]
    
}

struct CategoryItem: Equatable, IdentifiableType {
    
    var identity: String {
        return name
    }
    
    let name: String
    let textColor: String
    let backgroundColor: String
    
}

extension CategorySection: SectionModelType {
    
    init(original: CategorySection, items: [CategoryItem]) {
        self = original
        self.items = items
    }
    
}
