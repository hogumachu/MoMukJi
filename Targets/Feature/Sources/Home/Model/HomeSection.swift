//
//  HomeSection.swift
//  Feature
//
//  Created by 홍성준 on 2023/05/20.
//

import RxDataSources

struct HomeSection: Equatable {
    
    let category: String
    var items: [HomeItem]
    
}

struct HomeItem: Equatable, IdentifiableType {
    
    var identity: String {
        return name
    }
    
    let name: String
    let count: Int
    
}

extension HomeSection: AnimatableSectionModelType {
    
    typealias Item = HomeItem
    
    var identity: String {
        return category
    }
    
    init(original: HomeSection, items: [HomeItem]) {
        self = original
        self.items = items
    }
    
}
