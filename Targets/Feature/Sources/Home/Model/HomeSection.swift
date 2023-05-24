//
//  HomeSection.swift
//  Feature
//
//  Created by 홍성준 on 2023/05/20.
//

import Domain
import RxDataSources

struct HomeSection: Equatable {
    
    var items: [HomeItem]
    
}

struct HomeItem: Equatable, IdentifiableType {
    
    static func == (lhs: HomeItem, rhs: HomeItem) -> Bool {
        lhs.identity == rhs.identity
    }
    
    
    var identity: String {
        return name
    }
    
    let name: String
    let count: Int
    let category: Domain.Category?
    
}

extension HomeSection: SectionModelType {
    
    typealias Item = HomeItem
    
    init(original: HomeSection, items: [HomeItem]) {
        self = original
        self.items = items
    }
    
}
