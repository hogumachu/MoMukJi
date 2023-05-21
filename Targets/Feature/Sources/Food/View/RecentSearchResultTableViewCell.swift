//
//  RecentSearchResultTableViewCell.swift
//  Feature
//
//  Created by 홍성준 on 2023/05/21.
//

import Core
import UserInterface
import UIKit
import SnapKit
import Then

final class RecentSearchResultTableViewCell: BaseTableViewCell {
    
    private let resultLabel = UILabel(frame: .zero)
    
    func configure(_ text: String?) {
        resultLabel.text = text
    }
    
    override func clear() {
        resultLabel.text = nil
    }
    
    override func setupLayout() {
        contentView.addSubview(resultLabel)
        resultLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
    
    override func setupAttributes() {
        resultLabel.do {
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 17, weight: .regular)
            $0.numberOfLines = 1
            $0.lineBreakMode = .byTruncatingTail
        }
    }
    
}
