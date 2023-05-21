//
//  FoodCreateSection.swift
//  Feature
//
//  Created by 홍성준 on 2023/05/21.
//

import RxDataSources

struct FoodCreateSection {
    
    var items: [String]
    
}

extension FoodCreateSection: SectionModelType {
    
    init(original: FoodCreateSection, items: [String]) {
        self = original
        self.items = items
    }
    
}
