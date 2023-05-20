//
//  HomeCollectionViewCell.swift
//  Feature
//
//  Created by 홍성준 on 2023/05/20.
//

import UIKit
import SnapKit
import Then

final class HomeCollectionViewCell: BaseCollectionViewCell {
    
    private let nameLabel = UILabel(frame: .zero)
    private let countLabel = UILabel(frame: .zero)
    
    func configure(_ item: HomeItem) {
        nameLabel.text = item.name
        countLabel.text = "\(item.count)회"
    }
    
    override func clear() {
        nameLabel.text = nil
        countLabel.text = nil
    }
    
    override func setupLayout() {
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.leading.trailing.bottom.equalToSuperview().inset(20)
        }
    }
    
    override func setupAttributes() {
        backgroundColor = .white
        
        nameLabel.do {
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 20, weight: .semibold)
            $0.numberOfLines = 0
            $0.textAlignment = .left
        }
        
        countLabel.do {
            $0.textColor = .systemBlue
            $0.font = .systemFont(ofSize: 17, weight: .regular)
            $0.numberOfLines = 1
            $0.textAlignment = .left
        }
    }
    
}
