//
//  CategoryListCollectionViewCell.swift
//  Feature
//
//  Created by 홍성준 on 2023/05/22.
//

import UIKit
import SnapKit
import Then


final class CategoryListCollectionViewCell: BaseCollectionViewCell {
    
    private let categoryLabel = UILabel(frame: .zero)
    
    func configure(_ item: CategoryItem) {
        categoryLabel.text = item.name
        categoryLabel.textColor = UIColor(hex: item.textColor)
        backgroundColor = UIColor(hex: item.backgroundColor)
    }
    
    override func clear() {
        categoryLabel.text = nil
        categoryLabel.textColor = .black
        backgroundColor = .white
    }
    
    override func setupLayout() {
        contentView.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
    
    override func setupAttributes() {
        backgroundColor = .white
        layer.cornerRadius = 16
        
        categoryLabel.do {
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 17, weight: .regular)
            $0.textAlignment = .center
            $0.numberOfLines = 1
            $0.lineBreakMode = .byTruncatingTail
        }
    }
    
}
