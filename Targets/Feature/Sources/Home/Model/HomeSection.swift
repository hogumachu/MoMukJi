//
//  HomeSection.swift
//  Feature
//
//  Created by 홍성준 on 2023/05/20.
//

import RxDataSources

struct HomeSection: Equatable {
    
    var items: [HomeItem]
    
}

struct HomeItem: Equatable, IdentifiableType {
    
    var identity: String {
        return name
    }
    
    let name: String
    let count: Int
    let category: String?
    
}

extension HomeSection: SectionModelType {
    
    typealias Item = HomeItem
    
    init(original: HomeSection, items: [HomeItem]) {
        self = original
        self.items = items
    }
    
}
