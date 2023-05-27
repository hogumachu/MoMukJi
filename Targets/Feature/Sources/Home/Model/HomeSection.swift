//
//  HomeSection.swift
//  Feature
//
//  Created by 홍성준 on 2023/05/20.
//

import Domain
import RxDataSources

enum HomeSection {
    case food([HomeItem])
    case time([HomeItem])
}

enum HomeItem {
    case title(String)
    case food(HomeFoodCollectionViewCellModel)
    case time(HomeTimeCollectionViewCellModel)
}

extension HomeSection: SectionModelType {
    
    var items: [HomeItem] {
        switch self {
        case .food(let items): return items
        case .time(let items): return items
        }
    }
    
    init(original: HomeSection, items: [HomeItem]) {
        switch original {
        case .food(let items):
            self = .food(items)
            
        case .time(let items):
            self = .time(items)
        }
    }
    
}
