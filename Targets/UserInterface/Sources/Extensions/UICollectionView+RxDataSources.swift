//
//  UICollectionView+RxDataSources.swift
//  UserInterface
//
//  Created by 홍성준 on 2023/05/23.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

extension Reactive where Base: UICollectionView {
    
    public func itemSelected<T>(dataSource: CollectionViewSectionedDataSource<T>) -> ControlEvent<T.Item> {
        let source = itemSelected.map { dataSource[$0] }
        return ControlEvent(events: source)
    }
    
}
