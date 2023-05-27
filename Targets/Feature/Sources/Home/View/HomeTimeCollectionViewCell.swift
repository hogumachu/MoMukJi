//
//  HomeTimeCollectionViewCell.swift
//  Feature
//
//  Created by 홍성준 on 2023/05/27.
//

import Domain
import UserInterface
import UIKit
import SnapKit
import Then

struct HomeTimeCollectionViewCellModel {
    let name: String
    let count: Int
    let totalCount: Int
    let category: Domain.Category?
}


final class HomeTimeCollectionViewCell: BaseCollectionViewCell {
    
    private let containerView = UIView(frame: .zero)
    private let nameLabel = UILabel(frame: .zero)
    private let totalCountLabel = UILabel(frame: .zero)
    private let countLabel = UILabel(frame: .zero)
    private let categoryContainerView = UIView(frame: .zero)
    private let categoryLabel = UILabel(frame: .zero)
    
    func configure(_ model: HomeTimeCollectionViewCellModel) {
        nameLabel.text = model.name
        totalCountLabel.text = "\(model.totalCount)회 중"
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
        totalCountLabel.text = nil
        countLabel.text = nil
        categoryLabel.text = nil
        categoryContainerView.backgroundColor = .clear
    }
    
    override func setupLayout() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-4)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        containerView.addSubview(categoryContainerView)
        categoryContainerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
            make.bottom.equalTo(nameLabel.snp.top).offset(-5)
        }
        
        categoryContainerView.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { make in
            make.leading.trailing.centerY.equalToSuperview().inset(20)
        }
        
        containerView.addSubview(totalCountLabel)
        totalCountLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        containerView.addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(totalCountLabel.snp.bottom).offset(2)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    override func setupAttributes() {
        backgroundColor = .monoblack
        
        containerView.do {
            $0.clipsToBounds = true
            $0.setGradientBackground(
                startColor: .blue1 ?? .blue,
                endColor: .yellow1 ?? .yellow,
                startPoint: CGPoint(x: 0, y: 0.5),
                endPoint: CGPoint(x: 1.5, y: 0.5)
            )
            $0.layer.cornerRadius = 16
        }
        
        nameLabel.do {
            $0.textColor = .white
            $0.font = .headerB
            $0.numberOfLines = 1
            $0.textAlignment = .center
        }
        
        totalCountLabel.do {
            $0.textColor = .monogray3
            $0.font = .captionSB
            $0.numberOfLines = 1
            $0.textAlignment = .center
        }
        
        countLabel.do {
            $0.textColor = .green2
            $0.font = .headerSB
            $0.numberOfLines = 1
            $0.textAlignment = .center
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
