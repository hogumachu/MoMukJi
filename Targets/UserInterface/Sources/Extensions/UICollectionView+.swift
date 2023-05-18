//
//  UICollectionView+.swift
//  UserInterface
//
//  Created by 홍성준 on 2023/05/18.
//

import UIKit

extension UICollectionView {
    
    public func register<T: UICollectionViewCell>(_ cell: T.Type) {
        let identifier = String(describing: cell)
        register(cell, forCellWithReuseIdentifier: identifier)
    }
    
    public func dequeueCell<T: UICollectionViewCell>(_ cell: T.Type, for indexPath: IndexPath) -> T? {
        let identifier = String(describing: cell)
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T
    }
    
}
