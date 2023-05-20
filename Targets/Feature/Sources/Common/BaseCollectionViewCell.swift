//
//  BaseCollectionViewCell.swift
//  Feature
//
//  Created by 홍성준 on 2023/05/20.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        clear()
    }
    
    func clear() {}
    func setupLayout() {}
    func setupAttributes() {}
    
}
