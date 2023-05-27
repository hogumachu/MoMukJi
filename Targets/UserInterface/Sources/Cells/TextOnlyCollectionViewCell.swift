//
//  TextOnlyCollectionViewCell.swift
//  UserInterface
//
//  Created by 홍성준 on 2023/05/27.
//

import UIKit
import SnapKit
import Then

public final class TextOnlyCollectionViewCell: UICollectionViewCell {
    
    public let textLabel = UILabel(frame: .zero)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(text: String, inset: UIEdgeInsets = .zero) {
        textLabel.text = text
        textLabel.snp.remakeConstraints { make in
            make.edges.equalToSuperview().inset(inset)
        }
    }
    
    private func setupLayout() {
        contentView.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupAttributes() {
        textLabel.do {
            $0.textColor = .white
            $0.font = .headerB
            $0.textAlignment = .left
        }
    }
    
}
