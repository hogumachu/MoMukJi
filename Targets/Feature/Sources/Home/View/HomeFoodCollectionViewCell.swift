//
//  HomeFoodCollectionViewCell.swift
//  Feature
//
//  Created by 홍성준 on 2023/05/20.
//

import Domain
import UserInterface
import UIKit
import SnapKit
import Then

struct HomeFoodCollectionViewCellModel {
    let name: String
    let count: Int
    let category: Domain.Category?
}

final class HomeFoodCollectionViewCell: BaseCollectionViewCell {
    
    private let containerView = UIView(frame: .zero)
    private let nameLabel = UILabel(frame: .zero)
    private let countLabel = UILabel(frame: .zero)
    private let categoryContainerView = UIView(frame: .zero)
    private let categoryLabel = UILabel(frame: .zero)
    
    func configure(_ model: HomeFoodCollectionViewCellModel) {
        nameLabel.text = model.name
        countLabel.text = "\(model.count)회"
        if let category = model.category {
            categoryLabel.text = category.name
            categoryLabel.textColor = UIColor(hex: category.textColor)
            categoryContainerView.backgroundColor = UIColor(hex: category.backgroundColor)
        } else {
            categoryLabel.text = nil
            categoryContainerView.backgroundColor = .clear
        }
    }
    
    override func clear() {
        nameLabel.text = nil
        countLabel.text = nil
        categoryLabel.text = nil
        categoryContainerView.backgroundColor = .clear
    }
    
    override func setupLayout() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        containerView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(30)
            make.trailing.lessThanOrEqualToSuperview().offset(-100)
        }
        
        containerView.addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.bottom.equalToSuperview().offset(-15)
        }
        
        containerView.addSubview(categoryContainerView)
        categoryContainerView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-30)
            make.leading.greaterThanOrEqualTo(nameLabel.snp.trailing)
            make.height.equalTo(30)
        }
        
        categoryContainerView.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { make in
            make.leading.trailing.centerY.equalToSuperview().inset(20)
        }
    }
    
    override func setupAttributes() {
        backgroundColor = .monoblack
        
        containerView.do {
            $0.clipsToBounds = true
            $0.setGradientBackground(
                startColor: .pink2 ?? .systemPink,
                endColor: .yellow1 ?? .yellow,
                startPoint: CGPoint(x: 0.0, y: 0.0),
                endPoint: CGPoint(x: 2.0, y: 2.0)
            )
            $0.layer.cornerRadius = 35
        }
        
        nameLabel.do {
            $0.textColor = .white
            $0.font = .headerB
            $0.numberOfLines = 1
            $0.textAlignment = .left
        }
        
        countLabel.do {
            $0.textColor = .green2
            $0.font = .captionSB
            $0.numberOfLines = 1
            $0.textAlignment = .left
        }
        
        categoryContainerView.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 15
        }
        
        categoryLabel.do {
            $0.font = .captionB
            $0.textAlignment = .center
        }
    }
    
}
