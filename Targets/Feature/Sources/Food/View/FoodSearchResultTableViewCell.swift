//
//  FoodSearchResultTableViewCell.swift
//  Feature
//
//  Created by 홍성준 on 2023/05/21.
//

import Core
import UserInterface
import UIKit
import SnapKit
import Then

struct FoodSearchResultTableViewCellModel {
    let food: String
    let count: Int
}

final class FoodSearchResultTableViewCell: BaseTableViewCell {
    
    private let foodLabel = UILabel(frame: .zero)
    private let countLabel = UILabel(frame: .zero)
    
    func configure(_ model: FoodSearchResultTableViewCellModel) {
        foodLabel.text = model.food
        countLabel.text = "\(model.count)회"
    }
    
    override func clear() {
        foodLabel.text = nil
        countLabel.text = nil
    }
    
    override func setupLayout() {
        contentView.addSubview(foodLabel)
        foodLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(foodLabel.snp.bottom).offset(3)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    override func setupAttributes() {
        backgroundColor = .monoblack
        
        foodLabel.do {
            $0.textColor = .white
            $0.font = .bodySB
            $0.textAlignment = .left
            $0.numberOfLines = 1
            $0.lineBreakMode = .byTruncatingTail
        }
        
        countLabel.do {
            $0.textColor = .green2
            $0.font = .captionSB
            $0.textAlignment = .left
            $0.numberOfLines = 1
            $0.lineBreakMode = .byTruncatingTail
        }
    }
    
}
