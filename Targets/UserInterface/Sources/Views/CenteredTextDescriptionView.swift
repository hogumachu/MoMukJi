//
//  CenteredTextDescriptionView.swift
//  UserInterface
//
//  Created by 홍성준 on 2023/05/24.
//

import UIKit
import SnapKit
import Then

public final class CenteredTextDescriptionView: UIView {
    
    public let stackView = UIStackView(frame: .zero)
    public let textLabel = UILabel(frame: .zero)
    public let descriptionLabel = UILabel(frame: .zero)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.addArrangedSubview(textLabel)
        stackView.addArrangedSubview(descriptionLabel)
    }
    
    private func setupAttributes() {
        stackView.do {
            $0.axis = .vertical
            $0.spacing = 3
            $0.alignment = .center
            $0.distribution = .equalSpacing
        }
        
        textLabel.do {
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        
        descriptionLabel.do {
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
    }
    
}
